#!/usr/bin/env python

import rospy
from rospy_tutorials.msg import Floats
from rospy.numpy_msg import numpy_msg
import numpy as np
import Trajectory
from geometry_msgs.msg import Point








def tel():

    n = 250
    r = 0.5
    x0 = -0.25
    y0 = 1

#    star = Trajectory.Star2D(n,5,r,x0,y0)
    circle = Trajectory.Circle2D(n,r,x0,y0,arclength = 2*np.pi)
#    nPoly = Trajectory.nPoly2D(n,4,r,x0,y0)
#    spiral = Trajectory.Spiral2D(n,0.6,0.1,x0,y0,6*np.pi)

    x_tel = circle.xtest

	
    pub = rospy.Publisher('teleop', numpy_msg(Floats), queue_size=10)
    pub2 = rospy.Publisher('point', Point, queue_size=10)

    R = 10
#    R = rospy.get_param('~pub_rate')
    rospy.init_node('Teleop_node')
    rate = rospy.Rate(R)
    
    i = 0
    N = len(x_tel)
    while not rospy.is_shutdown():
        if i > N-1:
            i = 0
            
#        x = np.array(x_tel[i],dtype = np.float64)
#        x = np.array([float(x_tel[i,0]),float(x_tel[i,1]),float(0)])
#        x.astype(np.float64)
#        x = np.array([trans[0],trans[1]], dtype=numpy.float32) 
#        pub.publish(x)
        
        
        newpoint = Point()
        newpoint.x = x_tel[i,0]
        newpoint.y = x_tel[i,1]
        newpoint.z = float(i)
        pub2.publish(newpoint)
#        rospy.loginfo(newpoint)
        i+=1
        rate.sleep()
    
    
    
    
    
    
if __name__ == '__main__':
    try:
        tel()
    except rospy.ROSInterruptException:
        pass
