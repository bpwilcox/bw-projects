from __future__ import division

from skimage import io
import os
import numpy as np


rootdir = os.getcwd()
traindir = os.path.join(rootdir, 'trainset')
testsetdir = os.path.join(rootdir, 'testset_converted') 


mean_red = np.load(os.path.join('BarrelRed', 'mean.npy'))
var_red = np.load(os.path.join('BarrelRed', 'variance.npy'))
mean_nbred = np.load(os.path.join('NotBarrelRed', 'mean.npy'))
var_nbred = np.load(os.path.join('NotBarrelRed', 'variance.npy'))
mean_yellow = np.load(os.path.join('Yellow', 'mean.npy'))
var_yellow = np.load(os.path.join('Yellow', 'variance.npy'))
mean_brown = np.load(os.path.join('Brown', 'mean.npy'))
var_brown = np.load(os.path.join('Brown', 'variance.npy'))

prior_red = np.load(os.path.join('BarrelRed', 'prior.npy'))
prior_nbred = np.load(os.path.join('NotBarrelRed', 'prior.npy'))
prior_yellow = np.load(os.path.join('Yellow', 'prior.npy'))
prior_brown = np.load(os.path.join('Brown', 'prior.npy'))


det_red = np.linalg.det(var_red)
det_nbred = np.linalg.det(var_nbred)
det_yellow = np.linalg.det(var_yellow)
det_brown = np.linalg.det(var_brown)

inv_red = np.linalg.inv(var_red)
inv_nbred = np.linalg.inv(var_nbred)
inv_yellow = np.linalg.inv(var_yellow)
inv_brown = np.linalg.inv(var_brown)


## Validation Set

print "Classifying Validation Set...\n"

start = 41
end = 50
i = 1

for filename in os.listdir(traindir):

    if i < start:
        i +=1
        continue 
    
    print "Image: "+ filename     
    path = os.path.join(traindir, filename)
    img = io.imread(path)
    K = np.empty(np.shape(img[:,:,0]))

    
    for (j,y) in enumerate(img):
        for (k,x) in enumerate(img[j,:,:]):
            X = np.reshape(x,[3,1])                
            Red = -0.5*np.dot(np.dot((X-np.reshape(mean_red,[3,1])).transpose(),inv_red),X-np.reshape(mean_red,[3,1]))-0.5*np.log(np.power(2*np.pi,3)*det_red)+np.log(prior_red)
            NotBRed = -0.5*np.dot(np.dot((X-np.reshape(mean_nbred,[3,1])).transpose(),inv_nbred),X-np.reshape(mean_nbred,[3,1]))-0.5*np.log(np.power(2*np.pi,3)*det_nbred)+np.log(prior_nbred)
            Yellow = -0.5*np.dot(np.dot((X-np.reshape(mean_yellow,[3,1])).transpose(),inv_yellow),X-np.reshape(mean_yellow,[3,1]))-0.5*np.log(np.power(2*np.pi,3)*det_yellow)+np.log(prior_yellow)
            Brown = -0.5*np.dot(np.dot((X-np.reshape(mean_brown,[3,1])).transpose(),inv_brown),X-np.reshape(mean_brown,[3,1]))-0.5*np.log(np.power(2*np.pi,3)*det_brown)+np.log(prior_brown)
            
            
            K[j][k] = np.argmax([Red, NotBRed, Yellow, Brown])
            
    Mask = K == 0
    np.save(os.path.join('Validation','Mask',str(i)), Mask)
    
    
    if i == end:
        break
   
    i += 1
    
print "Done with Validation Set\n"


## Test Set

print "Classifying Test Set..."
start = 1
end = len(os.listdir(testsetdir))
i = 1

for filename in os.listdir(testsetdir):

    if i < start:
        i +=1
        continue 
    
    print "Image: "+ filename    
    
    path = os.path.join(testsetdir, filename)
    img = io.imread(path)
    K = np.empty(np.shape(img[:,:,0]))

    for (j,y) in enumerate(img):
        for (k,x) in enumerate(img[j,:,:]):
            X = np.reshape(x,[3,1])                
            Red = -0.5*np.dot(np.dot((X-np.reshape(mean_red,[3,1])).transpose(),inv_red),X-np.reshape(mean_red,[3,1]))-0.5*np.log(np.power(2*np.pi,3)*det_red)+np.log(prior_red)
            NotBRed = -0.5*np.dot(np.dot((X-np.reshape(mean_nbred,[3,1])).transpose(),inv_nbred),X-np.reshape(mean_nbred,[3,1]))-0.5*np.log(np.power(2*np.pi,3)*det_nbred)+np.log(prior_nbred)
            Yellow = -0.5*np.dot(np.dot((X-np.reshape(mean_yellow,[3,1])).transpose(),inv_yellow),X-np.reshape(mean_yellow,[3,1]))-0.5*np.log(np.power(2*np.pi,3)*det_yellow)+np.log(prior_yellow)
            Brown = -0.5*np.dot(np.dot((X-np.reshape(mean_brown,[3,1])).transpose(),inv_brown),X-np.reshape(mean_brown,[3,1]))-0.5*np.log(np.power(2*np.pi,3)*det_brown)+np.log(prior_brown)
            
            
            K[j][k] = np.argmax([Red, NotBRed, Yellow, Brown])
            
    Mask = K == 0
    np.save(os.path.join('Test','Mask',str(i)), Mask)
    

    
    if i == end:
        print "Finished classifying"
        break
   
    i += 1
    
print "Done with Test Set\n"


## Training Set --NOTE: Obtaining classification masks in order to get bounding box width & height for distance regression

print "Classifying Training Set..."
start = 1
end = 40
i = 1

for filename in os.listdir(traindir):

    if i < start:
        i +=1
        continue 
    print "Image: "+ filename 
    
    path = os.path.join(traindir, filename)
    img = io.imread(path)
    K = np.empty(np.shape(img[:,:,0]))

    for (j,y) in enumerate(img):
        for (k,x) in enumerate(img[j,:,:]):
            X = np.reshape(x,[3,1])                
            Red = -0.5*np.dot(np.dot((X-np.reshape(mean_red,[3,1])).transpose(),inv_red),X-np.reshape(mean_red,[3,1]))-0.5*np.log(np.power(2*np.pi,3)*det_red)+np.log(prior_red)
            NotBRed = -0.5*np.dot(np.dot((X-np.reshape(mean_nbred,[3,1])).transpose(),inv_nbred),X-np.reshape(mean_nbred,[3,1]))-0.5*np.log(np.power(2*np.pi,3)*det_nbred)+np.log(prior_nbred)
            Yellow = -0.5*np.dot(np.dot((X-np.reshape(mean_yellow,[3,1])).transpose(),inv_yellow),X-np.reshape(mean_yellow,[3,1]))-0.5*np.log(np.power(2*np.pi,3)*det_yellow)+np.log(prior_yellow)
            Brown = -0.5*np.dot(np.dot((X-np.reshape(mean_brown,[3,1])).transpose(),inv_brown),X-np.reshape(mean_brown,[3,1]))-0.5*np.log(np.power(2*np.pi,3)*det_brown)+np.log(prior_brown)
            
            
            K[j][k] = np.argmax([Red, NotBRed, Yellow, Brown])
            
    Mask = K == 0
    np.save(os.path.join('Train','Mask',str(i)), Mask)

    
    if i == end:
        break
   
    i += 1

print "Done with Training Set\n"

