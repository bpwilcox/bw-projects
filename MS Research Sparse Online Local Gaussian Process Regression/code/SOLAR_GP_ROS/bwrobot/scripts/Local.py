import numpy as np
import GPy
import osgpr_GPy
import circstats
class LocalModels():
    
    
    def __init__(self, num_inducing = 15, wgen = 0.975,  W = [], LocalData = [], Models = [], drift = 10, mdrift = [],ndim = 2,robot = []):
        
        """
        wgen
        W
        Models
        LocalData
        """        
#        np.random.seed(0)
        
        self.wgen = wgen
        self.W = W
        self.Models = Models
        self.LocalData = LocalData
        self.M = len(self.LocalData)
        self.num_inducing = num_inducing
        self.Z = []
        self.drift = 10
        self.mdrift = mdrift
#        self.ndim = ndim
        self.robot= robot
        self.ndim = self.robot.num_links
#        self.XI = []
#        self.YI = []
        

        
        
    def initialize(self, njit, start, robot):
        "Initialize Local Models: jitter -> partition -> model "

        [XI,YI] = self.jitter(njit,start,robot)
#        YI[YI<0] += 2*np.pi
        YI = np.unwrap(YI,axis = 0)
        self.XI = XI
        self.YI = YI

        m = self.train_init(XI,YI,self.num_inducing) 
        self.mdrift = m

        W = np.diag([1/(m.kern.lengthscale[0]**2), 1/(m.kern.lengthscale[1]**2)])
        
        self.Z.append(m.Z)
        self.W = W        
        self.Models.append(m)
        
        X_loc = []
        X_loc.append(XI[0].reshape(1,2))
#        X_loc.append(1)        
        X_loc.append(YI[0].reshape(1,self.ndim))
#        X_loc.append(0)
        X_loc.append(XI[0].reshape(1,2))
        X_loc.append(YI[0].reshape(1,self.ndim))
        X_loc.append(True)
        self.LocalData.append(X_loc)        
        self.M = len(self.LocalData)
        self.partition(XI[1:],YI[1:])
        self.train()

        
    def initCos(self, njit, start, robot):
        "Initialize Local Models: jitter -> partition -> model "

        [XI,YI] = self.jitCos(njit,start,robot)

        self.XI = XI
        self.YI = YI

        m = self.train_init(XI,YI,self.num_inducing) 
        self.mdrift = m

        W = np.diag([1/(m.kern.lengthscale[0]**2), 1/(m.kern.lengthscale[1]**2)])
        
        self.Z.append(m.Z)
        self.W = W        
        self.Models.append(m)
        
        X_loc = []
        X_loc.append(XI[0].reshape(1,2))
        X_loc.append(YI[0].reshape(1,self.ndim))
        X_loc.append(XI[0].reshape(1,2))
        X_loc.append(False)
        self.LocalData.append(X_loc)        
        self.M = len(self.LocalData)
        self.partition(XI[1:],YI[1:])
        self.train()

    def train(self):
        
         for j,upd in enumerate(self.LocalData):
             if upd[4]:
                 if np.any(self.UpdateX[j]==None):  
                     continue
                 else:
                     m = self.doOSGPR(self.UpdateX[j],self.UpdateY[j],self.Models[j], self.num_inducing, fixTheta = True,use_old_Z=True)
#                     m = self.doOSGPR(self.UpdateX[j],self.UpdateY[j],self.mdrift, self.num_inducing, fixTheta = False, driftZ = False,use_old_Z=False) 

                     m.likelihood.variance = self.mdrift.likelihood.variance
                     m.kern.variance =  self.mdrift.kern.variance
                     m.kern.lengthscale =  self.mdrift.kern.lengthscale
                     self.Models[j]  = m
                     self.Z[j] = m.Z
#                     W = np.diag([m.rbf.lengthscale[0], m.rbf.lengthscale[1]])
#                     W = np.diag([1/(m.rbf.lengthscale[0]**2), 1/(m.rbf.lengthscale[1]**2)])
                     
#                     self.W[j] = W

             
             else:
                 print("Add New Model")
#                 m = self.train_init(upd[0],upd[1],self.num_inducing)
#                 m = self.doOSGPR(upd[0],upd[1],self.Models[j-1], self.num_inducing, fixTheta = False, driftZ = False,use_old_Z=True) 
                 m = self.doOSGPR(upd[0],upd[1],self.mdrift, self.num_inducing, fixTheta = False, driftZ = False,use_old_Z=True) 
         
                 self.Models.append(m)
                 self.LocalData[j][4] = True
                 self.Z.append(m.Z)
                        
    def jitter(self,n,Y_init, robot):
     
        deg = 5
        max_rough=0.0174533
        pert = deg*max_rough * np.random.uniform(-1.,1.,(n,self.ndim))
        
#        pert1=deg*max_rough * np.random.uniform(-1.,0.,(n,self.ndim))
#        pert2=deg*max_rough * np.random.uniform(0.,1.,(n,self.ndim))
#        pert3=deg*max_rough * np.random.uniform(-1.,1.,(n,self.ndim))
#        pert = np.vstack((pert1,pert2,pert3))
        Y_start = Y_init + pert
        X_start = robot.fkin(Y_start)
        
        return X_start,Y_start
    
    def jitCos(self,n,Y_init, robot):
     
        deg = 5
        max_rough=0.0174533
        pert = deg*max_rough * np.random.uniform(-1.,1.,(n,int(self.ndim/2)))
        
        Y_start = Y_init + pert
        X_start = robot.fkin(Y_start)
        
        YCos = np.cos(Y_start)
        YSin = np.sin(Y_start)
        Y = np.hstack((YCos,YSin))
        
        return X_start,Y  
    
    def train_init(self,X, Y, num_inducing):
#        print("initialize first sparse model...")
        if len(X) < num_inducing:
            num_inducing = len(X)        
        Z = X[np.random.permutation(X.shape[0])[0:num_inducing], :]

#        Y = Y + 2*np.pi
        m_init = GPy.models.SparseGPRegression(X,Y,GPy.kern.RBF(2,ARD=True),Z=Z)
        m_init.optimize(messages=False)
        
        return m_init
       
    def partition(self,xnew,ynew):
#        print("partitioning...")
        pind = np.empty(len(xnew))
        M = len(self.LocalData)
        M_loc = self.LocalData
        W = self.W
#        print(W)
        
        UpdateX = [None] * M
        UpdateY = [None] * M
        

        
        for n in range(0,np.shape(xnew)[0],1):
            w = np.empty([M,1])
            dcw = np.empty([self.M, 1])
            
            for k in range(0,M,1):
#                print(k)
                c = M_loc[k][2] #1x2
                d = self.LocalData[k][3]
                
#                c = np.mean(self.Models[k].Z,axis = 0)
#                xW = np.dot((xnew[n]-c),W[k]) # 1x2 X 2x2
                xW = np.dot((xnew[n]-c),W) # 1x2 X 2x2                          
                w[k] = np.exp(-0.5*np.dot(xW,np.transpose((xnew[n]-c))))
#                dcw[k] = np.dot(d-ynew[n],np.transpose(d-ynew[n]))                    
                
#                w[k] = self.mdrift.kern.K(xnew[n].reshape(1,2),c.reshape(1,2))
                
#                w[k] = self.Models[k].kern.K(xnew[n].reshape(1,2),c.reshape(1,2))
#            wv = w*np.exp(-0.5*dcw)   
            wv = w
            wnear = np.max(wv)
            near = np.argmax(wv)
            print(wnear)
            
            if wnear > self.wgen:
                
                if np.any(UpdateX[near]==None):
                    
                    UpdateX[near] = xnew[n].reshape(1,2)
                    UpdateY[near] = ynew[n].reshape(1,self.ndim)  
                else:                     
                
                    UpdateX[near] = np.vstack((UpdateX[near],xnew[n]))
                    UpdateY[near] = np.vstack((UpdateY[near],ynew[n]))

                
                
                M_loc[near][0] = np.vstack((M_loc[near][0],xnew[n]))
#                M_loc[near][0] += 1
                M_loc[near][1] = np.vstack((M_loc[near][1],ynew[n]))
#                M_loc[near][1] = 0
#                M_loc[near][2] = np.add(M_loc[near][2]*(M_loc[near][0]-1),xnew[n].reshape(1,2))/M_loc[near][0]
                M_loc[near][2] = np.mean(M_loc[near][0],axis=0)
                M_loc[near][3] = np.mean(M_loc[near][1],axis=0)
#                M_loc[near][3] = np.add(M_loc[near][2]*(M_loc[near][0]-1),xnew[n].reshape(1,2))/M_loc[near][0]
                
#                M_loc[near][4] = False
                
                pind[n] = near
            else:
                                
                UpdateX.append(xnew[n].reshape(1,2))
                UpdateY.append(ynew[n].reshape(1,self.ndim))
                
                M_new = []
                M_new.append(xnew[n].reshape(1,2))
#                M_new.append(1)
                M_new.append(ynew[n].reshape(1,self.ndim))
#                M_new.append(0)       
                M_new.append(xnew[n].reshape(1,2))               
                M_new.append(ynew[n].reshape(1,self.ndim))
                M_new.append(False)
                M_loc.append(M_new)
                
                M = M+1
#                self.M = M
#                self.LocalData = M_loc
#                self.UpdateX = UpdateX
#                self.UpdateY = UpdateY
#                self.train()
                
                pind[n] = len(M_loc)-1
                
        self.M = M
        self.LocalData = M_loc
        self.UpdateX = UpdateX
        self.UpdateY = UpdateY
                

    def init_Z(self,cur_Z, new_X, num_inducing, use_old_Z=True, driftZ=False):
    
        """
        Initialization ideas:
            1) Add new experience points up to num_inducing (if we change num_inducing)
            2) randomly delete current points down to num_inducing
            3) always add new experience into support point (and randomly delete current support point(s))
        """
        
        
        M = cur_Z.shape[0]    
        if driftZ:
            if M < num_inducing:
                M_new = num_inducing - M
                old_Z = cur_Z[np.random.permutation(M), :]
                new_Z = new_X[np.random.permutation(new_X.shape[0])[0:M_new],:]
                Z = np.vstack((old_Z, new_Z))    
#                print(len(Z))
            else:               
                M = cur_Z.shape[0]
                M_old = M - len(new_X)
                M_new = M - M_old
    #            old_Z = cur_Z[0:M_old, :]
                old_Z = cur_Z[M_new:,:]
                new_Z = new_X[np.random.permutation(new_X.shape[0])[0:M_new], :]
                Z = np.vstack((old_Z, new_Z))                    
        
        elif M < num_inducing:
            M_new = num_inducing - M
            old_Z = cur_Z[np.random.permutation(M), :]
            new_Z = new_X[np.random.permutation(new_X.shape[0])[0:M_new],:]
            Z = np.vstack((old_Z, new_Z)) 
            
        elif M > num_inducing:
            M_new = M - num_inducing
            old_Z = cur_Z[np.random.permutation(M), :]
            Z = np.delete(old_Z, np.arange(0,M_new),axis = 0)
        elif use_old_Z:
            Z = np.copy(cur_Z)
#        elif driftZ:
#            M = cur_Z.shape[0]
#            M_old = M - len(new_X)
#            M_new = M - M_old
##            old_Z = cur_Z[0:M_old, :]
#            old_Z = cur_Z[M_new:,:]
#            new_Z = new_X[np.random.permutation(new_X.shape[0])[0:M_new], :]
#            Z = np.vstack((old_Z, new_Z))            
            
        else:
            M = cur_Z.shape[0]
            M_old = int(0.5 * M)
#            M_old = M - len(new_X)
            M_new = M - M_old
            old_Z = cur_Z[np.random.permutation(M)[0:M_old], :]
            new_Z = new_X[np.random.permutation(new_X.shape[0])[0:M_new], :]
            Z = np.vstack((old_Z, new_Z))
            
    #        print(Z.shape[0])
    #    print(Z)
        return Z
    
    def doOSGPR(self,X,Y,m_old, num_inducing,use_old_Z=True, driftZ = False, fixTheta = False):
    
        Zopt = m_old.Z.param_array
        mu, Su = m_old.predict(Zopt, full_cov = True)
#        mu = np.unwrap(mu)
#        mu[mu<0] += 2*np.pi
#        mu = mu +2*np.pi
        Su = Su + 1e-4*np.eye(mu.shape[0])
    
        Kaa = m_old.kern.K(Zopt)
        
        Zinit = self.init_Z(Zopt, X, num_inducing, use_old_Z, driftZ)
    
#        m_new = osgpr_GPy.OSGPR_VFE(X, Y, GPy.kern.RBF(2,ARD=True), mu, Su, Kaa, 
#            Zopt, Zinit)
#        Y = Y-2*np.pi
#        Y = circstats.wrapdiff(Y)
#        Y = Y + 2*np.pi        
        
        m_new = osgpr_GPy.OSGPR_VFE(X, Y, GPy.kern.RBF(2,ARD=True), mu, Su, Kaa, 
            Zopt, Zinit)
        
#        m_new = osgpr_GPy.OSGPR_VFE(X, Y, GPy.kern.RBF(2,ARD=True), mu, Su, Kaa, 
#            Zopt, Zinit)          
        m_new.likelihood.variance = m_old.likelihood.variance
        m_new.kern.variance = m_old.kern.variance
        m_new.kern.lengthscale = m_old.kern.lengthscale
#        
#        m_new.likelihood.variance = self.mdrift.likelihood.variance
#        m_new.kern.variance =  self.mdrift.kern.variance
#        m_new.kern.lengthscale =  self.mdrift.kern.lengthscale        
        
        
        "Fix parameters"
        if driftZ:        
#            m_new.kern.fix()
#            m_new.likelihood.variance.fix()   
            m_new.Z.fix()
            
        if fixTheta:
            m_new.kern.fix()
            m_new.likelihood.variance.fix()             

        m_new.optimize(messages=False)
        
        m_new.Z.unfix()
        m_new.kern.unfix()
        m_new.likelihood.variance.unfix()   

        return m_new
    
    def circular_mean(self,weights,angles):
        x = y = 0
        for angle, weight in zip(angles,weights):
            x += np.cos(angle)*weight
            y += np.sin(angle)*weight
            
        mean = np.arctan2(y,x)
        return mean

        
    def prediction(self,xtest, weighted = True, bestm = 2, Y_prev = []):
        ypred = np.empty([np.shape(xtest)[0], self.ndim])
#        print(Y_prev)
        for n in range(0, np.shape(xtest)[0], 1):
            w = np.empty([self.M, 1])
            dw = np.empty([self.M, 1])
            dc = np.empty([self.M, 1])
            dcw = np.empty([self.M, 1])

            yploc = np.empty([self.M,self.ndim])
                    
            var = np.empty([self.M,1])
            for k in range(0, self.M, 1):
                
                
                try:
    #                print(k)
                    c = self.LocalData[k][2] #1x2
                    d = self.LocalData[k][3]
    #                d = self.UpdateY[k][-1]
    #                dd = self.LocalData[k][1][-1]
    #                dp = Y_prev
    #                c = np.mean(self.Models[k].Z,axis = 0)
    #                xW = np.dot((xtest[n]-c),self.W[k]) # 1x2 X 2x2
    #                xW = self.Models[k].kern.K(xtest[n],c)
                    xW = np.dot((xtest[n]-c),self.W) # 1x2 X 2x2
#                    print(xW)
                    w[k] = np.exp(-0.5*np.dot(xW,np.transpose((xtest[n]-c))))
    #                w[k] = self.Models[k].kern.K(xtest[n].reshape(1,2),c.reshape(1,2))
                    yploc[k], var[k] = self.Models[k].predict(xtest[n].reshape(1,2))
#                    print(yploc[k])
#                    Ypost = np.vstack((Y_prev,yploc[k]))
#                    print(Ypost)
#                    Ypost = np.unwrap(Ypost,axis=0)
#                    print(Ypost)

#                    yploc[k]= Ypost[-1].reshape(1,2)
#                    print(yploc[k])
#                    print(var[k])
#                        dw[k] = np.exp(-0.5*np.dot(yploc[k]-Y_prev,np.transpose(yploc[k]-Y_prev)))
    #                    dc[k] = np.exp(-0.5*np.dot(yploc[k]-d,np.transpose(yploc[k]-d)))
    #                    dcw[k] = np.exp(-0.5*np.dot(d-Y_prev,np.transpose(d-Y_prev)))
                    dw[k] = np.dot(yploc[k]-Y_prev[-1].reshape(1,self.ndim),np.transpose(yploc[k]-Y_prev[-1].reshape(1,self.ndim)))
#                    dw[k] = np.linalg.norm(circstats.difference(yploc[k],Y_prev))
#                    dc[k] = np.dot(yploc[k]-d,np.transpose(yploc[k]-d))
#                    dcw[k] = np.dot(d-Y_prev,np.transpose(d-Y_prev))                    
                except:
                    w[k] = 0
                    dw[k] = float("inf")
#                    dc[k] = float("inf")
#                    dcw[k] = float("inf")
#                    var[k] = float("inf")
                    pass
#            yploc = yploc-2*np.pi
#            yploc[yploc<0] += 2*np.pi

#            yploc = np.unwrap(yploc)

#            c = np.mean(self.mdrift.Z,axis = 0)            
#            xW = np.dot((xtest[n]-c),self.W) # 1x2 X 2x2           
#            w[k+1] = np.exp(-0.5*np.dot(xW,np.transpose((xtest[n]-c))))                
#            yploc[k+1], var[k+1] = self.mdrift.predict(xtest[n].reshape(1,2))
              
            if weighted:
                if bestm > self.M:    
                    h = self.M 
                else:
                    h = bestm
            else:
                h = 1
                
#            wv = np.multiply(w, np.exp(-var))
#            wv = np.exp(-var)
#            wv = w/var
            wv = w*np.exp(-10*dw)/var
            wv =np.nan_to_num(wv)
#            wv = w*dc*np.exp(-0.5*var)
#            wv = w/(var*dc*dw)
#            wv = w*np.exp(-dcw)*np.exp(-dw)/(var)
#            wv = w*np.exp(-dcw)/(var)
            
#            wv = w/(var*(dcw+1e4))
            
#            wv = dw/var
#            wv = w/(dw*var)
            
#            wv = w
#            wv = w.reshape(self.M,1)
            wv = wv.reshape(self.M,)
            
#            wv = w[w>0.9]
            thresh = 0
#            wv = wv/np.sum(wv)       
            if np.max(wv) < thresh:
#                ind = np.argmax(wv)    
                ind = wv ==np.max(wv)
            else:
                ind = wv > thresh
            
#            ind = np.argmax(wv)     

                 
#            print(np.argmax(wv))
#            print(ind)
#            print(wv.reshape(self.M,)>0.9)
#            ind = np.argpartition(wv[:,0], -h)[-h:]
#            print(ind)
#            ypred[n] = np.dot(np.transpose(wv[wv>0.8]), yploc[wv>0.8]) / np.sum(wv[wv>0.8])

#            ypred[n] = np.dot(np.transpose(wv[ind]), yploc[ind]) / np.sum(wv[ind])
#            print(ypred)
#            print(wv.shape)
#            print(yploc.shape)
#            print(yploc[0])
#            yploc[yploc<0] += 2*np.pi
#            yploc = np.unwrap(yploc)
#            ypred[n] = self.circular_mean(wv[ind].reshape(np.sum(ind),1),yploc[ind])    

#            ypred[n] = circstats.mean(yploc[ind],axis = 0,w = wv[ind])
            ypred[n] = circstats.mean(yploc,axis = 0,w = wv.reshape(len(wv),1))       
#            ypred[n] = np.dot(np.transpose(wv[ind]), yploc[ind]) / np.sum(wv[ind])
#            ypred[n] = ypred[n] + 2*np.pi 
#            ypred[n][ypred[n]<0] += 2*np.pi
#            ypred[n][ypred[n]>2*np.pi] -= 2*np.pi
#            delta = ypred[n]-Y_prev
##            new = Y_prev+delta*np.exp(-5*np.min(var))
#            new = Y_prev+delta*np.max(wv)
            
#            ypred[n] = new
#            ypred[n] = np.array([self.circular_mean(wv,yploc[:,0]),self.circular_mean(wv,yploc[:,1])])
            print("wv:" + str(wv))
#            print("w:" + str(w))
#            print("dw:" + str(dw))
##            print("dc:" + str(dc))
#            print("var:" + str(var))
##            print("dcw:" + str(dcw))
#
##            print(ind)
#
#            print(yploc[ind])
#            print(ypred[n])
#            print(dw)
            
        return ypred