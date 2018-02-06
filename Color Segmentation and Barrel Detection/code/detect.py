from __future__ import division

import cv2 
import os
import numpy as np
from skimage import img_as_ubyte

rootdir = os.getcwd()
valdir = os.path.join(rootdir, 'Validation','Mask')
traindir = os.path.join(rootdir, 'Train','Mask')
trainsetdir = os.path.join(rootdir, 'trainset')
testsetdir = os.path.join(rootdir, 'testset_converted') 
testdir = os.path.join(rootdir, 'Test','Mask')

ratio_tr = np.load(os.path.join('Train','Ratio.npy'))

# Function to find contours that are nearby given a threshold. From code posted to stackoverflow forum. See: https://dsp.stackexchange.com/questions/2564/opencv-c-connect-nearby-contours-based-on-distance-between-them
def find_if_close(cnt1,cnt2):
    row1,row2 = cnt1.shape[0],cnt2.shape[0]
    for i in xrange(row1):
        for j in xrange(row2):
            dist = np.linalg.norm(cnt1[i]-cnt2[j])
            if abs(dist) < 75 :
                return True
            elif i==row1-1 and j==row2-1:
                return False
            
            
kernel = np.ones((12,12), np.uint8)

print "Detecting Objects..."

## Validation Set

start = 1
end = 10
n = 1
X = []
OutDetectVal = []

print "Validation Set\n-------------------"

for filename1, filename2 in zip(os.listdir(valdir), os.listdir(trainsetdir)[40:]):

    if n < start:
        n +=1
        continue 
    
    print "Image: "+ filename2 
    path = os.path.join(valdir, filename1)
    mask = np.load(path)
    im = img_as_ubyte(mask)
    im = cv2.erode(im,kernel)
    im = cv2.dilate(im,kernel)

    (image, contours, hierarchy) = cv2.findContours(im, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    
    path = os.path.join(trainsetdir, filename2)
    real = cv2.imread(path)

    Box = []

# Method to join nearby contours. Adapted from code posted in stackoverflow forum. See: https://dsp.stackexchange.com/questions/2564/opencv-c-connect-nearby-contours-based-on-distance-between-them
    LENGTH = len(contours)
    status = np.zeros((LENGTH,1))

    for i,cnt1 in enumerate(contours):
        x = i    
        if i != LENGTH-1:
            for j,cnt2 in enumerate(contours[i+1:]):
                x = x+1
                dist = find_if_close(cnt1,cnt2)
                if dist == True:
                    val = min(status[i],status[x])
                    status[x] = status[i] = val
                else:
                    if status[x]==status[i]:
                        status[x] = i+1
    
    unified = []
    maximum = int(status.max())+1
    for i in xrange(maximum):
        P=im
        pos = np.where(status==i)[0]
        if pos.size != 0:
            cont = np.vstack(contours[i] for i in pos)
            rect = cv2.minAreaRect(cont)
            box = cv2.boxPoints(rect)
            bbox = box
            box = np.int0(box)
            
            
            ratio = np.max(rect[1]) /np.min(rect[1])
            barrelness = np.abs(ratio-ratio_tr)
            
            if (barrelness < 0.25):
                unified.append(box)
                X.append([np.min(rect[1]), np.max(rect[1])])
                
    OutDetectVal.append(unified)
    nimg = cv2.drawContours(real,unified,-1,(0,255,0),2)
    cv2.imwrite(os.path.join('DetectedImages','Validation', filename2),nimg) 
## If you want to see the bounded boxes on the images: 
#    cv2.imshow('image',nimg)
#    cv2.waitKey(0)
  


    
    if n == end:
        print "Finished Validation Set Detection\n"
        break
   
    n += 1
    
np.save(os.path.join(rootdir, 'Validation','Box'),OutDetectVal)   
np.save(os.path.join(rootdir, 'Validation','X'),X)


# Test Set
start = 1
end = len(os.listdir(testsetdir))
n= 1
X = []
OutDetectTest = []

print "Test Set\n------------"
for filename1, filename2 in zip(os.listdir(testdir), os.listdir(testsetdir)):

    if n < start:
        n +=1
        continue 
    
    print "Image: "+ filename2
    path = os.path.join(testdir, filename1)
    mask = np.load(path)
    im = img_as_ubyte(mask)
    im = cv2.erode(im,kernel)
    im = cv2.dilate(im,kernel)
    

    (image, contours, hierarchy) = cv2.findContours(im, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    
    path = os.path.join(testsetdir, filename2)
    real = cv2.imread(path)
    Box = []
    
# Method to join nearby contours. Adapted from code posted in stackoverflow forum. See: https://dsp.stackexchange.com/questions/2564/opencv-c-connect-nearby-contours-based-on-distance-between-them
    
    LENGTH = len(contours)
    status = np.zeros((LENGTH,1))
    
    for i,cnt1 in enumerate(contours):
        x = i    
        if i != LENGTH-1:
            for j,cnt2 in enumerate(contours[i+1:]):
                x = x+1
                dist = find_if_close(cnt1,cnt2)
                if dist == True:
                    val = min(status[i],status[x])
                    status[x] = status[i] = val
                else:
                    if status[x]==status[i]:
                        status[x] = i+1
    
    unified = []
    maximum = int(status.max())+1
    for i in xrange(maximum):
        P=im
        pos = np.where(status==i)[0]
        if pos.size != 0:
            cont = np.vstack(contours[i] for i in pos)
            rect = cv2.minAreaRect(cont)
            box = cv2.boxPoints(rect)
            box = np.int0(box)
                   
            ratio = np.max(rect[1]) /np.min(rect[1])
            barrelness = np.abs(ratio-ratio_tr)            
            if (barrelness < 0.25):
                unified.append(box)
                X.append([np.min(rect[1]), np.max(rect[1])])
                

    OutDetectTest.append(unified)
    nimg = cv2.drawContours(real,unified,-1,(0,255,0),2)
    cv2.imwrite(os.path.join('DetectedImages','Test', filename2),nimg)    
## If you want to see the bounded boxes on the images: 
#    cv2.imshow('image',nimg)
#    cv2.waitKey(0)
    
    
    if n == end:
        break   
    
    n += 1
    
print "Finished Test Set Detection\n"
np.save(os.path.join(rootdir, 'Test','Box'),OutDetectTest)
np.save(os.path.join(rootdir, 'Test','X'),X)




