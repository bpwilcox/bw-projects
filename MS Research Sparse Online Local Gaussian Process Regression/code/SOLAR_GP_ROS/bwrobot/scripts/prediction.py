#!/usr/bin/env python

import rospy
import numpy as np
from geometry_msgs.msg import Point
import GPy
import time
import Trajectory
from TestData import TestTrajectory
import RobotModels
import osgpr_GPy
#from Local import LocalModels
from LocMemEff import LocalModels

from sensor_msgs.msg import JointState

from std_msgs.msg import Int32
from std_msgs.msg import Float64
from bwrobot.srv import *
from bwrobot.msg import *
"Prediction node also serves as a client node for an input"

#global local
#global woo
def teleop_client(i):
    rospy.wait_for_service('teleop_next')
    nextPoint = rospy.ServiceProxy('teleop_next',EndEffector)
    data = nextPoint(i)
    return data

def callback(LocMsg):
    local = deconstructMsg(LocMsg)
    return woo
    
    
def deconstructMsg(LocMsg):
    
    W = LocMsg.W
    W = np.diag([1/(W[0]**2), 1/(W[1]**2)])  

    
    M = LocMsg.M
    LocalData = []
    Models = []
    for L in LocMsg.localGPs:
        
        X_loc = []
        X_loc.append(L.numloc)
        X_loc.append(L.numloc)
        X_loc.append(np.array(L.xmean).reshape(1,2))
        X_loc.append(np.array(L.ymean).reshape(1,2))
        X_loc.append(True)
        
        LocalData.append(X_loc)
#        kern_var = L.kern_var
#        kern_lengthscale = L.kern_lengthscale
        X = np.empty([0,2]) 
        Y = np.empty([0,2]) 

        Z = np.empty([0,2]) 
        Z_old = np.empty([0,2])
        mu_old = np.empty([0,2])
        Su_old = np.empty([0,len(L.Z_old)])
        Kaa_old = np.empty([0,len(L.Z_old)])

        kern = GPy.kern.RBF(2,ARD=True)
        kern.variance = L.kern_var
        kern.lengthscale = L.kern_lengthscale
        
        for x,y in zip(L.X,L.Y):
            X = np.vstack((X,np.array(x.array).reshape(1,2)))       
            Y = np.vstack((Y,np.array(y.array).reshape(1,2)))       
                       
        for z in L.Z:
            Z = np.vstack((Z,np.array(z.array).reshape(1,2)))
            
        for z,mu,su,ka in zip(L.Z_old, L.mu_old,L.Su_old,L.Kaa_old):
            Z_old = np.vstack((Z_old,np.array(z.array).reshape(1,2)))        
            mu_old = np.vstack((mu_old,np.array(mu.array).reshape(1,2)))        
            Su_old = np.vstack((Su_old,np.array(su.array).reshape(1,len(L.Z_old))))        
            Kaa_old = np.vstack((Kaa_old,np.array(ka.array).reshape(1,len(L.Z_old))))    
            
#        X = np.array(L.X).reshape(1,2)
#        Y = np.array(L.Y).reshape(1,2)
        m = osgpr_GPy.OSGPR_VFE(X, Y, kern, mu_old, Su_old, Kaa_old, Z_old, Z)    
        m.kern.variance = L.kern_var
        m.kern.lengthscale = np.array(L.kern_lengthscale)
        m.likelihood.variance = L.likelihood_var
        Models.append(m)
        
    local = LocalModels()
    local.W = W
    local.M = M
    local.LocalData = LocalData
    local.Models = Models
    
    
    return local

class GetLocal():
    def __init__(self):
        self.local = LocalModels()
#        self.publisher = 
#        self.subscriber
        self.count = 0
    
    def callback(self,LocMsg):
        
        W = LocMsg.W
#        W = np.diag([1/(W[0]**2), 1/(W[1]**2)])  
        W = np.diag([W[0],W[1]])

        M = LocMsg.M
        LocalData = []
        Models = []
        for L in LocMsg.localGPs:
            
            X_loc = []
            X_loc.append(L.numloc)
            X_loc.append(L.numloc)
            X_loc.append(np.array(L.xmean).reshape(1,2))
            X_loc.append(np.array(L.ymean).reshape(1,2))
            X_loc.append(True)
            
            LocalData.append(X_loc)
    #        kern_var = L.kern_var
    #        kern_lengthscale = L.kern_lengthscale
            X = np.empty([0,2]) 
            Y = np.empty([0,2]) 
    
            Z = np.empty([0,2]) 
            Z_old = np.empty([0,2])
            mu_old = np.empty([0,2])
            Su_old = np.empty([0,len(L.Z_old)])
            Kaa_old = np.empty([0,len(L.Z_old)])
    
            kern = GPy.kern.RBF(2,ARD=True)
            kern.variance = L.kern_var
            kern.lengthscale = L.kern_lengthscale
            
            for x,y in zip(L.X,L.Y):
                X = np.vstack((X,np.array(x.array).reshape(1,2)))       
                Y = np.vstack((Y,np.array(y.array).reshape(1,2)))       
                           
            for z in L.Z:
                Z = np.vstack((Z,np.array(z.array).reshape(1,2)))
                
            for z,mu,su,ka in zip(L.Z_old, L.mu_old,L.Su_old,L.Kaa_old):
                Z_old = np.vstack((Z_old,np.array(z.array).reshape(1,2)))        
                mu_old = np.vstack((mu_old,np.array(mu.array).reshape(1,2)))        
                Su_old = np.vstack((Su_old,np.array(su.array).reshape(1,len(L.Z_old))))        
                Kaa_old = np.vstack((Kaa_old,np.array(ka.array).reshape(1,len(L.Z_old))))    
                
    #        X = np.array(L.X).reshape(1,2)
    #        Y = np.array(L.Y).reshape(1,2)
            m = osgpr_GPy.OSGPR_VFE(X, Y, kern, mu_old, Su_old, Kaa_old, Z_old, Z)    
            m.kern.variance = L.kern_var
            m.kern.lengthscale = np.array(L.kern_lengthscale)
            m.likelihood.variance = L.likelihood_var
            Models.append(m)
            
        local = LocalModels()
        local.W = W
        local.M = M
        local.LocalData = LocalData
        local.Models = Models
#        print(local.W)        
        self.local = local    
        self.count+=1
        

def predict():
#    global local
#    global woo


    "ROS Settings"
    rospy.init_node('predict_node')
    prediction = rospy.Publisher('prediction', Arrays, queue_size=10)
        
    R = rospy.get_param('~predict_pub_rate')
    rate = rospy.Rate(1)
    
    YStart = rospy.get_param('~YStart')
    YStart = np.array(np.deg2rad(YStart)).reshape(1,2)
    Yexp = YStart 
    i = 1
    Loc = GetLocal()    
    
#    local2 = LocalModels()
    LocMsg = rospy.wait_for_message('localGP',LocalGP)
    local = deconstructMsg(LocMsg)  
    Loc.local = local
#    rospy.Rate(0.05).sleep
    "Main Loop"
    while not rospy.is_shutdown():
        print(i)
        "Get next model"   
        print("Get next model")             
#        rospy.Subscriber('localGP',LocalGP,callback)
        rospy.Subscriber('localGP',LocalGP,Loc.callback)

#        LocMsg = rospy.wait_for_message('localGP',LocalGP)
#        local = deconstructMsg(LocMsg)
#        Loc.local = local
#        local2 = local
#        if 'woo' in globals():
#            local2 = local
#        else:
#            continue
#        print(Loc.count)
#        print(Loc.local.W)
        "Grab Teleoperator command"
        print("get teleop")
        
        data = teleop_client(i) 
        xnext = np.array([data.x,data.y])
#        print(xnext)

        "Prediction"   
        Ypred,_ = Loc.local.prediction(xnext.reshape(1,2),Y_prev = Yexp)
#        Ypred,_ = local.prediction(xnext.reshape(1,2),Y_prev = Yexp)    
#        Ypred,_ = local.Models[0].predict(xnext.reshape(1,2))
        Ypost = np.vstack((Yexp,Ypred))   
        Ypost = np.unwrap(Ypost,axis=0)
        Yexp = Ypost[-1].reshape(1,2)
        print("Ypred: " + str(Yexp))
        Y = [float(Yexp[0][0]), float(Yexp[0][1])]
        prediction.publish(Y)
               
        "Next"        
        i+=1
        rate.sleep()         

if __name__ == '__main__':
    try:
        predict()
    except rospy.ROSInterruptException:
        pass
