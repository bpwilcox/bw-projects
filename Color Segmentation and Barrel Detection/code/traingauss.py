from __future__ import division


import os
import numpy as np

## Color Classes: red barrel, red (not barrel), yellow, brown

print "Training Gaussian model parameters..."

rootdir = os.getcwd()
barrelreddir = os.path.join(rootdir, 'BarrelRed','colorseg')
notbarrelreddir = os.path.join(rootdir, 'NotBarrelRed','colorseg')
yellowdir = os.path.join(rootdir, 'Yellow','colorseg')
browndir = os.path.join(rootdir, 'Brown','colorseg')


D_Red = np.empty([0,3])
D_NotBRed = np.empty([0,3])
D_Yellow = np.empty([0,3])
D_Brown = np.empty([0,3])

for filename in os.listdir(barrelreddir):
    
    path = os.path.join('BarrelRed','colorseg', filename)
    seg = np.load(path)
    
    D_Red = np.vstack((D_Red,seg))
    
    
mean_red = np.sum(D_Red,axis=0)/len(D_Red)
var_red = np.dot(D_Red.transpose()-np.reshape(mean_red,[3,1]), (D_Red.transpose()-np.reshape(mean_red,[3,1])).transpose())/len(D_Red)
#np.save(os.path.join('BarrelRed', 'mean'),mean_red)
#np.save(os.path.join('BarrelRed', 'variance'), var_red)


for filename in os.listdir(notbarrelreddir):
    

    path = os.path.join('NotBarrelRed','colorseg', filename)
    seg = np.load(path)
    
    D_NotBRed = np.vstack((D_NotBRed,seg))
    
    
mean_nbred = np.sum(D_NotBRed,axis=0)/len(D_NotBRed)
var_nbred = np.dot(D_NotBRed.transpose()-np.reshape(mean_nbred,[3,1]), (D_NotBRed.transpose()-np.reshape(mean_nbred,[3,1])).transpose())/len(D_NotBRed)
#np.save(os.path.join('NotBarrelRed', 'mean'),mean_nbred)
#np.save(os.path.join('NotBarrelRed', 'variance'), var_nbred)


for filename in os.listdir(yellowdir):
    
    path = os.path.join('Yellow','colorseg', filename)
    seg = np.load(path)
    
    D_Yellow = np.vstack((D_Yellow,seg))
    
    
mean_yellow = np.sum(D_Yellow,axis=0)/len(D_Yellow)
var_yellow = np.dot(D_Yellow.transpose()-np.reshape(mean_yellow,[3,1]), (D_Yellow.transpose()-np.reshape(mean_yellow,[3,1])).transpose())/len(D_Yellow)
#np.save(os.path.join('Yellow', 'mean'),mean_yellow)
#np.save(os.path.join('Yellow', 'variance'), var_yellow)
# 
for filename in os.listdir(browndir):
   
    path = os.path.join('Brown','colorseg', filename)
    seg = np.load(path)
    
    D_Brown = np.vstack((D_Brown,seg))
    
    
mean_brown = np.sum(D_Brown,axis=0)/len(D_Brown)
var_brown = np.dot(D_Brown.transpose()-np.reshape(mean_brown,[3,1]), (D_Brown.transpose()-np.reshape(mean_brown,[3,1])).transpose())/len(D_Brown)
#np.save(os.path.join('Brown', 'mean'),mean_brown)
#np.save(os.path.join('Brown', 'variance'), var_brown)


prior_red = len(D_Red)/(len(D_Red)+len(D_NotBRed)+len(D_Yellow)+len(D_Brown))
prior_nbred = len(D_NotBRed)/(len(D_Red)+len(D_NotBRed)+len(D_Yellow)+len(D_Brown))
prior_yellow = len(D_Yellow)/(len(D_Red)+len(D_NotBRed)+len(D_Yellow)+len(D_Brown))
prior_brown = len(D_Brown)/(len(D_Red)+len(D_NotBRed)+len(D_Yellow)+len(D_Brown))

#np.save(os.path.join('BarrelRed', 'prior'),prior_red)
#np.save(os.path.join('NotBarrelRed', 'prior'),prior_nbred)
#np.save(os.path.join('Yellow', 'prior'),prior_yellow)
#np.save(os.path.join('Brown', 'prior'),prior_brown)

print "Parameters Trained\n"