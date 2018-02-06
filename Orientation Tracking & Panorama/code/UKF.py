from __future__ import division

import numpy as np
import matplotlib.pyplot as plt
from transforms3d.euler import euler2mat, mat2euler, quat2euler
from quatstuff import multq,conjq, invq, logq, avgq, rotq, expq
from bias import acc, wrot, ts, A_eul, eul, tsv, imud, vicd, camd, filenum

#------------------------------------------------------------------------------#

def getSigmaPoints(P,Q,x,n):
    
    X = np.zeros([x.shape[0],2*n+1])
    S = np.linalg.cholesky(P+Q)
    W = np.sqrt(n)*S
    W = np.hstack((W,-W))
    
    X[:,0] = x
    for i,w in enumerate(W.transpose()):
        

        qW = expq(np.hstack((0,w/2)))     
        
        Xi = multq(x,qW)
        X[:,i+1] = Xi
         
    return X
    
    
def getSigPred(X,w_mean,wrot,dt):
    
    Y = np.zeros(X.shape) 

    for i,xi in enumerate(X.transpose()):
        
        qt = expq(np.hstack((0,wrot*dt/2)))
        qi = multq(xi,qt)
        Y[:,i] = qi
    
    
    xmean, Evi = avgq(Y.transpose(),w_mean,x)
    Pm = 2*np.dot(Evi[:,0],Evi[:,0].transpose()) + np.dot(Evi[:,1:],Evi[:,1:].transpose())/(2*n)
    
    return Y,xmean,Evi,Pm


def getSigUpd(Y,xmean,w_mean,acc,n):
    
    g = np.array([0,0,0,1])
    Z = np.zeros([3,2*n+1])
    
    for i,qi in enumerate(Y.transpose()):
        
        zi = multq(multq(conjq(qi),g),qi)
        zi = zi[1:]
        Z[:,i] =zi 
    

    zacc = np.dot(Z,w_mean)  
    nu = acc-zacc
   
    return Z,zacc,nu

def updateX(Z,zacc,nu,Evi,Pm,R):
    
    Pzz = 2*np.dot((Z-zacc)[:,0],(Z-zacc)[:,0].transpose()) + np.dot((Z-zacc)[:,1:],(Z-zacc)[:,1:].transpose())/(2*n)
    Pvv = Pzz + R
    Pxz= 2*np.dot(Evi[:,0],(Z-zacc)[:,0].transpose()) + np.dot(Evi[:,1:],(Z-zacc)[:,1:].transpose())/(2*n)
    
    K = np.dot(Pxz, np.linalg.inv(Pvv))
    P = Pm - np.dot(np.dot(K,Pvv),K.transpose())
    
    V = np.hstack((0,np.dot(K,np.reshape(nu,[3,]))/2))
    
    x = multq(xmean,expq(V))

    return K,P,x

#------------------------------------------------------------------------------#
plt.close("all")
# Initialization
q = np.array([1,0,0,0])
x = q
n = 3


Q = 0.0001*np.eye(n)
R = 0.1*np.eye(n)
P = 0.0001*np.eye(n)

td = np.diff(ts)
td = np.append(td,td[:,-1])
td = np.reshape(td,[1,np.shape(ts)[1]])

N = 400
N = np.shape(ts)[1]
#
Xpred = np.zeros([N,3])
Zmean = np.zeros([3,N])
Xupd = np.zeros([N,3])
Xquats = np.zeros([N,4])

#------------------------------------------------------------------------------#
for i in range(0,N):
      
    # Obtain Sigma Points
    X = getSigmaPoints(P,Q,x,n)
    
    # Prediction Step
    w_mean = np.hstack((0,np.ones(2*n)/(2*n)))
    w_mean = np.reshape(w_mean,[2*n+1,1])
    dt = 0.01
    dt = td[0,i]
    rot = wrot[:,i]
    
    Y,xmean,Evi,Pm = getSigPred(X,w_mean,rot,dt)
    Xpred[i,:]= quat2euler(xmean)

#  Update Step   
    acct = np.reshape(acc[:,i],[3,1])   
    Z,zacc,nu= getSigUpd(Y,xmean,w_mean,acct,n)   
    Zmean[:,i] = np.reshape(zacc,[3,])
    
    K,P,x = updateX(Z,zacc,nu,Evi,Pm,R)
    Xquats[i,:] = x
    Xupd[i,:]= quat2euler(x)
#    print(P)
    
#------------------------------------------------------------------------------#


# Plotting 
plt.figure()
plt.subplot(311)
plt.title('Orientation')
plt.plot(tsv.transpose(),A_eul[:,0], label = 'Vicon')
#plt.plot(ts[0,:N].transpose(),eul[:,0], label = 'Simple')
#plt.plot(ts[0,:N].transpose(),Xpred[:,0], label = 'Pred')
plt.plot(ts[0,:N].transpose(),Xupd[:,0],label = 'UKF')
plt.legend()
plt.ylabel('Roll')

plt.subplot(312)
plt.plot(tsv.transpose(),A_eul[:,1], label = 'Vicon')
#plt.plot(ts[0,:N].transpose(),eul[:,1], label = 'Simple')
#plt.plot(ts[0,:N].transpose(),Xpred[:,1], label = 'Pred')
plt.plot(ts[0,:N].transpose(),Xupd[:,1],label = 'UKF')
plt.legend()
plt.ylabel('Pitch')
plt.subplot(313)
plt.plot(tsv.transpose(),A_eul[:,2], label = 'Vicon')
#plt.plot(ts[0,:N].transpose(),eul[:,2], label = 'Simple')
#plt.plot(ts[0,:N].transpose(),Xpred[:,2], label = 'Pred')
plt.plot(ts[0,:N].transpose(),Xupd[:,2],label = 'UKF')
plt.legend()
plt.ylabel('Yaw')
plt.xlabel('Time')
nameO = 'O' + str(filenum) + '.png'
plt.savefig(nameO)

#

# Acceleration Plots

a = np.reshape(acc[0,:N],[N,1])
b = np.reshape(acc[1,:N],[N,1])
c = np.reshape(acc[2,:N],[N,1])

plt.figure()
plt.subplot(311)
plt.title('Acceleration')
plt.plot(ts[0,:N].transpose(),a, label = 'IMU')
plt.plot(ts[0,:N].transpose(),Zmean[0,:],label = 'UKF')
plt.ylabel('Ax')
plt.legend()
plt.subplot(312)
plt.plot(ts[0,:N].transpose(),b,label = 'IMU')
plt.plot(ts[0,:N].transpose(),Zmean[1,:],label = 'UKF')
plt.ylabel('Ay')
plt.legend()
plt.subplot(313)
plt.plot(ts[0,:N].transpose(),c,label = 'IMU')
plt.plot(ts[0,:N].transpose(),Zmean[2,:],label = 'UKF')
plt.ylabel('Az')
plt.xlabel('Time')
plt.legend()
nameA = 'A' + str(filenum) + '.png'
plt.savefig(nameA)

