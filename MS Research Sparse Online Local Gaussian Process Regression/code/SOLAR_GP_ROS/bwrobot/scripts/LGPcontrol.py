#!/usr/bin/env python

import rospy
from sensor_msgs.msg import JointState
from math import sin, cos, acos, atan2, pi, sqrt
import GPy
import scipy.io
import numpy as np
import time
from rospy_tutorials.msg import Floats
from rospy.numpy_msg import numpy_msg
import tf
from std_msgs.msg import Int32
from std_msgs.msg import Float32

global l1
global l2

l1 = 1
l2 = 1


def partition(xnew, ynew, W, M, M_loc, wgen, Kernel):
    for n in range(0, np.shape(xnew)[0], 1):
        w = np.empty([M, 1])
        #        print(xnew[n])
        #        print(xnew)
        for k in range(0, M, 1):
            c = M_loc[k][2]  # 1x2
            xW = np.dot((xnew[n] - c), W)  # 1x2 X 2x2
            #            print(xW)
            #            print(xnew[n]-c)
            w[k] = np.exp(-0.5 * np.dot(xW, np.transpose((xnew[n] - c))))
        wnear = np.max(w)
        near = np.argmax(w)
        if wnear > wgen:

            if len(M_loc[near][0]) > 15:
                r = np.random.choice(len(M_loc[near][0]), 1, replace=False)
                M_loc[near][0] = np.delete(M_loc[near][0],r,0)
                M_loc[near][1] = np.delete(M_loc[near][1],r,0)

            M_loc[near][0] = np.vstack((M_loc[near][0], xnew[n]))
            M_loc[near][1] = np.vstack((M_loc[near][1], ynew[n]))
            M_loc[near][2] = np.mean(M_loc[near][0], axis=0)
        else:
            print('new')
            M_new = []
            M_new.append(xnew[n].reshape(1, 2))
            M_new.append(ynew[n].reshape(1, 2))
            M_new.append(xnew[n].reshape(1, 2))
            M_loc.append(M_new)
            M = M + 1
            Kernel.append(GPy.kern.RBF(2, ARD=True))
    return M_loc, M, Kernel


def trainK(Local, M, Kernel, Par):
    Model = []
    for j in range(0, M, 1):
        m = loadmodel(Local, Par, j, Kernel)
        Model.append(m)

    return Model


def train(Local, M, Kernel,P):

    Model = []
    for j in range(0, M, 1):
        if len(Local[j][0])>P:
            m = GPy.models.SparseGPRegression(Local[j][0].reshape(np.shape(Local[j][0])[0], 2),Local[j][1].reshape(np.shape(Local[j][1])[0], 2), Kernel[j],num_inducing = P)
        else:
            m = GPy.models.GPRegression(Local[j][0].reshape(np.shape(Local[j][0])[0], 2),
                                    Local[j][1].reshape(np.shape(Local[j][1])[0], 2), Kernel[j])

        # m.optimize(messages=False)

        Model.append(m)

    return Model

def jitter(n, Y_init):
    max_rough = 0.05
    pert = max_rough * np.random.uniform(-1., 1., (n, 2))
    #    YI = np.vstack(Y_init.reshape(1,2)*n)

    Y_start = Y_init + pert
    X_start = fkin(Y_start)
    #    print(np.shape(X_start))
    return X_start, Y_start


def prediction(xtest, Local, Model):
    ypred = np.empty([np.shape(xtest)[0], 2])
    for n in range(0, np.shape(xtest)[0], 1):
        w = np.empty([M, 1])
        yploc = np.empty([M, 2])
        var = np.empty([M, 1])
        for k in range(0, M, 1):
            c = Local[k][2]  # 1x2
            xW = np.dot((xtest[n] - c), W)  # 1x2 X 2x2
            w[k] = np.exp(-0.5 * np.dot(xW, np.transpose((xtest[n] - c))))
            #            print(Model[k].predict(xtest[n].reshape(1,2)))
            yploc[k], var[k] = Model[k].predict(xtest[n].reshape(1, 2))

        if M == 1:
            h = 1
        elif M == 2:
            h = 2
        else:
            h = 3

        wv = np.multiply(w, np.exp(-var))

        ind = np.argpartition(wv[:, 0], -h)[-h:]

        ypred[n] = np.dot(np.transpose(wv[ind]), yploc[ind]) / np.sum(wv[ind])

    return ypred

def loadmodel(Local,Par,j,Kernel):

    m_load = GPy.models.GPRegression(Local[j][0].reshape(np.shape(Local[j][0])[0], 2),Local[j][1].reshape(np.shape(Local[j][1])[0], 2), Kernel[j], initialize=False)

    m_load.update_model(False)
    m_load.initialize_parameter()
    m_load[:] = Par  # Load the parameters
    m_load.update_model(True)  # Call the algebra only once
    return m_load

def loadmodelsamp(X,Y,Ksamp,Par):

    m_load = GPy.models.GPRegression(X,Y, Ksamp, initialize=False)

    m_load.update_model(False)
    m_load.initialize_parameter()
    m_load[:] = Par  # Load the parameters
    m_load.update_model(True)  # Call the algebra only once
    m_load.optimize(messages=False)
    W = np.diag([1 / m_load.rbf.lengthscale[0] ** 2, 1 / m_load.rbf.lengthscale[1] ** 2])
    Par = m_load.param_array
    return W,Par



def fkin(Q):
    X = l1*np.cos(Q[:,0])+np.cos(Q[:,0]+Q[:,1])
    Y = l1*np.sin(Q[:,0])+np.sin(Q[:,0]+Q[:,1])
    P = np.column_stack((X,Y))
    return P

def desired_positions(t, T):
    xd = 0.7*cos(2*pi*t/T) + 1.25
    yd = 0.7*sin(2*pi*t/T)
    # xd = 1.5
    # yd = 0

    P = np.array([xd,yd])
    return P

def inkin(xd,yd):
    r = sqrt(xd**2 + yd**2)

    alpha = acos(1 - (r**2)/2)
    beta = acos(r/2)

    theta2 = pi - alpha
    theta1 = atan2(yd, xd) - beta
    Y_test = [theta1, theta2]
    return Y_test


def getRectangle():
    n = 50
    wx1 = -0.5
    wx2 = 0.5
    wy1 = 1
    wy2 = -1

    C1 = np.linspace(wx1,wx2,n)
    C2 = np.linspace(wy1,wy2,n)
    C3 = np.linspace(wx2,wx1,n)
    C4 = np.linspace(wy2,wy1,n)

    # print np.ones((n,1))*wy
    C12 = np.column_stack((C1,np.ones((n,1))*wy1))
    C23 = np.column_stack((np.ones((n,1))*wx2,C2))
    C34 = np.column_stack((C3,np.ones((n,1))*wy2))
    C41 = np.column_stack((np.ones((n,1))*wx1,C4))

    X_test = np.vstack((C12,C23,C34,C41))
    return X_test, len(X_test)


def getCircle():
    n = 100
    r = 0.5
    x0 = 0.5
    y0 = 0.8

    theta = np.linspace(0,2*np.pi,n)
    Xc = r*np.cos(theta) + x0
    Yc = r*np.sin(theta) + y0
    X_test = np.column_stack((Xc,Yc))
    return X_test, len(X_test)

def getCircle2(r):
    n = 100

    x0 = -0.25
    y0 = 1

    theta = np.linspace(0,2*np.pi,n)
    Xc = r*np.cos(theta) + x0
    Yc = r*np.sin(theta) + y0
    X_test = np.column_stack((Xc,Yc))
    return X_test, len(X_test)


def getSpiral():
    n = 100
    r = 0.5
    x0 = -0.25
    y0 = 1

    theta = np.linspace(0,2*np.pi,n)
    Xc = r*(np.cos(theta)+np.sin(2*theta)) + x0
    Yc = r*(np.sin(theta)+np.sin(2*theta)) + y0
    X_test = np.column_stack((Xc,Yc))
    return X_test, len(X_test)



def grabTest(X_test,i):
    P = X_test[i].reshape(1,2)
    return P

def sender():
    jspub = rospy.Publisher('joint_states', JointState, queue_size=10)

    rospy.init_node('controller_node')
    count  = rospy.Publisher('count', Int32, queue_size=10)
    value= rospy.Publisher('value', Float32, queue_size=10)
    listener = tf.TransformListener()
    R = rospy.get_param('~controller_pub_rate')
    rate = rospy.Rate(R)

    T = rospy.get_param('~period')
    # r = 0.2
    [X_test,N] = getCircle()
    # [X_test,N] = getRectangle()
    # [X_test, N] = getSpiral()

    cmd = JointState()

    global M
    global W
    M = 1
    Kernel = []
    Kernel.append(GPy.kern.RBF(2, ARD=True))
    # k = GPy.kern.RBF(2, ARD=True)
    njit = 10
    Yexp = inkin(X_test[0][0],X_test[0][1])
    [XI, YI] = jitter(njit, Yexp)
    M_init = GPy.models.GPRegression(XI, YI, Kernel[0])
    M_init.optimize(messages=False)
    Par = M_init.param_array
    W = np.diag([1 / M_init.rbf.lengthscale[0] ** 2, 1 / M_init.rbf.lengthscale[1] ** 2])

    X_loc = []
    X_loc.append(XI[0].reshape(1, 2))
    X_loc.append(YI[0].reshape(1, 2))
    X_loc.append(XI[0].reshape(1, 2))

    Local = []
    Local.append(X_loc)
    [Local, M, Kernel] = partition(XI, YI, W, M, Local, 0.975, Kernel)
    Model = trainK(Local, M, Kernel, Par)
    # Model = train(Local, M, Kernel,1000)
    global Xtot
    global Ytot


    Xtot = XI
    Ytot = YI

    # [X_test,N] = getCircle()
    # [X_test,N] = getRectangle()
    Xexp = np.empty([1,2])
    X2 = np.array([[4,1]])
    i = 0
    nr = 25

    ksamp = GPy.kern.RBF(2, ARD=True)
    sigma =0
    drift = 10
    while not rospy.is_shutdown():

        cmd.header.stamp = rospy.Time.now()
        t = rospy.get_time()
        count.publish(i)
        value.publish(M)


        if i > N-1:
            i = 0



        cmd.name = ['baseHinge', 'interArm']

        Ypred = prediction(grabTest(X_test,i), Local, Model).reshape(1, 2)

        # Ypred = Ypred*n
        cmd.position = [Ypred[0][0], Ypred[0][1]]
        jspub.publish(cmd)
        i = i+1


        # grab sensor output of end effector position

        # try:
        #     now = rospy.Time.now()
        #     (trans, rot) = listener.lookupTransform('base', 'endEffector', now)
        # except (tf.LookupException, tf.ConnectivityException, tf.ExtrapolationException):
        #     continue

        # Xexp = np.array([[trans[0],trans[1]]])


        Xexp = fkin(Ypred) 
        Yexp = Ypred




        Xtot = np.vstack((Xtot, Xexp))
        Ytot = np.vstack((Ytot, Yexp))

        [Local, M, Kernel] = partition(Xexp.reshape(1, 2), Yexp.reshape(1, 2), W, M, Local, 0.5, Kernel)
        Model = trainK(Local, M, Kernel, Par)
        # Model = train(Local, M, Kernel,15)

        if i % drift ==0:
            [W, Par] = loadmodelsamp(Xtot[i + njit - drift:i + njit], Ytot[i + njit - drift:i + njit], ksamp, Par)

        rate.sleep()



if __name__ == '__main__':
    try:
        sender()
    except rospy.ROSInterruptException:
        pass

