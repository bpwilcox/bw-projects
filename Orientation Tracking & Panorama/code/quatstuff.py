"Functions for quaternion manipulations "

import numpy as np
from transforms3d.euler import euler2mat, mat2euler
from transforms3d.quaternions import axangle2quat, quat2axangle
# conjugate
def conjq (q):
    q = np.reshape(q,[4,])
    qc = np.hstack((q[0],-q[1:]))   
    return qc
# add

# multiply
def multq (q,p):  
    qms = q[0]*p[0]-np.dot(q[1:],p[1:])
    qmv = q[0]*p[1:]+p[0]*q[1:]+np.cross(q[1:],p[1:])
    qm = np.hstack((qms,qmv))
    
    return qm
# log
def logq(q):
    
    ql1 = np.log(np.linalg.norm(q))
    if np.linalg.norm(q[1:]) == 0:
        ql = np.hstack((ql1,np.array([0,0,0])))
    else:
        ql2 = np.arccos(q[0]/np.linalg.norm(q))*q[1:]/np.linalg.norm(q[1:])
        ql = np.hstack((ql1,ql2))
    return ql
# exp
def expq(q):
    
    if np.linalg.norm(q)==0:
        qe = np.array([1,0,0,0])
    else:
        qe1 = np.exp(q[0])*np.cos(np.linalg.norm(q[1:]))
        qe2 = np.exp(q[0])*q[1:]*np.sin(np.linalg.norm(q[1:]))/np.linalg.norm(q[1:])
        qe = np.hstack((qe1,qe2))
    return qe
        
# rotate vector
def rotq(q,x):
    
    qr = multq(multq(q,np.hstack((0,x))),invq(q))
    return qr

# rotate pixel cartesian vectors
def rotqpix(q,C):
    
    P = np.zeros([240,320,4])
    P[:,:,1:] = C
    P = np.reshape(P,[240*320,4])
    qr = multqpix(multqpix(np.reshape(q,[1,4]),P),np.reshape(invq(q),[1,4]))
    qr = qr[:,1:]
    return qr

# multiply pixel cartesian vectors
def multqpix (q,P):  
    
    N = np.shape(P)[0]
    M = np.shape(q)[0]
    q = np.reshape(q,[M,4])
    qms = np.reshape(q[:,0]*P[:,0],[np.shape(q[:,0]*P[:,0])[0],1]) - np.reshape(np.dot(P[:,1:],q[:,1:].transpose()),[np.max([N,M]),1])
    qmv = np.reshape(q[:,0],[np.shape(q[:,0])[0],1])*P[:,1:] + np.reshape(P[:,0],[N,1])*q[:,1:] + np.cross(q[:,1:],P[:,1:])
    qm = np.hstack((qms,qmv))
    
    return qm

# inverse
def invq(q):
    
    qi = conjq(q)/(np.linalg.norm(q)**2)
#    qi = conjq(q)/multq(q,conjq(q))[0]
    return qi

# average
def avgq(Q,A,qa):
    e = 0.0001
    T = 1000
    
    for t in range(1,T):
        ev = np.array([0,0,0])
#        Evi = np.array([])
        Evi = np.empty((3,),float)
        
        for q,a in zip(Q,A):
            qerr = multq(invq(qa),q)
            evi = 2*logq(qerr)
            if np.linalg.norm(evi[1:]) == 0:
                evi = np.array([0,0,0])
            else:                  
                evi = (-np.pi+np.mod(np.linalg.norm(evi[1:])+np.pi,2*np.pi))*evi[1:]/np.linalg.norm(evi[1:])
            ev = ev + a*evi            
#            Evi = np.append(Evi,evi)
            Evi = np.vstack((Evi,evi))
#        Evi = np.reshape(Evi,[3,7])
        Evi = Evi.transpose()
        Evi = Evi[:,1:]
        qa = multq(qa,expq(np.hstack((0,ev/2))))
        if np.linalg.norm(ev) < e:
#            print(t)
            break
    
    return qa,Evi
