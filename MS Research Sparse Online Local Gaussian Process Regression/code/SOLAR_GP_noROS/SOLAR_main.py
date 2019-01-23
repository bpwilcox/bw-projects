#from IPython import get_ipython
#get_ipython().magic('reset -sf')

import GPy
#import scipy.io
import matplotlib.pyplot as pl
from mpl_toolkits.mplot3d.axes3d import Axes3D
GPy.plotting.change_plotting_library('matplotlib')
import numpy as np
import time
import Trajectory
from TestData import TestTrajectory
import RobotModels
from SOLAR_core import LocalModels

#from sklearn.metrics import mean_squared_error

#%matplotlib inline
#%matplotlib qt5
#np.random.seed(0)

pl.close("all")

"Robot structure"
robot = RobotModels.nLink2D(Links = [0.5,0.5,0.5])

"Planar Robot"
Origin = RobotModels.Link(0,0,0)
Link = RobotModels.Link(0,0.5,0)
LinkEnd = RobotModels.Link(0,0.5,0)

robot2D = RobotModels.SerialLink([Origin, Link, Link, LinkEnd], True)


"Test Settings"
n = 200 # number of points in trajetory
r =0.3 # radius of trajectory

YStart = np.column_stack(np.deg2rad([-30,45,30])) # initial joint position

#XStart  = robot.fkin(YStart) # initial taskspace position
XStart,_  = robot2D.fkin(YStart) # initial taskspace position

x0 = XStart[0][0]-r # trajectory x center 
y0 = XStart[0][1] # y trajectory y center

"Choose Which Test Trajectory"
Test = TestTrajectory(Trajectory.Circle2D(n,r,x0,y0,arclength = 2*np.pi), robot2D)
#Test = TestTrajectory(Trajectory.nPoly2D(n,4,r,x0,y0, arclength = -2*np.pi,flip =0), robot)
#Test = TestTrajectory(Trajectory.Rect2D(n, width = 1, height = 1), robot)
#Test = TestTrajectory(Trajectory.Star2D(n,5,r,x0,y0), robot)
#Test = TestTrajectory(Trajectory.Spiral2D(n,1,0.5,x0,y0,6*np.pi), robot)

workspace = Trajectory.Circle2D(n,np.sum(robot2D.dh_table[:,1]),0,0) # size of reachable workspace

X_test = Test.xtest

#Y_test = Test.ytest # if inverse kinematics is provided

njit = 25 #number of jittered data points
num_inducing = 10 # max number of induced/support points per model

" Initialize Local Models"
local = LocalModels(num_inducing, wgen =0.9, robot = Test.robot)
local.initialize(njit,YStart, Test.robot)

Xtot = local.XI # stack of experiences
Ytot = local.YI

"Timing"

tc = np.zeros([len(X_test)-1,1])

"Axis settings (for circle trajectory)" 
k = 1
xmin = workspace.center_x - k*workspace.radius
xmax = workspace.center_x + k*workspace.radius
ymin = workspace.center_y - k*workspace.radius
ymax = workspace.center_y + k*workspace.radius


drift = 1  # number of iterations until train next "drift" model
Yexp = YStart
Support_Points = []
i = 0 
Error = np.empty([])
train_flag = True
partition_flag = True
keep = n
loopTrajectory = False
"Main Loop"

while i < len(X_test):

    "Plotting"
    print("test input: " + str(i))        
    if i==-1: #stop early condition
        break
    elif i%10==0: # create plot after n iterations
        fig = pl.figure(1)
        ax = pl.axes(projection='3d')
        #pl.autoscale(False)
        #pl.axis([xmin, xmax, ymin, ymax])
        #pl.plot(workspace.xtest[:,0],workspace.xtest[:,1],'r')
        #ax.set_xlim(xmin, xmax)
        #ax.set_ylim(ymin, ymax)
        #ax.set_zlim(-0.5, 0.5)
        
        
        
        Test.robot.plot3D(Yexp.reshape(1,local.ndim),ax) 
        "Plot test trajectory and actual trajectory"
        #pl.plot(X_test[:,0],X_test[:,1],'-.')
#        pl.plot(Xtot[njit:,0],Xtot[njit:,1])
        #pl.plot(Xtot[:,0],Xtot[:,1])
        ax.plot3D(X_test[:,0],X_test[:,1],X_test[:,2],'-')
        ax.plot3D(Xtot[:,0],Xtot[:,1],Xtot[:,2])
  

        #pl.axis('scaled')
        #pl.axis([xmin, xmax, ymin, ymax])

# =============================================================================
#         "Plot robot arm"
#         arm = Test.robot.plotrobot(Yexp.reshape(1,local.ndim))   
#         #pl.plot(arm[:,0],arm[:,1],'b-',linewidth=5)
#         #pl.plot(arm[:,0],arm[:,1],'ko',linewidth=5)
#         ax.plot3D(arm[:,0],arm[:,1],arm[:,2],color = 'blue',linewidth=5)
#         ax.plot3D(arm[:,0],arm[:,1],arm[:,2],'ko',linewidth=5)
#         #ax.scatter3D(arm[:,0],arm[:,1],arm[:,2], color = 'black',linewidth=5)
#         ax.view_init(30, -45)
# =============================================================================
        
# =============================================================================
#         "Plot support points"
#         pl.plot(local.mdrift.Z[:,0], local.mdrift.Z[:,1],'.') # drift Model support points
#         for j in range(0,len(local.Models),1):
#                 pl.plot(local.Models[j].Z[:,0],local.Models[j].Z[:,1],'.') # local Model support points
#                 pl.plot(local.LocalData[j][2][0,0],local.LocalData[j][2][0,1],'k+') # local model center
# 
# =============================================================================
        #pl.tight_layout()

        pl.show(block=True)
        "Save Plots"       
#        fname = 'Figures2/' + str(i) 
#        pl.savefig(fname)

        pl.cla()
    t1 = time.time()

    " Predict "
#    Support_Points.append(np.asarray(local.Z))
    Ypred,var = local.prediction(X_test[i].reshape(1,local.xdim),Y_prev = Ytot[-2:])
    Ypost = np.vstack((Ytot[-2:],Ypred))
    Ypost = np.unwrap(Ypost,axis=0) # unwrap angles to be unbounded
        
    Yexp = Ypost[-1].reshape(1,local.ndim)
    Xexp, _ = Test.robot.fkin(Yexp)   
    
    Xtot = np.vstack((Xtot,Xexp))
    Ytot = np.vstack((Ytot,Yexp))   
    if Xtot.shape[0] > keep-1:
        Xtot = Xtot[-(keep-1):,:]
        Ytot = Ytot[-(keep-1):,:]
     
    " Train 'drift' GP"
    if i % drift == 0:
        mdrift = local.doOSGPR(Xtot[-drift:], Ytot[-drift:], local.mdrift,num_inducing ,use_old_Z=False)
        
        mkl = []
        for j in range(0, local.xdim):
            mkl.append(1/(mdrift.kern.lengthscale[j]**2))
        W = np.diag(mkl)
        
        #W = np.diag([1/(mdrift.kern.lengthscale[0]**2), 1/(mdrift.kern.lengthscale[1]**2)])
        local.W = W
        local.mdrift = mdrift    
      
    "Partition experience "    
    local.partition(Xexp.reshape(len(Xexp),local.xdim),Yexp.reshape(len(Yexp),local.ndim), flag = partition_flag)
#    local.train()
    " Train Local Models "
    try:
        local.train(flag = train_flag)
    except:
        pass
    

           
    t2 = time.time()              
    tc[i-1]= t2-t1      
    error = np.linalg.norm(X_test[i]-Xexp) 
    Error = np.hstack((Error,error))  
    i +=1
    
    "Loop trajectory"
    if loopTrajectory:
        if i >= len(X_test):
#            train_flag = False # Turn off local model training
#            partition_flag = False   # Turn off partitioning  
            i = 0
            Test = TestTrajectory(Trajectory.Circle2D(n,0.25,x0,y0,arclength = 2*np.pi), robot2D)
            X_test = Test.xtest


# Plot Final
pl.figure(1)
pl.plot(workspace.xtest[:,0],workspace.xtest[:,1],'r')
pl.plot(X_test[:,0],X_test[:,1],'-.')
pl.plot(Xtot[njit:,0],Xtot[njit:,1])
arm = Test.robot.plotrobot(Yexp.reshape(1,local.ndim))
pl.plot(arm[:,0],arm[:,1],'b-',linewidth=5)
pl.plot(local.XI[:,0],local.XI[:,1],'.')
#pl.plot(local.mdrift.Z[:,0], local.mdrift.Z[:,1],'.')

pl.axis('scaled')
pl.axis([xmin, xmax, ymin, ymax])
fname = 'Figures2/' + str(i)   


# Plot final support points
for i in range(0,len(local.Models),1):
    pl.figure(1)
    pl.plot(local.LocalData[i][2][0,0],local.LocalData[i][2][0,1],'k+') # model centers
    pl.plot(local.Models[i].Z[:,0],local.Models[i].Z[:,1],'.')

pl.show(block=True)
#pl.savefig(fname)



"Data to Save for MATLAB animation"
# Create a dictionary
#SP = np.empty((len(Support_Points),), dtype=np.object)
#for i in range(len(Support_Points)):
#    SP[i] = Support_Points[i]
#path = os.getcwd()
#adict = {}
#adict['X_test'] = X_test
#adict['Xtot'] = Xtot
#adict['Ytot'] = Ytot
#adict['Support_Points'] = SP
#adict['robot_links'] = Test.robot.Links
#scipy.io.savemat(path +'/Matlab/MATLAB_robot_sim/test_data', adict)



