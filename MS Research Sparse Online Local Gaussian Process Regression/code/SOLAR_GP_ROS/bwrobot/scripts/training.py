#!/usr/bin/env python

import rospy
import numpy as np
from geometry_msgs.msg import Point
#import GPy
import time
import Trajectory
from TestData import TestTrajectory
import RobotModels
#from Local import LocalModels
from LocMemEff import LocalModels

from sensor_msgs.msg import JointState

from std_msgs.msg import Int32
from std_msgs.msg import Float64
from bwrobot.srv import *
from bwrobot.msg import *



def callback(data):
    print(data)
    Xexp = np.array([data.x,data.y])    
    
def initialize(rate,jspub,cmd,GPpub):
    

    
    njit = rospy.get_param('~njit')
    YStart = rospy.get_param('~YStart2')
#    rospy.loginfo(YStart)
    YStart = np.array(YStart).reshape(1,2)
    num_inducing = rospy.get_param('~num_inducing')
    w_gen = rospy.get_param('~wgen')
    d = rospy.get_param('~drift')
    
    local = LocalModels(num_inducing, wgen = w_gen, drift = d, ndim = 2)
    YI = local.jitROS(njit,YStart)   
    print(YI)
    XI = np.empty([0,2])
    for y in YI:
        cmd.position = [y[0], y[1]]
        jspub.publish(cmd)
        data = rospy.wait_for_message('experience',Point)
        XI = np.vstack((XI,np.array([data.x,data.y]).reshape(1,2)))       
        rate.sleep()
    
    local.initROS(XI,YI) 
    
    LocMsg = constructMsg(local)
    GPpub.publish(LocMsg)
    
    return local

def constructMsg(local):
       
    LocMsg = LocalGP()
    L = []
    for count,m in enumerate(local.Models):
        GP = OSGPR_GP()
        GP.kern_var = m.kern.variance[0]
        GP.kern_lengthscale = np.array(m.kern.lengthscale) .tolist()   
        GP.likelihood_var = m.likelihood.variance[0]
        GP.xmean = local.LocalData[count][2][0].tolist()
        GP.ymean = local.LocalData[count][3][0].tolist()
        GP.numloc = local.LocalData[count][0]
        Z = np.array(m.Z)
        Z_old = np.array(m.Z_old)
        mu_old = np.array(m.mu_old)
        Su_old = np.array(m.Su_old)
        Kaa_old = np.array(m.Kaa_old)
        
        
        X_arr = []
        Y_arr = []
        Z_arr = []
        Z_old_arr = []
        mu_old_arr = []
        Su_old_arr = []
        Kaa_old_arr = []
#        

        for j in range(0,np.shape(m.X)[0]):
            X_row = Arrays()
            Y_row = Arrays()
            X_row.array = np.array(m.X[j,:]).tolist()
            Y_row.array = np.array(m.Y[j,:]).tolist()
            X_arr.append(X_row)
            Y_arr.append(Y_row)
        
        for j in range(0,np.shape(Z)[0]):
            Z_row = Arrays()
            Z_row.array = Z[j,:].tolist()
            Z_arr.append(Z_row)
#       
        for j in range(0,np.shape(Z_old)[0]):
            
            Z_old_row = Arrays()
            mu_old_row = Arrays()
            Su_old_row = Arrays()
            Kaa_old_row = Arrays()
            
            Z_old_row.array = Z_old[j,:].tolist()
#            print(Z_old_row.array)
            mu_old_row.array = mu_old[j,:].tolist()
            Su_old_row.array = Su_old[j,:].tolist()
            Kaa_old_row.array = Kaa_old[j,:].tolist()
            
            Z_old_arr.append(Z_old_row)
            mu_old_arr.append(mu_old_row)
            Su_old_arr.append(Su_old_row)
            Kaa_old_arr.append(Kaa_old_row)            
#            
        GP.X = X_arr
        GP.Y = Y_arr
        GP.Z = Z_arr
        GP.Z_old = Z_old_arr
        GP.mu_old = mu_old_arr
        GP.Su_old = Su_old_arr
        GP.Kaa_old = Kaa_old_arr
        
        L.append(GP)
        
    LocMsg.localGPs= L
#    LocMsg.W = np.array(local.mdrift.kern.lengthscale).tolist() 
    LocMsg.W = local.W.diagonal().tolist()
    LocMsg.M = local.M
    
    
    return LocMsg


def train():


    "ROS Settings"
    rospy.init_node('train_node')
    R = rospy.get_param('~train_pub_rate')
    rate = rospy.Rate(R)
    traintime = rospy.Publisher('traintime', Float64, queue_size=10)
    jspub = rospy.Publisher('joint_states', JointState, queue_size=10)
    GPpub = rospy.Publisher('localGP',LocalGP,queue_size=10)
    
    cmd = JointState()
    cmd.name = ['joint1', 'joint2'] 
        
    "Initialize Local Models"
    
#    local,Xtot,Ytot = initialize(rate,jspub,cmd, GPpub)     
    njit = rospy.get_param('~njit')
    njit = 15
    YStart = rospy.get_param('~YStart')
    YStart = np.array(np.deg2rad(YStart)).reshape(1,2)
    num_inducing = rospy.get_param('~num_inducing')
    w_gen = rospy.get_param('~wgen')
    d = rospy.get_param('~drift')
    
    local = LocalModels(num_inducing, wgen = w_gen, drift = d, ndim = 2)
    YI = local.jitROS(njit,YStart)   
    XI = np.empty([0,2])
    print(YI)
#    print(np.rad2deg(YI))
    twolink = RobotModels.nLink2D(Links = [1,1])
    Xtr = twolink.fkin(YI)
#    print(twolink.fkin(YI))
    j = 0
#    while j < len(YI):
    rospy.Rate(0.5).sleep()
    for y in YI:        
        cmd.header.stamp = rospy.Time.now()
        cmd.position = [y[0], y[1]]
#        prediction.publish([y[0],y[1]])

#        cmd.position = [YI[j][0],YI[j][1]]
        jspub.publish(cmd)
#        rate.sleep()
        rospy.Rate(5).sleep()
        print("get experience")
        data = rospy.wait_for_message('experience',Point)
#        rospy.Subscriber('experience',Point,callback)
        XI = np.vstack((XI,np.array([data.x,data.y]).reshape(1,2)))  
#        XI = np.vstack((XI,np.array([2,0]).reshape(1,2)))     

#        rospy.Rate(1).sleep()

#        XI = np.vstack((XI,np.array([Xexp[0],Xexp[1]]).reshape(1,2)))     
        print(y)        
        print(data)
        print(Xtr[j])
        
        j +=1
#        rospy.Rate(100).sleep()

    
    local.initROS(XI,YI) 
#    print(local.Models)
    LocMsg = constructMsg(local)
    GPpub.publish(LocMsg)
    
    Xtot = local.XI
    Ytot = local.YI

    i = 1
    
    "Main Loop"
    while not rospy.is_shutdown():
        print("count: " + str(i))
        "Get Yexp"
#        print("get Yexp")
#        data = rospy.wait_for_message('prediction',Arrays)        
#        Yexp = np.array(data.array).reshape(1,2)
        
        data = rospy.wait_for_message('joint_states',JointState)
        Yexp = np.array(data.position).reshape(1,2)
        print("Yexp: " + str(Yexp))
        "Get Xexp"   
        print("get Xexp")

        data = rospy.wait_for_message('experience',Point)
        Xexp = np.array([data.x,data.y]).reshape(1,2)
        print("Xexp: " + str(Xexp))
        
        t1 = time.time()
        "Training"
        if Xtot.shape[0] > 50:
            Xtot = np.delete(Xtot,0,0)
            Ytot = np.delete(Ytot,0,0)
            
        Xtot = np.vstack((Xtot,Xexp))
        Ytot = np.vstack((Ytot,Yexp))   
        
        if i % local.drift == 0:
            mdrift = local.doOSGPR(Xtot[-local.drift:], Ytot[-local.drift:], local.mdrift,local.num_inducing ,use_old_Z=False, driftZ = False)
            W = np.diag([1/(mdrift.kern.lengthscale[0]**2), 1/(mdrift.kern.lengthscale[1]**2)])  
            local.W = W
            local.mdrift = mdrift    
      
        local.partition(Xexp.reshape(len(Xexp),2),Yexp.reshape(len(Yexp),2))
        try:
            local.train()
        except:
            pass
        LocMsg = constructMsg(local)
        GPpub.publish(LocMsg)
        
        t2 = time.time() 
        
        traintime.publish(t2-t1)
        

        "Next"        
        i+=1
        rate.sleep()
         

if __name__ == '__main__':
    try:
        train()
    except rospy.ROSInterruptException:
        pass
