#!/usr/bin/env python

import rospy
import numpy as np
from geometry_msgs.msg import Point
#import GPy
import numpy as np
import time
import Trajectory
from TestData import TestTrajectory
import RobotModels
from Local import LocalModels
from sensor_msgs.msg import JointState
import tf
from std_msgs.msg import Int32
from std_msgs.msg import Float32



def teleop_client(i):
#    print("Waiting...")
#    print(i)
    rospy.wait_for_service('teleop_next')
#    print("Done waiting")
#    try:
    nextPoint = rospy.ServiceProxy('teleop_next',EndEffector)
    data = nextPoint(i)
    return data
        
#    except:
#        print("Service failed")
    
#    





def sender():

    "ROS Settings"
    jspub = rospy.Publisher('joint_states', JointState, queue_size=10)

    rospy.init_node('controller_node')
    count  = rospy.Publisher('count', Int32, queue_size=10)
    numModels= rospy.Publisher('numModels', Int32, queue_size=10)
    looptime = rospy.Publisher('looptime', Float32, queue_size=10)
#    listener = tf.TransformListener()
    R = rospy.get_param('~controller_pub_rate')
    rate = rospy.Rate(R)

#    T = rospy.get_param('~period')
#     r = 0.2
#    [X_test,N] = getCircle()
    # [X_test,N] = getRectangle()
    # [X_test, N] = getSpiral()

    cmd = JointState()
#    cmd.name = ['baseHinge', 'interArm']    
#    cmd.name = ['joint1', 'joint2','joint3','joint4']    
    cmd.name = ['joint1', 'joint2','joint3','joint4','joint5','joint6']    


    "Robot Settings"
    twolink = RobotModels.nLink2D(Links = [1,1,1,1,1,1])
    #twolink = RobotModels.nLink2D(Links = [0.5,0.5,0.5,0.5,0.5,0.5])
    
    "Test Settings"
    YStart = np.array(np.deg2rad([-90,90,30,0,30,60])).reshape(1,6)
#    YStart = np.array(np.deg2rad([0,90])).reshape(1,2)
#    YStart = np.array(np.deg2rad([0,90,0,90])).reshape(1,twolink.num_links)

    #YStart = np.array(np.deg2rad([90,90,30])).reshape(1,3)   
    XStart  = twolink.fkin(YStart)


    n = 800
    r = 2
#    x0 = 0.25
#    y0 = 1
    x0 = XStart[0][0]-r
    y0 = XStart[0][1]
    
#    Test = TestTrajectory(Trajectory.Circle2D(n,r,x0,y0,arclength = 2*np.pi), twolink)
#    Test = TestTrajectory(Trajectory.nPoly2D(n,4,r,x0,y0), twolink)
    #Test = TestTrajectory(Trajectory.Rect2D(n, width = 1, height = 1), twolink)
    Test = TestTrajectory(Trajectory.Star2D(n,5,r,x0,y0), twolink)
#    Test = TestTrajectory(Trajectory.Spiral2D(n,0.6,0.1,x0,y0,6*np.pi), twolink)
          
    X_test = Test.xtest
    #Y_test = YStart
    Y_test = Test.ytest
    
    "Algorithm Settings"    
    njit = 25
    num_inducing = 25
    drift =8
    " Initialize Local Models"
    local = LocalModels(num_inducing, wgen =0.95, ndim = Test.robot.num_links, robot = Test.robot)
#    local.initialize(njit,Y_test[0], Test.robot)
    local.initialize(njit,YStart, Test.robot)
    
    Xtot = local.XI
    Ytot = local.YI

    Yexp = Y_test[0]  
    #Yexp = Ytot[-1]
    i = 1
    "Main Loop"



    while not rospy.is_shutdown():

        t1 = time.time()

        cmd.header.stamp = rospy.Time.now()
#        t = rospy.get_time()
        count.publish(i)
        numModels.publish(local.M)


        if i > len(X_test)-1:
            i = 0
#        cmd.name = ['baseHinge', 'interArm']    
    
#	data = teleop_client(i)   
 
        "SOLGPR"   
    
        Ypred = local.prediction(X_test[i].reshape(1,2),Y_prev = Ytot[-1:])
    
        Ypost = np.vstack((Ytot[-1:],Ypred))   
        Ypost = np.unwrap(Ypost,axis=0)
        Yexp = Ypost[-1].reshape(1,Test.robot.num_links)
        
#        cmd.position = [Ypost[0][0], Ypost[0][1]]
#        cmd.position = Yexp.tolist()
#        cmd.position= [Yexp]
        cmd.position = [Ypost[0][0], Ypost[0][1],Ypost[0][2], Ypost[0][3],Ypost[0][4], Ypost[0][5]]

        jspub.publish(cmd)        
        
        Xexp = Test.robot.fkin(Yexp)    
        Xtot = np.vstack((Xtot,Xexp))
        Ytot = np.vstack((Ytot,Yexp))   
    #    
        if i % drift == 0:
            mdrift = local.doOSGPR(Xtot[i + njit - drift:i + njit], Ytot[i + njit - drift:i + njit], local.mdrift,num_inducing ,use_old_Z=False, driftZ = False)
#            mdrift = local.doOSGPR(Xexp, Yexp, local.mdrift,num_inducing,use_old_Z=False, driftZ = False)
            W = np.diag([1/(mdrift.kern.lengthscale[0]**2), 1/(mdrift.kern.lengthscale[1]**2)])  
            local.W = W
            local.mdrift = mdrift    
       
        local.partition(Xexp.reshape(len(Xexp),2),Yexp.reshape(len(Yexp),Test.robot.num_links))
        try:
            local.train()
        except:
            pass
        t3 = time.time() 
        looptime.publish(t3-t1)
        
        i+=1
        rate.sleep()
         

if __name__ == '__main__':
    try:
        sender()
    except rospy.ROSInterruptException:
        pass
