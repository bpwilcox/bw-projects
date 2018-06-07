#!/usr/bin/env python

import rospy
# import math
import tf
import numpy as np
from visualization_msgs.msg import Marker
from geometry_msgs.msg import Point
from rospy.numpy_msg import numpy_msg
from rospy_tutorials.msg import Floats
import numpy
from bwrobot.srv import *
from bwrobot.msg import *

def poser():
   
	
    listener = tf.TransformListener()  # This will listen to the tf data later

    pub = rospy.Publisher('floats', numpy_msg(Floats), queue_size=10)
    pub2 = rospy.Publisher('experience', Point, queue_size=10)
    rospy.init_node('sensor_node')
	
    R = rospy.get_param('~tf_ee_pub_rate')
    rate = rospy.Rate(R)
#    listener.waitForTransform('base', 'endEffector', rospy.Time(), rospy.Duration(4.0))    
    while not rospy.is_shutdown():


        try:
            now = rospy.Time.now()
#            (trans,rot) = listener.waitForTransform('base', 'endEffector', now, rospy.Duration(10.0))    
#            (trans, rot) = listener.lookupTransform('base', 'endEffector', now)
            (trans, rot) = listener.lookupTransform('base', 'endEffector', rospy.Time(0))  
            
        except (tf.LookupException, tf.ConnectivityException, tf.ExtrapolationException):
            continue

        newpoint = Point()
        newpoint.x = trans[0]
        newpoint.y = trans[1]
        newpoint.z = trans[2]
        pub2.publish(newpoint)
        Xexp = np.array([trans[0],trans[1]], dtype=numpy.float32)
        # a = numpy.array([1.0, 2.1, 3.2, 4.3, 5.4, 6.5], dtype=numpy.float32)
        pub.publish(Xexp)

#        if len(marker.points) > 40:
#           marker.points.pop(0)  # To make the old trail disappear continuously

        rate.sleep()


if __name__ == '__main__':
    try:
        poser()
    except rospy.ROSInterruptException:
        pass

