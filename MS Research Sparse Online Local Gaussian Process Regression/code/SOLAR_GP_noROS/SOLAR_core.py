import numpy as np
import GPy
import osgpr_GPy
import circstats
class LocalModels():


    def __init__(self, num_inducing = 15, wgen = 0.975,  W = [], drift = 1, mdrift = [], robot = [], xdim = [], ndim = []):

        """
        wgen
        W
        Models
        LocalData
        """

        self.wgen = wgen # threshold for partitioning
        self.W = W # width hyperparameters from drift GP
        self.Models = [] #Local GP Models
        self.LocalData = [] # Local model partition data
        self.M = len(self.LocalData) #number of models
        self.num_inducing = num_inducing # number of inducing support points
        self.Z = [] # Support points
        self.drift = drift
        self.mdrift = mdrift # drifting GP
        self.robot= robot # robot model
        self.xdim = xdim
        self.ndim = ndim
        self.encode = False
        self.var = np.array(0)
        self.Ws = []

    def encode_ang(self, q):
        encoding = np.hstack((np.sin(q),np.cos(q))).reshape(np.size(q,0), np.size(q,1)*2)
        return encoding
    
    def decode(self, q):
        d = int(np.size(q,1)/2)
        decoding = np.arctan2(q[:,:d], q[:,d:]).reshape(np.size(q,0),d)
        return decoding
    
    def initialize(self, njit, start, encode = False):
        "Initialize Local Models: jitter -> partition -> model "
        self.xdim = self.robot.dim
        self.ndim = np.size(start,1)
        [XI,YI] = self.robot_jitter(njit,start)

        if encode:
            self.encode = True
            YI = self.encode_ang(YI)
            self.ndim = np.size(YI,1)
        else:
            YI = np.unwrap(YI,axis = 0)

        self.XI = XI # initial model input points
        self.YI = YI # initial model outpout points

        # convert features to sin(angle), cos(angle)
        m = self.train_init(XI,YI,self.num_inducing)
        self.mdrift = m

        mkl = []
        for i in range(0, self.xdim):
            mkl.append(1/(m.kern.lengthscale[i]**2))
        W = np.diag(mkl)

        self.Z.append(m.Z)
        self.W = W
        self.Ws.append(W)
        self.Models.append(m)

        X_loc = []
        X_loc.append(1) # counter for number of local points partitioned
        X_loc.append(1) # redundant, same as above
        X_loc.append(XI[0].reshape(1,self.xdim)) # input model center (i.e. [xc,yc])
        X_loc.append(YI[0].reshape(1,self.ndim)) #output model center (i.e. [q1, q2, q3,...])
        X_loc.append(True) # flag for whether model has been updated with latest partition
        self.LocalData.append(X_loc)

        self.M = len(self.LocalData)
        self.UpdateX = [None] * self.M # holds partitioned points for updating models
        self.UpdateY = [None] * self.M

        self.partition(XI[1:],YI[1:])
        self.train()

    def initializeF(self, XI, YI, encode = True):
        "Initialize Local Models: jitter -> partition -> model "
        m = self.train_init(XI,YI,self.num_inducing)
        self.encode = encode
        self.mdrift = m

        mkl = []
        for i in range(0, self.xdim):
            mkl.append(1/(m.kern.lengthscale[i]**2))
        W = np.diag(mkl)

        self.Z.append(m.Z)
        self.W = W
        self.Ws.append(W)
        self.Models.append(m)

        X_loc = []
        X_loc.append(1) # counter for number of local points partitioned
        X_loc.append(1) # redundant, same as above
        X_loc.append(XI[0].reshape(1,self.xdim)) # input model center (i.e. [xc,yc])
        X_loc.append(YI[0].reshape(1,self.ndim)) #output model center (i.e. [q1, q2, q3,...])
        X_loc.append(True) # flag for whether model has been updated with latest partition
        self.LocalData.append(X_loc)
        self.M = len(self.LocalData)
        self.UpdateX = [None] * self.M # holds partitioned points for updating models
        self.UpdateY = [None] * self.M

        self.partition(XI[1:],YI[1:])
        self.train()

    def train(self,flag = True):
        if flag:
            for j,upd in enumerate(self.LocalData):
                if upd[4]:
                    if np.any(self.UpdateX[j]==None):
                        continue
                    else:
                        m = self.doOSGPR(self.UpdateX[j],self.UpdateY[j],self.Models[j], self.num_inducing, fixTheta = False,use_old_Z=True)

                         #m.likelihood.variance = self.mdrift.likelihood.variance
                         #m.kern.variance =  self.mdrift.kern.variance
                         #m.kern.lengthscale =  self.mdrift.kern.lengthscale
                        self.Models[j]  = m
                        self.Z[j] = m.Z
                        self.UpdateX[j] = None
                        self.UpdateY[j] = None


                else:
                    print("Add New Model")
                    m = self.doOSGPR(self.UpdateX[j],self.UpdateY[j],self.Models[j-1], self.num_inducing, fixTheta = False, driftZ = False,use_old_Z=True)
                    #m = self.doOSGPR(self.UpdateX[j],self.UpdateY[j],self.mdrift, self.num_inducing, fixTheta = False, driftZ = False,use_old_Z=True)

                    self.Models.append(m)
                    self.LocalData[j][4] = True
                    self.Z.append(m.Z)
                    self.UpdateX[j] = None
                    self.UpdateY[j] = None


    def robot_jitter(self,n,Y_init):
        # interpolate to the various points?
        deg = 7
        max_rough=0.0174533
        pert = deg*max_rough * np.random.uniform(-1.,1.,(n,self.ndim))
        Y_start = Y_init + pert
        X_start = np.empty((n,self.robot.dim))
        for i in range(0,n):
            X_start[i,:], _ = self.robot.fkin(Y_start[i,:].reshape(1,self.ndim))
        return X_start,Y_start

    def fake_jitter(self,n,Y_init, X_prev):
        # interpolate to the various points?
        deg = 1
        max_rough=0.0174533
        pert = deg*max_rough * np.random.uniform(-1.,1.,(n,int(self.xdim/2)))
        Y_start = Y_init + pert
        Y_start = self.encode_ang(Y_start)
        X_start, _ = self.prediction(Y_start, Y_prev = X_prev)
# =============================================================================
#         X_start = np.empty((n,self.ndim))
#         for i in range(0,n):
#             X_start[i,:], _ = self.prediction(Y_start[i,:].reshape(1,self.xdim), Y_prev = X_prev)
# =============================================================================
        return X_start,Y_start

    def train_init(self,X, Y, num_inducing):
#        print("initialize first sparse model...")
        if len(X) < num_inducing:
            num_inducing = len(X)
        Z = X[np.random.permutation(X.shape[0])[0:num_inducing], :]
        m_init = GPy.models.SparseGPRegression(X,Y,GPy.kern.RBF(self.xdim,ARD=True),Z=Z)
        m_init.optimize(messages=False)

        return m_init

    def partition(self,xnew,ynew, flag = True, useJointdist = False):
        if flag:
            M = len(self.LocalData)
            M_loc = self.LocalData
            W = self.W

            UpdateX = self.UpdateX
            UpdateY = self.UpdateY

            for n in range(0,np.shape(xnew)[0],1):
                w = np.empty([M,1]) # metric for distance between model center and query point
                #dcw = np.empty([self.M, 1]) #metric for distance between model joint center  and previous query joint

                for k in range(0,M,1):
                    c = M_loc[k][2] #1x2
                    d = self.LocalData[k][3]

                    xW = np.dot((xnew[n]-c),W) # 1x2 X 2x2
                    w[k] = np.exp(-0.5*np.dot(xW,np.transpose((xnew[n]-c))))
                    #dcw[k] = np.dot(d-ynew[n],np.transpose(d-ynew[n]))


                if useJointdist:
                #if self.encode:
                    #wv = w*np.exp(-0.5*dcw)
                    wv = w
                else:
                    wv = w
                wnear = np.max(wv)
                near = np.argmax(wv)

                if wnear > self.wgen:

                    if np.any(UpdateX[near]==None):

                        UpdateX[near] = xnew[n].reshape(1,self.xdim)
                        UpdateY[near] = ynew[n].reshape(1,self.ndim)
                    else:

                        UpdateX[near] = np.vstack((UpdateX[near],xnew[n]))
                        UpdateY[near] = np.vstack((UpdateY[near],ynew[n]))

                    nloc = M_loc[near][0]
                    M_loc[near][0]+=1
                    M_loc[near][1]+=1
                    M_loc[near][2] = (xnew[n]+ M_loc[near][2]*nloc)/(nloc+1)
                    M_loc[near][3] = (ynew[n]+ M_loc[near][3]*nloc)/(nloc+1)
                else:

                    UpdateX.append(xnew[n].reshape(1,self.xdim))
                    UpdateY.append(ynew[n].reshape(1,self.ndim))

                    M_new = []
                    M_new.append(1)
                    M_new.append(1)
                    M_new.append(xnew[n].reshape(1,self.xdim))
                    M_new.append(ynew[n].reshape(1,self.ndim))
                    M_new.append(False)
                    M_loc.append(M_new)

                    M = M+1

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

        else:
            M = cur_Z.shape[0]
            #M_old = int(0.7 * M)
            M_old = M - len(new_X)
            M_new = M - M_old
            old_Z = cur_Z[np.random.permutation(M)[0:M_old], :]
            new_Z = new_X[np.random.permutation(new_X.shape[0])[0:M_new], :]
            Z = np.vstack((old_Z, new_Z))
        return Z

    def doOSGPR(self,X,Y,m_old, num_inducing,use_old_Z=True, driftZ = False, fixTheta = False):

        Zopt = m_old.Z.param_array
        mu, Su = m_old.predict(Zopt, full_cov = True)
        Su = Su + 1e-4*np.eye(mu.shape[0])

        Kaa = m_old.kern.K(Zopt)

        Zinit = self.init_Z(Zopt, X, num_inducing, use_old_Z, driftZ)

        m_new = osgpr_GPy.OSGPR_VFE(X, Y, m_old.kern, mu, Su, Kaa,
            Zopt, Zinit)

        m_new.likelihood.variance = m_old.likelihood.variance
        m_new.kern.variance = m_old.kern.variance
        m_new.kern.lengthscale = m_old.kern.lengthscale


        "Fix parameters"
        if driftZ:
            m_new.Z.fix()

        if fixTheta:
            m_new.kern.fix()
            m_new.likelihood.variance.fix()


        m_new.optimize()

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

    def ang_mean(self,weights,angles):
        x = y = 0
        for angle, weight in zip(angles,weights):
            x += np.cos(angle)*weight
            y += np.sin(angle)*weight

        mean = np.arctan2(y,x)
        return mean

    def prediction(self,xtest, weighted = True, bestm = 2, Y_prev = []):
        ypred = np.empty([np.shape(xtest)[0], self.ndim])
        for n in range(0, np.shape(xtest)[0], 1):
            w = np.empty([self.M, 1])
            dw = np.empty([self.M, 1])
            dc = np.empty([self.M, 1])
            dcw = np.empty([self.M, 1])

            yploc = np.empty([self.M,self.ndim])
            #xploc = np.empty([self.M,self.xdim])

            var = np.empty([self.M,1])
            for k in range(0, self.M, 1):


                try:
                    c = self.LocalData[k][2] #1x2
                    d = self.LocalData[k][3]

                    xW = np.dot((xtest[n]-c),self.W) # 1x2 X 2x2
                    #print(xW)
                    w[k] = np.exp(-0.5*np.dot(xW,np.transpose((xtest[n]-c))))
                    #print(w[k])
                    yploc[k], var[k] = self.Models[k].predict(xtest[n].reshape(1,self.xdim))
                    #print(yploc[k])
                    #xploc[k], _ = self.robot.fkin(self.decode(yploc[k].reshape(1,self.ndim)))
                    
#                    dw[k] = np.dot(yploc[k]-Y_prev[-1].reshape(1,self.ndim),np.transpose(yploc[k]-Y_prev[-1].reshape(1,self.ndim)))
#                    dw[k] = np.linalg.norm(circstats.difference(yploc[k],Y_prev))
#                    dc[k] = np.dot(yploc[k]-d,np.transpose(yploc[k]-d))
                    dcw[k] = np.dot(d-Y_prev[-1].reshape(1,self.ndim),np.transpose(d-Y_prev[-1].reshape(1,self.ndim)))
                except:

                    w[k] = 0
                    dw[k] = float("inf")
                    dc[k] = float("inf")
                    dcw[k] = float("inf")
#                    var[k] = float("inf")
                    pass

            if weighted:
                if bestm > self.M:
                    h = self.M
                else:
                    h = bestm
            else:
                h = 1

            self.w = w
            s = 50
            #wv = w*np.exp(-s*dcw)/var
            #wv = w
            wv = w*np.exp(-s*dcw*var)
            #wv = w*np.exp(-var)
            #wv = w/var
            wv =np.nan_to_num(wv)
            wv = wv.reshape(self.M,)
            varmin = np.min(var) # minimum variance of local predictions
#            wv = wv/np.sum(wv)
            thresh = 0 # 0 uses all models

            self.wv = wv
            self.var = var
            "Select for best models"
            if np.max(wv) < thresh:
                ind = wv ==np.max(wv)
            else:
                ind = wv > thresh
            #print(ind)
            if self.encode:
                "Normal Weighted mean"
                ypred[n] = np.dot(np.transpose(wv[ind]), yploc[ind]) / np.sum(wv[ind])
            else:
                "Weighted circular mean of predictions"
                ypred[n] = circstats.mean(yploc,axis = 0,w = wv.reshape(len(wv),1))

            "Debug Prints"
            #print("wv:" + str(wv))
            #print("w:" + str(w))
#            print("dw:" + str(dw))
#            print("dc:" + str(dc))
            #print("var:" + str(var))
            #print("dcw:" + str(dcw))
            #print("d:" + str(d))
            #print("Yprev:" + str(Y_prev[-1].reshape(1,self.ndim)))
#            print("yploc:" + str(yploc))
            #print("xploc:" + str(xploc))

            #print("ypred:" + str(ypred))


        return ypred, varmin