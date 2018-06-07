#!/usr/bin/env python

import rospy
import numpy as np
from geometry_msgs.msg import Point
from bwrobot.srv import *
from bwrobot.msg import *



def callback(data):
    print('...')

def listener():

    rospy.init_node('listener')
    rospy.Subscriber('point',Point,callback)
    rospy.spin()
    

    
    
if __name__ == '__main__':
    try:
        listener()
    except rospy.ROSInterruptException:
        pass












