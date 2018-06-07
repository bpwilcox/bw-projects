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
from std_msgs.msg import Float32
from bwrobot.srv import *


jspub = rospy.Publisher('joint_states', JointState, queue_size=10)
cmd = JointState()
cmd.name = ['joint1', 'joint2']    
#cmd.name = ['joint1', 'joint2','joint3','joint4']    
#cmd.name = ['joint1', 'joint2','joint3','joint4','joint5','joint6']   

def callback(data, args):

    cmd = args[0]
    Yexp = data
    cmd.position = [Yexp[0][0], Yexp[0][1]]    
#    cmd.position = [Yexp[0][0], Yexp[0][1],Yexp[0][2], Yexp[0][3],Yexp[0][4], Yexp[0][5]]
    
    jspub.publish(cmd)
    

def actuate():

    "ROS Settings"
    rospy.init_node('controller_node')
    rospy.Subscriber('prediction',Float32,callback,cmd)
    rospy.spin()

if __name__ == '__main__':
    try:
        actuate()
    except rospy.ROSInterruptException:
        pass
