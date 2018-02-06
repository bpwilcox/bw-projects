from transforms3d.euler import euler2mat, mat2euler, quat2euler
import numpy as np
import matplotlib.pyplot as plt
from quatstuff import multq,conjq, invq, logq, avgq, rotq, expq
from load_data import imud, vicd, camd, filenum

data = imud['vals']
ts =imud['ts']

acc = data[0:3][:]
acc[0,:] = -acc[0,:]
acc[1,:] = -acc[1,:]  
w = data[3:][:]
w = np.vstack((w[1,:],w[2,:],w[0,:]))

sen_a = 300 
sen_w = 3.33 * 180/np.pi

sf_a = 3300/(1023*sen_a)
sf_w = 3300/(1023*sen_w)

bias_a = np.mean(acc[:,:250],1) 
bias_w = np.mean(w[:,:250],1)

acc = (acc-np.reshape(bias_a,[3,1]))*sf_a + np.reshape(np.array([0,0,1]),[3,1])
wrot = (w-np.reshape(bias_w,[3,1]))*sf_w    

q = np.array([1,0,0,0])
qt = q
td = np.diff(ts)
eul = q[1:]
for t in range(0,np.shape(wrot)[1]-1):
    
    qt = multq(qt,expq(np.hstack((0,wrot[:,t]/2*td[0,t])))) 
    qt = qt/np.linalg.norm(qt)
    q = np.vstack((q,qt))
    eq = np.reshape(quat2euler(qt),[3,])
    eul = np.vstack((eul,eq))
    

# Vicon

rots = vicd['rots']
tsv =vicd['ts']

A_eul = np.array([])

for i in range(np.shape(rots)[2]):

    A_eul = np.append(A_eul,mat2euler(rots[:,:,i],'sxyz'))

A_eul = A_eul.reshape([np.shape(rots)[2],3])



 
 