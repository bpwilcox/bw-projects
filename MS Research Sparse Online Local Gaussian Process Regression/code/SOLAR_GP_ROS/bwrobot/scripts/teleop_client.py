#!/usr/bin/env python

import rospy
from rospy_tutorials.msg import Floats
from rospy.numpy_msg import numpy_msg
import numpy as np
import Trajectory
from geometry_msgs.msg import Point
from bwrobot.srv import *
import sys


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
def tel():


    R = 5
    rospy.init_node('Teleop_client')
    rate = rospy.Rate(R)
    
    i = 0
    N = 250
    while not rospy.is_shutdown():
        if i > N-1:
            i = 0
            
#        x = np.array(x_tel[i],dtype = np.float64)
#        x = np.array([float(x_tel[i,0]),float(x_tel[i,1]),float(0)])
#        x.astype(np.float64)
#        x = np.array([trans[0],trans[1]], dtype=numpy.float32) 
#        pub.publish(x)

        data = teleop_client(i)
#        newpoint = Point()
#        newpoint.x = x_tel[i,0]
#        newpoint.y = x_tel[i,1]
#        newpoint.z = float(i)
#        pub2.publish(newpoint)
        print(data)
        print('---')
        i+=1
        rate.sleep()
    
#    
#    
    
    
    
if __name__ == '__main__':
#    if len(sys.argv) == 2:
#        i = int(sys.argv[1])
#    else:
#        sys.exit(1)
#    print(teleop_client(i))
    try:
        tel()
    except rospy.ROSInterruptException:
        pass

        
    
