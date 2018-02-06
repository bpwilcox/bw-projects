import GPy
import scipy.io
import matplotlib.pyplot as pl
from matplotlib import animation
GPy.plotting.change_plotting_library('matplotlib')
import numpy as np
import time

global l1
global l2

l1 = 1
l2 = 1


# Functions

def partition(xnew,ynew,W,M,M_loc,wgen,Kernel):
    for n in range(0,np.shape(xnew)[0],1):
        w = np.empty([M,1])
#        print(xnew[n])
#        print(xnew)
        for k in range(0,M,1):

            c = M_loc[k][2] #1x2
            xW = np.dot((xnew[n]-c),W) # 1x2 X 2x2
#            print(xW)
#            print(xnew[n]-c)
            w[k] = np.exp(-0.5*np.dot(xW,np.transpose((xnew[n]-c))))
        wnear = np.max(w)
        near = np.argmax(w)
        if wnear > wgen:
            
            if len(M_loc[near][0]) > 100:
                r = np.random.choice(len(M_loc[near][0]), 1, replace=False)         
                M_loc[near][0] = np.delete(M_loc[near][0],r,0)
                M_loc[near][1] = np.delete(M_loc[near][1],r,0)
            
            M_loc[near][0] = np.vstack((M_loc[near][0],xnew[n]))
            M_loc[near][1] = np.vstack((M_loc[near][1],ynew[n]))
            M_loc[near][2] = np.mean(M_loc[near][0],axis=0)
        else:
            print('new')
            M_new = []
            M_new.append(xnew[n].reshape(1,2))
            M_new.append(ynew[n].reshape(1,2))
            M_new.append(xnew[n].reshape(1,2))
            M_loc.append(M_new)
            M = M+1
            Kernel.append(GPy.kern.RBF(2,ARD=True))
    return M_loc,M,Kernel

def train(Local,M,Kernel,P):

    Model = []
    for j in range(0, M, 1):

        if len(Local[j][0]) > P:
            m = GPy.models.SparseGPRegression(Local[j][0].reshape(np.shape(Local[j][0])[0], 2),Local[j][1].reshape(np.shape(Local[j][1])[0], 2), Kernel[j],num_inducing = P)
        else:
            m = GPy.models.GPRegression(Local[j][0].reshape(np.shape(Local[j][0])[0], 2),Local[j][1].reshape(np.shape(Local[j][1])[0], 2), Kernel[j])
        
        m.optimize(messages=False)
        
        Model.append(m)

    return Model

def trainK(Local,M,Kernel,Par):
    Model = []
    for j in range(0, M, 1):

        m = loadmodel(Local,Par,j,Kernel)
        Model.append(m)
     
    return Model
        
def trainInc(Local,M,Kernel,Par):
    Model = []
    for j in range(0, M, 1):

        m = loadmodel(Local,Par,j,Kernel)
        Model.append(m)
     
    return Model
def trainnew(Local,M,Kernel, Model):
    P = np.shape(Model)[0]
    for j in range(0, P, 1):  
        Model[j].set_XY(Local[j][0].reshape(np.shape(Local[j][0])[0], 2),Local[j][1].reshape(np.shape(Local[j][1])[0], 2))
        Model[j].optimize(messages=False)
        
        
    for k in range(P, M, 1):    
        m = GPy.models.GPRegression(Local[k][0].reshape(np.shape(Local[k][0])[0], 2),Local[k][1].reshape(np.shape(Local[k][1])[0], 2), Kernel[k])
        m.optimize(messages=False)
        Model.append(m)
        
    return Model

def jitter(n,Y_init):
    
  
    max_rough=0.05
    pert=max_rough * np.random.uniform(-1.,1.,(n,2))
#    YI = np.vstack(Y_init.reshape(1,2)*n)
  
    Y_start = Y_init + pert
    X_start = fkin(Y_start)
#    print(np.shape(X_start))
    return X_start,Y_start


def prediction(xtest,Local,Model):
 
    ypred = np.empty([np.shape(xtest)[0], 2])
    
    for n in range(0, np.shape(xtest)[0], 1):
        w = np.empty([M, 1])
        yploc = np.empty([M,2])
                
        var = np.empty([M,1])
        for k in range(0, M, 1):
            c = Local[k][2] #1x2
            xW = np.dot((xtest[n]-c),W) # 1x2 X 2x2
            w[k] = np.exp(-0.5*np.dot(xW,np.transpose((xtest[n]-c))))
            yploc[k], var[k] = Model[k].predict(xtest[n].reshape(1,2))

        if M == 1:
            h =1
        elif M == 2 :
            h = 2
        else:
            h = 2
            
        wv = np.multiply(w, np.exp(-var))

        ind = np.argpartition(wv[:,0], -h)[-h:]
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

# Training data

#Data_X = scipy.io.loadmat("2link_train_in")
#Data_Y = scipy.io.loadmat("2link_train_out")
#Xtrain = Data_X["P_data"]
#Ytrain = Data_Y["Joint_data"]


# Generate Test Data

# Circular test

n = 100
r = 0.5
x0 = -0.25
y0 = 1

theta = np.linspace(0,2*np.pi,n)
Xc = r*np.cos(theta) + x0
Yc = r*np.sin(theta) + y0

#Xc = r*(np.cos(theta) +np.sin(2*theta)) + x0
#Yc = r*(np.sin(theta) +np.cos(2*theta)) + y0
X_test = np.column_stack((Xc,Yc))

# # Rectangle Test
# n = 50
# wx1 = -0.5
# wx2 = 0
# wy1 = 1.2
# wy2 = 0.8
#
# C1 = np.linspace(wx1,wx2,n)
# C2 = np.linspace(wy1,wy2,n)
# C3 = np.linspace(wx2,wx1,n)
# C4 = np.linspace(wy2,wy1,n)
#
# # print np.ones((n,1))*wy
# C12 = np.column_stack((C1,np.ones((n,1))*wy1))
# C23 = np.column_stack((np.ones((n,1))*wx2,C2))
# C34 = np.column_stack((C3,np.ones((n,1))*wy2))
# C41 = np.column_stack((np.ones((n,1))*wx1,C4))
#
# X_test = np.vstack((C12,C23,C34,C41))

# Online Learning

def inkin(X):

    a = np.sqrt(1-((X[:,0]**2+X[:,1]**2-l1**2-l2**2)/float((2*l1*l2)))**2)
    b = (X[:,0]**2+X[:,1]**2-l1**2-l2**2)/float((2*l1*l2))

    Q2 = np.arctan2(a,b)

    Q1 = np.arctan2(X[:,1],X[:,0])-np.arctan2(l2*np.sin(Q2),l1+l2*np.cos(Q2))

    Q = np.column_stack((Q1,Q2))
    return Q



# Step 1: Initialize Local Models
Y_test = inkin(X_test)
M = 1
Kernel = []
Kernel.append(GPy.kern.RBF(2,ARD=True))
k = GPy.kern.RBF(2,ARD=True)
njit = 10

[XI,YI] = jitter(njit,Y_test[0])
M_init = GPy.models.GPRegression(XI,YI,Kernel[0])
M_init.optimize(messages=False)
Par = M_init.param_array
W = np.diag([1/M_init.rbf.lengthscale[0]**2,1/M_init.rbf.lengthscale[1]**2])

X_loc = []
X_loc.append(XI[0].reshape(1,2))
X_loc.append(YI[0].reshape(1,2))
X_loc.append(XI[0].reshape(1,2))

Local = []
Local.append(X_loc)
[Local,M,Kernel] = partition(XI,YI,W,M,Local,0.85,Kernel)

Model = trainK(Local,M,Kernel,Par)
Xtot = XI
Ytot = YI


drift = 5
ksamp = GPy.kern.RBF(2, ARD=True)

tc = np.empty([len(X_test)-1,1])

for i in range(1,np.shape(X_test)[0],1):
        t1 = time.time()


        Ypred = prediction(X_test[i].reshape(1,2),Local,Model)
        
        Yexp = Ypred
        Xexp = fkin(Yexp)
        Xtot = np.vstack((Xtot,Xexp))
        Ytot = np.vstack((Ytot,Yexp))    
        
        [Local,M,Kernel] = partition(Xexp.reshape(1,2),Yexp.reshape(1,2),W,M,Local,0.975,Kernel)
        Model = trainK(Local,M,Kernel,Par)
#        Model = train(Local,M,Kernel,15)
       
        
#        print(i)
        if i % drift == 0:
            [W, Par] = loadmodelsamp(Xtot[i + njit - drift:i + njit], Ytot[i + njit - drift:i + njit], ksamp, Par)
        
        t2 = time.time()
        tc[i-1]= t2-t1
#       


pl.plot(X_test[:,0],X_test[:,1],'-.')
pl.plot(Xtot[:,0],Xtot[:,1])




for i in range(0,M,1):
#    pl.cla()
    pl.plot(Local[i][0][:,0],Local[i][0][:,1],'.')
#    pl.plot(Local[i][2][0],Local[i][2][1],'k+')
#    
pl.show(block=True)

pl.figure()
pl.plot(tc)
pl.ylabel('Training and Prediction time (s)')
pl.xlabel('Iteration')
pl.show(block=True)
