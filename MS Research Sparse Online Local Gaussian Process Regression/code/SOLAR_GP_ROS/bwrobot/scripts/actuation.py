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

def callback(data,cmd,jspub):
    jspub = rospy.Publisher('joint_states', JointState, queue_size=10)
    cmd = JointState()
    cmd.name = ['joint1', 'joint2']          
    Yexp = np.array(data.array).reshape(1,2)
    "Actuation"
    cmd.position = [Yexp[0][0], Yexp[0][1]]
    jspub.publish(cmd)         

def actuate():

    "ROS Settings"
    jspub = rospy.Publisher('joint_states', JointState, queue_size=10)
    rospy.init_node('actuator_node')

    R = rospy.get_param('~controller_pub_rate')
    rate = rospy.Rate(R)

    cmd = JointState()
    cmd.name = ['joint1', 'joint2']    
#    cmd.name = ['joint1', 'joint2','joint3','joint4']    
#    cmd.name = ['joint1', 'joint2','joint3','joint4','joint5','joint6']    

    "Main Loop"
    while not rospy.is_shutdown():

        cmd.header.stamp = rospy.Time.now()
        
        "Get Latest Prediction"
#        print("get predict")
#        rospy.Subscriber('prediction',Arrays,callback,(cmd,jspub))    
        
        data = rospy.wait_for_message('prediction',Arrays)   
        Yexp = np.array(data.array).reshape(1,2)
        
#        Yexp = np.array([0.08,0.8]).reshape(1,2)
        "Actuation"
        cmd.position = [Yexp[0][0], Yexp[0][1]]
        jspub.publish(cmd)  
#        
        
        "Next"        
        rate.sleep()
#        rospy.spin()
         

if __name__ == '__main__':
    try:
        actuate()
    except rospy.ROSInterruptException:
        pass
