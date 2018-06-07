#!/usr/bin/env python

import rospy
from rospy_tutorials.msg import Floats
from rospy.numpy_msg import numpy_msg
import numpy as np
import Trajectory
from geometry_msgs.msg import Point
#from rospy_tutorials.srv import *
from bwrobot.srv import *
from bwrobot.msg import *
from LocMemEff import LocalModels
from sensor_msgs.msg import JointState
from std_msgs.msg import Int32
from std_msgs.msg import Float64


global local

def constructSrv(local):
       
    LocSrv = LocalGP()
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
        
    LocSrv.localGPs= L
    LocSrv.W = np.array(local.mdrift.kern.lengthscale).tolist() 
    LocSrv.M = local.M
    
    
    return LocMsg



def initGP(resp):
    
    "ROS Settings"
    rospy.init_node('initGP_node')
    R = rospy.get_param('~train_pub_rate')  
    cmd = JointState()
    cmd.name = ['joint1', 'joint2']      
    "Initialize Local Models"
    
    njit = rospy.get_param('~njit')
    YStart = rospy.get_param('~YStart')
    YStart = np.array(np.deg2rad(YStart)).reshape(1,2)
    num_inducing = rospy.get_param('~num_inducing')
    w_gen = rospy.get_param('~wgen')
    d = rospy.get_param('~drift')
    
    local = LocalModels(num_inducing, wgen = w_gen, drift = d, ndim = 2)
    YI = local.jitROS(njit,YStart)   
    XI = np.empty([0,2])

    for y in YI:        

        cmd.position = [y[0], y[1]]
        jspub.publish(cmd)
        rate.sleep()
        data = rospy.wait_for_message('experience',Point)
        XI = np.vstack((XI,np.array([data.x,data.y]).reshape(1,2)))     

    
    local.initROS(XI,YI) 
    
    LocSrv = constructSrv(local)

    return LocSrv
    
def init():
    
    rospy.init_node('init_server')
    s = rospy.Service('initGP',localGP_init,initGP)    
    rospy.spin()
    


    
if __name__ == '__main__':
    try:
        init()
    except rospy.ROSInterruptException:
        pass

