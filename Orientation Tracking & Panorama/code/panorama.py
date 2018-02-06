import matplotlib.pyplot as plt
import numpy as np
from quatstuff import multq,conjq, invq, logq, avgq, rotq, expq, rotqpix
from transforms3d.quaternions import quat2mat
#from load_data import imud, vicd, camd
from UKF import Xquats, ts, imud, vicd, camd, filenum




def pixel2sphere(ind):
    
    Sphere = np.zeros((240*320,2))   
    
    theta = (60/319)*ind[1,:]-30
    phi = (45/239)*ind[0,:]+67.5   

    Sphere[:,0] = theta*np.pi/180.
    Sphere[:,1] = phi*np.pi/180.
    return Sphere

def sphere2cart(Sphere):
    
    cart = np.zeros([3,240*320])
    r = 1

    
    x = r*np.sin(Sphere[:,1])*np.cos(Sphere[:,0])
    y = r*np.sin(Sphere[:,1])*np.sin(Sphere[:,0])
    z = r*np.cos(Sphere[:,1])    
    
    cart[0,:] = x
    cart[1,:] = y
    cart[2,:] = z
    
    return cart

def cart2sphere(cart):
    
    sphere = np.zeros((240*320,2))

    temp = np.square(cart[0:2,:])
    temp = np.sqrt(np.sum(temp,axis=0))

    phi = np.arctan2(temp,cart[2,:])


    theta = np.arctan2(cart[1,:],cart[0,:]) 
    
    sphere[:,0] = theta
    sphere[:,1] = phi
    
    return sphere

def cart2world(cart,R):
    
    world = np.dot(R,cart)
    
    return world


def sphere2pixel(sphere,Mp,Np):
    theta = sphere[:,0]
    z = np.cos(sphere[:,1])
    z_nu = np.round((-z+1)*Mp/2)
    theta_nu = np.round((theta+np.pi)*Np/(2*np.pi))
    
    return z_nu,theta_nu


rots = vicd['rots']
ts_v =vicd['ts']
cam = camd['cam']
ts_c =camd['ts']
Mp = 961
Np = 1921
panorama_ukf = np.zeros([Mp, Np, 3])
panorama_vic= np.zeros([Mp, Np, 3])

size = 76800
grid = np.indices((240,320))
ind = np.zeros([2,size])
ind[0,:] = grid[0,:,:].flatten()
ind[1,:] = grid[1,:,:].flatten()


for i in range(cam.shape[3]):
    
    imnow = cam[:,:,:,i]
    
    tind_ukf = np.argmin(np.abs(ts[0,:]-ts_c[0,i]))
    tind_vic = np.argmin(np.abs(ts_v[0,:]-ts_c[0,i]))
    
    S = pixel2sphere(ind)
    C = sphere2cart(S)
    W_ukf = cart2world(C,quat2mat(Xquats[tind_ukf.astype(int),:]))
    W_vic = cart2world(C,rots[:,:,int(tind_vic)])
    Wsp_ukf = cart2sphere(W_ukf)
    Wsp_vic = cart2sphere(W_vic)
    z_ukf,th_ukf = sphere2pixel(Wsp_ukf,Mp-1,Np-1)
    z_vic,th_vic = sphere2pixel(Wsp_vic,Mp-1,Np-1)
    
    panorama_ukf[z_ukf.astype(int),th_ukf.astype(int),:] = imnow[ind[0,:].astype(int),ind[1,:].astype(int),:]
    panorama_vic[z_vic.astype(int),th_vic.astype(int),:] = imnow[ind[0,:].astype(int),ind[1,:].astype(int),:]

    print(i)
panorama_ukf = panorama_ukf.astype(np.uint8)
panorama_vic = panorama_vic.astype(np.uint8)
plt.figure()
plt.imshow(panorama_ukf)
nameP = 'P' + str(filenum) + '.png'
plt.savefig(nameP)

plt.figure()
plt.imshow(panorama_vic)
nameV = 'V' + str(filenum) + '.png'
plt.savefig(nameV)