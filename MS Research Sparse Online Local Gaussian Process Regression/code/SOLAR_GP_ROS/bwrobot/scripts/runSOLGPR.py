#from IPython import get_ipython
#get_ipython().magic('reset -sf')

import GPy
import scipy.io
import matplotlib.pyplot as pl
from matplotlib import animation
GPy.plotting.change_plotting_library('matplotlib')
import numpy as np
import time
#import gpflow as GPflow
#import osgpr
import osgpr_GPy
#import createOSGPRmodel
#import sgpr
#import pdb
#import tensorflow as tf
import matplotlib.ticker as ticker
#import pickle
import Trajectory
from TestData import TestTrajectory
import RobotModels
from Local import LocalModels
#from sklearn.metrics import mean_squared_error
from mpl_toolkits.mplot3d import Axes3D


#%matplotlib inline
#%matplotlib qt5
pl.close("all")

global l1
global l2

l1 = 1
l2 = 1

#np.random.seed(0)

#print(np.random.uniform(-1.,1,5))

def loadmodelsamp(X,Y,Ksamp):

    m_load = GPy.models.GPRegression(X,Y, Ksamp)
    m_load.optimize(messages=False)
    W = np.diag([m_load.kern.lengthscale[0],m_load.kern.lengthscale[1]])
    return W, m_load

def jitter(n,Y_init, robot):
 
    max_rough=0.05
    pert=max_rough * np.random.uniform(-1.,1.,(n,robot.num_links))
    Y_start = Y_init + pert
    X_start = robot.fkin(Y_start)
    return X_start, Y_start

"Generate Test Data"

"Circular test"
n = 750
r = 1
#twolink = RobotModels.nLink2D(Links = [1,1,1])
twolink = RobotModels.nLink2D(Links = [0.5,0.5,0.5,0.5,0.5,0.5])

#twolink = RobotModels.TwoLink2D(l1,l2)


#YStart = np.array(np.deg2rad([0,-90,-45])).reshape(1,3)
#YStart = np.array(np.deg2rad([180,90,30])).reshape(1,3)
YStart = np.array(np.deg2rad([-90,90,30,0,30,60])).reshape(1,6)
#YStart = np.array(np.deg2rad([0,90,30])).reshape(1,3)
#YStart = np.array(np.deg2rad([90,90,30])).reshape(1,3)

XStart  = twolink.fkin(YStart)
x0 = XStart[0][0]-r
y0 = XStart[0][1]

#x0 = -.25
#y0 = -1

#twolink = RobotModels.TwoLink2D(l1,l2)


#Test = TestTrajectory(Trajectory.Circle2D(n,r,x0,y0,arclength = 2*np.pi), twolink)
#Test = TestTrajectory(Trajectory.nPoly2D(n,4,r,x0,y0), twolink)
#Test = TestTrajectory(Trajectory.Rect2D(n, width = 1, height = 1), twolink)
Test = TestTrajectory(Trajectory.Star2D(n,5,r,x0,y0), twolink)
#Test = TestTrajectory(Trajectory.Spiral2D(n,0.6,0.1,x0,y0,6*np.pi), twolink)

workspace = Trajectory.Circle2D(n,np.sum(Test.robot.Links),0,0)

X_test = Test.xtest
#Y_test = YStart
Y_test = Test.ytest



njit = 25
#[XI,YI] =  jitter(njit,Y_test[0],Test.robot)
#


num_inducing = 25
" Initialize Local Models"
local = LocalModels(num_inducing, wgen =0.975, ndim = Test.robot.num_links, robot = Test.robot)
#local.initialize(njit,Y_test[0], Test.robot)
local.initialize(njit,YStart, Test.robot)

#local.init_norm(njit,Y_test[0],Test.robot)
#local_osgpr = LocalModels()
#local_osgpr.Models[0] = local_osgpr.train_init(XI,YI, 15)

#m = train_init(XI,YI,num_inducing)
Xtot = local.XI
Ytot = local.YI

"Timing"

tc = np.zeros([len(X_test)-1,1])
#tpred = np.zeros([len(X_test)-1,1])
ttrain = np.zeros([len(X_test)-1,1])

k = 1
"Axis settings (for circle trajectory)" 
#xmin = Test.trajectory.center_x - k*Test.trajectory.radius
#xmax = Test.trajectory.center_x + k*Test.trajectory.radius
#ymin = Test.trajectory.center_y - k*Test.trajectory.radius
#ymax = Test.trajectory.center_y + k*Test.trajectory.radius

xmin = workspace.center_x - k*workspace.radius
xmax = workspace.center_x + k*workspace.radius
ymin = workspace.center_y - k*workspace.radius
ymax = workspace.center_y + k*workspace.radius


#xmin, xmax, ymin, ymax = -1.6, 0.5, -0.1, 1.1

drift =8
Yexp = YStart
thresh1 = 0.0005
thresh2 = 0.001
#Yexp = Ytot[-1]
"Main Loop"
for i in range(0,np.shape(X_test)[0],1):
    print("test input: " + str(i))        
    if i==-275:
        break
#    elif i%10==0:
#        fig = pl.figure(1)  
##        ax = fig.add_subplot(111, projection='3d')  
##        ax.view_init(elev = 30,azim = 10)
#        pl.autoscale(False)
##        pl.axis('equal')
#        pl.axis([xmin, xmax, ymin, ymax])
#        pl.plot(workspace.xtest[:,0],workspace.xtest[:,1],'r')
#        pl.plot(X_test[:,0],X_test[:,1],'-.')
#        pl.plot(Xtot[njit:,0],Xtot[njit:,1])
#        arm = Test.robot.plotrobot(Yexp.reshape(1,Test.robot.num_links))
##        pl.plot(arm[:,0],arm[:,1],'k-o')
##        Z_new = m.Z
##        pl.plot(local.Models[0].Z[:,0], local.Models[0].Z[:,1],'.')
##        pl.plot(local.mdrift.Z[:,0], local.mdrift.Z[:,1],'.')
#       
##        pl.ylim(ymin, ymax) 
##        pl.xlim(xmin, xmax) 
#        pl.axis('scaled')
#        pl.axis([xmin, xmax, ymin, ymax])
##        print('----------------------------')
##        print(local.Models[0].Z)
#        for j in range(0,local.M,1):
#                pl.plot(local.Models[j].Z[:,0],local.Models[j].Z[:,1],'.')
##                pl.plot(local.LocalData[i][0][:,0],local.LocalData[i][0][:,1],'.')
##                pl.plot(local.LocalData[i][2][0],local.LocalData[i][2][1],'k+')
#        pl.plot(arm[:,0],arm[:,1],'b-',linewidth=5)
#        pl.plot(arm[:,0],arm[:,1],'ko',linewidth=5)
#        
#        
#        pl.tight_layout()
#
#        pl.show(block=True)
#        fname = 'Figures2/' + str(i) 
##        pl.savefig(fname)
#        pl.cla()
    t1 = time.time()
    
#    if i % drift == 0:
#        mdrift = local.doOSGPR(Xtot[i + njit - drift:i + njit], Ytot[i + njit - drift:i + njit], local.mdrift, 15,use_old_Z=False, driftZ = False )
##        mdrift = GPy.models.GPRegression(Xtot[i + njit - drift:i + njit], Ytot[i + njit - drift:i + njit],GPy.kern.RBF(2,ARD=True))
#        W = np.diag([mdrift.kern.lengthscale[0],mdrift.kern.lengthscale[1]])
#        local.W = W
#        local.mdrift = mdrift
    
#    "Normal GP"
#    Ypred = local.prediction(X_test[i].reshape(1,2),bestm = 2)
#    Yexp = Ypred
#    Xexp = Test.robot.fkin(Yexp)    
#    local.partition(Xexp.reshape(1,2),Yexp.reshape(1,2))
#    local.train_norm()
    
    
    "OSGPR - only"
#    Ypred,var = local.Models[0].predict(X_test[i].reshape(1,2))
##    print(var)
##    if var > thresh2:
##        print("add induce")
##        local.num_inducing = local.num_inducing+1
##        print(var)
##    if var > thresh2:
##        print("jitter")
##        print(var)
##        [Xjit,Yjit] = local.jitter(5,Yexp,Test.robot)
##        local.num_inducing = local.num_inducing+1
##        local.Models[0] = local.doOSGPR(Xjit,Yjit, local.Models[0], num_inducing,False)
##        Ypred,_ = local.Models[0].predict(X_test[i].reshape(1,2))
#    Yexp = Ypred
#    Xexp = Test.robot.fkin(Yexp)
#    local.Models[0] = local.doOSGPR(Xexp.reshape(1,2),Yexp.reshape(1,Test.robot.num_links), local.Models[0], num_inducing)
#    
    "SOLGPR"   
##
    Ypred = local.prediction(X_test[i].reshape(1,2),Y_prev = Ytot[-2:])
#    Ypred,_ = local.mdrift.predict(X_test[i].reshape(1,2))
#    Ypred = np.unwrap(Ypred)
#    Ypred = Ypred+2*np.pi
#    print(Ypred)
    Ypost = np.vstack((Ytot[-2:],Ypred))
#    print(Ypost)    
    Ypost = np.unwrap(Ypost,axis=0)
    Yexp = Ypost[-1].reshape(1,Test.robot.num_links)
#    Yexp  = Ypred
    print(Yexp)
    Xexp = Test.robot.fkin(Yexp)    
    Xtot = np.vstack((Xtot,Xexp))
    Ytot = np.vstack((Ytot,Yexp))   
#    
    if i % drift == 0:
        mdrift = local.doOSGPR(Xtot[i + njit - drift:i + njit], Ytot[i + njit - drift:i + njit], local.mdrift,25 ,use_old_Z=False, driftZ = False)
#        mdrift = local.doOSGPR(Xexp, Yexp, local.mdrift,25,use_old_Z=False, driftZ = False)


#        mdrift = GPy.models.GPRegression(Xtot[i + njit - drift:i + njit], Ytot[i + njit - drift:i + njit],GPy.kern.RBF(2,ARD=True))
#        W = np.diag([mdrift.kern.lengthscale[0],mdrift.kern.lengthscale[1]])
        W = np.diag([1/(mdrift.kern.lengthscale[0]**2), 1/(mdrift.kern.lengthscale[1]**2)])
        
        local.W = W
        local.mdrift = mdrift    
#    
#    
    local.partition(Xexp.reshape(len(Xexp),2),Yexp.reshape(len(Yexp),Test.robot.num_links))
    try:
        local.train()
    except:
        pass
    
    
##    

           
    t3 = time.time()              
    tc[i-1]= t3-t1   
         

        
        
#L = local.LocalData
#Models = local.Models



#
#    
pl.figure(1)
pl.plot(workspace.xtest[:,0],workspace.xtest[:,1],'r')
pl.plot(X_test[:,0],X_test[:,1],'-.')
pl.plot(Xtot[njit:,0],Xtot[njit:,1])
#pl.plot(local.XI[:,0],local.XI[:,1],'.')
arm = Test.robot.plotrobot(Yexp.reshape(1,Test.robot.num_links))
#pl.plot(arm[:,0],arm[:,1],'k-o')
#pl.plot(local.Models[0].Z[:,0],local.Models[0].Z[:,1],'.')


#pl.plot(m.Z[:,0],m.Z[:,1],'o')
pl.axis('scaled')
pl.axis([xmin, xmax, ymin, ymax])

fname = 'Figures2/' + str(i)   

#
#
#
for i in range(0,local.M,1):
    pl.figure(1)
#    #    pl.cla()
    pl.plot(local.LocalData[i][0][:,0],local.LocalData[i][0][:,1],'.')
#    pl.plot(local.LocalData[i][2][0],local.LocalData[i][2][1],'k+')
#    pl.plot(local.Z[i][:,0],local.Z[i][:,1],'o')
#    pl.plot(local.Models[i].Z[:,0],local.Models[i].Z[:,1],'.')

#pl.plot(arm[:,0],arm[:,1],'k-o')
pl.plot(arm[:,0],arm[:,1],'b-',linewidth=5)
pl.plot(arm[:,0],arm[:,1],'ko',linewidth=5)
pl.show(block=True)
#pl.savefig(fname)

#
pl.figure(2)
pl.plot(tc)
pl.ylabel('Training and Prediction time (s)')
pl.xlabel('Iteration')
pl.show(block=True)

##pl.figure()
##pl.plot(tpred)
##pl.ylabel('Prediction time (s)')
##pl.xlabel('Iteration')
##pl.show(block=True)
##
##pl.figure()
##pl.plot(ttrain)
##pl.ylabel('Training time (s)')
##pl.xlabel('Iteration')
##pl.show(block=True)
##
#mse = np.dot((X_test-Xtot[njit:]).T,(X_test-Xtot[njit:]))
#mse = np.mean(mse, 0)
#mse = mean_squared_error(X_test, Xtot[njit:])
#print("Mean Squared Error: " + str(mse))
#print("Number of Models: " + str(len(local.Models)))




#with open('model.pkl', 'rb') as f:  
#    m, Xtot,Ytot = pickle.load(f)