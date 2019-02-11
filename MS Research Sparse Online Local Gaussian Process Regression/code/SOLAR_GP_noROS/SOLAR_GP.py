import GPy
import matplotlib.pyplot as pl
from mpl_toolkits.mplot3d.axes3d import Axes3D
GPy.plotting.change_plotting_library('matplotlib')
import numpy as np
import time
from SOLAR_core import LocalModels

#from sklearn.metrics import mean_squared_error

#%matplotlib inline
#%matplotlib qt5
#np.random.seed(0)

class SOLAR_GP():
    
    def __init__(self, robot, test, model = []):
        
        self.robot = robot
        self.test = test
        self.model = model
        self.modelF = []
        self.xpath = []
        self.ypath = []
        self.varnp = np.empty([0,1])
        self.wv = np.empty([0,1])
        self.w = np.empty([0,1])
        self.jitter  = []
    def make_plot(self, Q, elevation, azimuth, test_trajectory= True, real_trajectory = True, save = False, name = 'test'):
        "Plot robot"
        if self.encode_angles:
            Q = self.decode_ang(Q)
        ax = self.robot.plot3D(Q, elevation, azimuth) 
        njit = len(self.model.XI)
        "Plot test trajectory and actual trajectory"
        if test_trajectory:
            ax.plot3D(self.test.xtest[:,0], self.test.xtest[:,1], self.test.xtest[:,2],'-')
        if real_trajectory:
            ax.plot3D(self.xpath[njit:,0], self.xpath[njit:,1], self.xpath[njit:,2])

# =============================================================================
#         "Plot support points"
#         for j in range(0,self.model.M,1):
#             ax.plot3D(self.model.Models[j].Z[:,0], self.model.Models[j].Z[:,1], self.model.Models[j].Z[:,2],'.') # local Model support points
#             #ax.plot3D(self.model.LocalData[j][2][0,0],self.model.LocalData[j][2][0,1], self.model.LocalData[j][2][0,2],'k+') # local model center
# =============================================================================
        
        "Save Plots"
        if save:     
            fname = 'Figures/' + str(name) 
            pl.savefig(fname)
            
        pl.show(block=True)
        
    def make_test_plot(self, test_data, save = False, name = 'test'):
        for column in test_data.T:
            pl.plot(column)
            pl.xlim(0, np.size(self.test.xtest,0))
            
        "Save Plots"
        if save:     
            fname = 'Plots/' + str(name) 
            pl.savefig(fname)            
        pl.show(block=True)     
        
        #pl.cla()        
    def add_noise(self, Q, deg):
        max_rough=0.0174533
        pert = deg*max_rough * np.random.uniform(-1.,1.,(1,3))
        Y = Q + pert
        return Y
        
    def decode_ang(self, q):
        d = int(np.size(q,1)/2)
        decoding = np.arctan2(q[:,:d], q[:,d:]).reshape(np.size(q,0),d)
        return decoding
    
    def add_vars(self):
        a = np.size(self.model.var)
        b = np.size(self.varnp, 1)
        c = np.size(self.varnp, 0)
        if a > b:
            self.varnp = np.hstack([self.varnp, np.nan*np.zeros(c).reshape(c,1)])
        self.varnp = np.vstack([self.varnp,self.model.var.reshape(1,a)])
        
    def add_wv(self):
        a = np.size(self.model.wv)
        b = np.size(self.wv, 1)
        c = np.size(self.wv, 0)
        if a > b:
            self.wv = np.hstack([self.wv, np.nan*np.zeros(c).reshape(c,1)])
        self.wv = np.vstack([self.wv,self.model.wv.reshape(1,a)]) 

    def add_w(self):
        a = np.size(self.model.w)
        b = np.size(self.w, 1)
        c = np.size(self.w, 0)
        if a > b:
            self.w = np.hstack([self.w, np.nan*np.zeros(c).reshape(c,1)])
        self.w = np.vstack([self.w,self.model.w.reshape(1,a)])
        
    def runTest(self, init = True, njit = 25, num_inducing = 10, wgen = 0.9, drift = 1, encode_angles = False, train_flag = True, partition_flag = True, loop_trajectory = False, show_plots = True, save_plots = False, elev = 30, azim = 30):
        
        X_test = self.test.xtest
        
        self.encode_angles = encode_angles
        
        "Initialize Local Models"
        if init:
            self.model = LocalModels(num_inducing, wgen, robot = self.robot)
            self.model.initialize(njit, self.robot.currentY, self.encode_angles)
            #self.model.initialize(njit, np.column_stack(np.deg2rad([81,84,66])), self.encode_angles)

        self.xpath = self.model.XI # stack of experiences
        self.ypath = self.model.YI
        
# =============================================================================
#         self.modelF = LocalModels(num_inducing, 0.975, xdim = np.size(self.model.YI, 1), ndim = np.size(self.model.XI, 1))
#         XI = self.model.YI
#         YI = self.model.XI
#         self.modelF.initializeF(XI, YI)
# =============================================================================
        
        "Timing"
        tc = np.zeros([len(X_test)-1,1])

        if self.encode_angles:
            Yexp = self.model.encode_ang(self.robot.currentY)
        else:
            Yexp = self.robot.currentY
        Yprev = Yexp
        i = 0
        #i = 499
        Error = np.empty([])
        keep = len(X_test) + njit
        
        #self.jitter = self.modelF.fake_jitter(10, self.robot.currentY, Xprev)
# =============================================================================
#         FakeX, FakeY = self.modelF.fake_jitter(10, self.robot.currentY, Xprev)        
#         self.model.partition(FakeX, FakeY)
#         self.model.train()
# =============================================================================
        
        "Main Loop"
        while i < len(X_test):  
            "Plotting"
            print("test input: " + str(i))     
            #print(self.model.M)
            if i==-1: #stop early condition
                break
            elif i%10==0: # create plot after n iterations
                self.make_plot(Yexp.reshape(1,self.model.ndim), elev, azim, name = str(i), save = save_plots)
                #self.make_test_plot(self.varnp, save = save_plots, name = str(i))
                #self.make_test_plot(self.wv)
                #self.make_test_plot(self.w)
                
            t1 = time.time()
    
            " Predict "
            if self.encode_angles:
                Ypred,var = self.model.prediction(X_test[i].reshape(1,self.model.xdim),Y_prev = Yprev)
                #Yexp = self.model.encode_ang(self.add_noise(self.decode_ang(Ypred),0))
                Yexp = Ypred
                Xexp, _ = self.robot.fkin(self.decode_ang(Yexp))
                Yprev = Yexp
                
            else:
                Ypred,var = self.model.prediction(X_test[i].reshape(1,self.model.xdim),Y_prev = Yprev)
                Ypost = np.vstack((self.ypath[-2:],Ypred))
                Ypost = np.unwrap(Ypost,axis=0) # unwrap angles to be unbounded         
                Yexp = self.add_noise(Ypost[-1].reshape(1,self.model.ndim),0)
                Xexp, _ = self.robot.fkin(Yexp)
                
# =============================================================================
#             Xpred, _ = self.modelF.prediction(Yexp.reshape(1,self.modelF.xdim), Y_prev = Xprev)
#             Xprev = Xexp
#             XpredD, _ = self.modelF.mdrift.predict(Yexp.reshape(1,self.modelF.xdim))
#             YpredD, _ = self.model.mdrift.predict(X_test[i].reshape(1,self.model.xdim))
#             XexpD, _ = self.robot.fkin(self.decode_ang(YpredD))
# =============================================================================
# =============================================================================
#             Yexp = YpredD
#             self.xpath = np.vstack((self.xpath,XexpD))
#             self.ypath = np.vstack((self.ypath,YpredD))
# =============================================================================
            
            print("Test : " + str(X_test[i]))            
# =============================================================================
#             print("Pred : " + str(Xpred) + ", num_models: " + str(self.modelF.M))
#             print("PredD: " + str(XpredD))
#             print("ExpD: " + str(XexpD))
#             print("Exp  : " + str(Xexp) + ", num_models: " + str(self.model.M))
#             print("______________________")
# =============================================================================
            self.xpath = np.vstack((self.xpath,Xexp))
            self.ypath = np.vstack((self.ypath,Yexp))
# =============================================================================
#             self.add_vars()
#             self.add_wv()
#             self.add_w()
# =============================================================================

            if self.xpath.shape[0] > keep-1:
                self.xpath = self.xpath[-(keep-1):,:]
                self.ypath = self.ypath[-(keep-1):,:]
             
# =============================================================================
#             if i % 15 ==0:
#                 FakeX, FakeY = self.modelF.fake_jitter(3, self.decode_ang(Yexp), Xexp)        
#                 self.model.partition(FakeX, FakeY)
#                 self.model.train()
# =============================================================================
                
                    
            " Train 'drift' GP"
            if i % drift == 0:
                ndrift = 10
# =============================================================================
#                 mdrift = self.model.doOSGPR(self.xpath[-drift:], self.ypath[-drift:], self.model.mdrift,num_inducing ,use_old_Z=False)
#                 mkl = []
#                 for j in range(0, self.model.xdim):
#                     mkl.append(1/(mdrift.kern.lengthscale[j]**2))
#                 W = np.diag(mkl)
# 
# =============================================================================
                mdrift = GPy.models.GPRegression(self.xpath[-ndrift:], self.ypath[-ndrift:], GPy.kern.RBF(self.model.xdim,ARD=True))
                mdrift.optimize(messages = False)
                
                mkl = []
                for j in range(0, self.model.xdim):
                    mkl.append(1/(mdrift.kern.lengthscale[j]**2))
                    #mkl.append(mdrift.kern.lengthscale[j])
                    #mkl.append(1/(mdrift.kern.lengthscale[j]))
                    
                W = np.diag(mkl)

                self.model.W = W
                self.model.mdrift = mdrift
                
# =============================================================================
#                 mdriftF = self.modelF.doOSGPR(self.ypath[-drift:], self.xpath[-drift:], self.modelF.mdrift,num_inducing ,use_old_Z=False)          
#                 mkl = []
#                 for j in range(0, self.modelF.xdim):
#                     mkl.append(1/(mdriftF.kern.lengthscale[j]**2))
#                 W = np.diag(mkl)
#                 
#                 self.modelF.W = W
#                 self.modelF.mdrift = mdriftF                
# =============================================================================
              
            "Partition experience "    
            self.model.partition(Xexp.reshape(len(Xexp),self.model.xdim),Yexp.reshape(len(Yexp),self.model.ndim), flag = partition_flag)
            #self.modelF.partition(Yexp.reshape(len(Yexp),self.modelF.xdim),Xexp.reshape(len(Xexp),self.modelF.ndim), flag = partition_flag)
        #    self.model.train()
            " Train Local Models "
            try:
                self.model.train(flag = train_flag)
               # self.modelF.train(flag = train_flag)

            except:
                pass
            
        
                   
            t2 = time.time()              
            tc[i-1]= t2-t1      
            error = np.linalg.norm(X_test[i]-Xexp) 
            Error = np.hstack((Error,error))  
            i +=1
            
            "Loop trajectory"
            if loop_trajectory:
                if i >= len(X_test):
        #            train_flag = False # Turn off local model training
        #            partition_flag = False   # Turn off partitioning  
                    i = 0

        # Plot Final
        self.make_plot(Yexp.reshape(1,self.model.ndim), elev, azim, name = str(i), save = save_plots)
        Xexp = self.xpath
        Yexp = self.ypath

# =============================================================================
# 
#         # Plot final support points
#         for i in range(0,len(self.model.Models),1):
#             pl.figure(1)
#             pl.plot(self.model.LocalData[i][2][0,0],self.model.LocalData[i][2][0,1],'k+') # model centers
#             pl.plot(self.model.Models[i].Z[:,0],self.model.Models[i].Z[:,1],'.')
#         
#         pl.show(block=True)
#         #pl.savefig(fname)
# =============================================================================
