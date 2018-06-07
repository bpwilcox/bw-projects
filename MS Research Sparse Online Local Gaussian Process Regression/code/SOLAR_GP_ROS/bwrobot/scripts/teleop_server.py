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
import RobotModels


global x_tel
global n
n = 250
r = 0.5
twolink = RobotModels.nLink2D(Links = [1,1])
#YStart = rospy.get_param('~YStart')
#YStart = np.array(np.deg2rad(YStart)).reshape(1,2)
YStart = np.array(np.deg2rad([0,45])).reshape(1,2)

XStart = twolink.fkin(YStart)

#data = rospy.wait_for_message('experience',Point)
#XStart = np.array([data.x,data.y]).reshape(1,2)

x0 = XStart[0][0]-r
y0 = XStart[0][1]
#x0 = -0.25
#y0 = 1

#    star = Trajectory.Star2D(n,5,r,x0,y0)
circle = Trajectory.Circle2D(n,r,x0,y0,arclength = 2*np.pi)
#    nPoly = Trajectory.nPoly2D(n,4,r,x0,y0)
#    spiral = Trajectory.Spiral2D(n,0.6,0.1,x0,y0,6*np.pi)

x_tel = circle.xtest


def nextPoint(resp):
    
    i = resp.i%n

    x = x_tel[i,0]
    y = x_tel[i,1]
    z = float(resp.i)    
    print([x,y])
    return x,y,z
    
def tel():

    rospy.init_node('Teleop_server')
    s = rospy.Service('teleop_next',EndEffector,nextPoint)    
    rospy.spin()
        
    
if __name__ == '__main__':
    try:
        tel()
    except rospy.ROSInterruptException:
        pass
