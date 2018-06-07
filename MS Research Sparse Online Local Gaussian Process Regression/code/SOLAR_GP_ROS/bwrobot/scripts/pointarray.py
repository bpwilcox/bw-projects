#!/usr/bin/env python

import rospy
# import math
import tf
import numpy as np
from visualization_msgs.msg import Marker
from geometry_msgs.msg import Point
from rospy.numpy_msg import numpy_msg
from rospy_tutorials.msg import Floats
from bwrobot.msg import *
import numpy

def poser():
   
    pub = rospy.Publisher('point_array', PointArray, queue_size=10)
    pub2 = rospy.Publisher('point_list', PointList, queue_size=10)
    rospy.init_node('Point_node')
	
    rate = rospy.Rate(1)
    while not rospy.is_shutdown():

        Point2D = PointArray()
        Point3D = PointList()
        
#        newpoint.x = 1.0
#        newpoint.y = 2.0
#        newpoint.z = 0.0        
        P = []
        Z = []
        for i in range(0,10):
            

            newpoint = Point()
            Array = Arrays()
            
            newpoint.x = 1.0
            newpoint.y = 2.0
            newpoint.z = i
            Array.array = [1.0,2.0,i]
            
            P.append(newpoint)
            Z.append(Array)
            
#        Point2D.point_array = [newpoint,newpoint,newpoint]
        Point2D.point_array = P
        Point2D.num_pts = len(P)
        Point2D.array2d = Z
          
#        Point3D.point_list = [Point2D,Point2D,Point2D]  
#        Point3D.num_models = 3
        
        pub.publish(Point2D)
#        pub2.publish(Point3D)
        
#        print("next")
        rate.sleep()

if __name__ == '__main__':
    try:
        poser()
    except rospy.ROSInterruptException:
        pass

