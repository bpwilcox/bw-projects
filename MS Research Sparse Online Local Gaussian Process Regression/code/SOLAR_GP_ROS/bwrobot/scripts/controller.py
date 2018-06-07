#!/usr/bin/env python

import rospy
from sensor_msgs.msg import JointState
from math import sin, cos, acos, atan2, pi, sqrt
import tf
from rospy_tutorials.msg import Floats
from rospy.numpy_msg import numpy_msg
import numpy as np

def desired_thetas(t, T):
    xd = 0.75*cos(2*pi*t/T) + 1.25
    yd = 0.75*sin(2*pi*t/T)
    r = sqrt(xd**2 + yd**2)

    alpha = acos(1 - (r**2)/2)
    beta = acos(r/2)

    theta2 = pi - alpha
    theta1 = atan2(yd, xd) - beta

    return [theta1, theta2]

def sender():
    jspub = rospy.Publisher('joint_states', JointState, queue_size=10)
    # pos = rospy.Subscriber("point", Point, self.callback)

    rospy.init_node('controller_node')
    R = rospy.get_param('~controller_pub_rate')
    rate = rospy.Rate(R)

    T = rospy.get_param('~period')

    listener = tf.TransformListener()
    cmd = JointState()
    print(cmd)
    while not rospy.is_shutdown():




        cmd.header.stamp = rospy.Time.now()
        t = rospy.get_time()

        cmd.name = ['baseHinge', 'interArm']
        cmd.position = desired_thetas(t, T)

        jspub.publish(cmd)

#        try:
#            now = rospy.Time.now()
            # listener.waitForTransform("/base", "/endEffector", now, rospy.Duration(10.0))
#            (trans, rot) = listener.lookupTransform("/base", "/endEffector", now)
#        except (tf.LookupException, tf.ConnectivityException):
#            continue

        rate.sleep()



if __name__ == '__main__':
    try:
        sender()
    except rospy.ROSInterruptException:
        pass

