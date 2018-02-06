import cv2 
from skimage import data, util
from skimage.measure import label, regionprops
from skimage import io
import os
import numpy as np
import matplotlib.pyplot as plt
import pylab as pl
from roipoly import roipoly

rootdir = os.getcwd()
maskdir = os.path.join(rootdir, 'BarrelRed','mask')
i = 1
#for filename in os.listdir(maskdir):
#    path = os.path.join('BarrelRed','mask', filename)
#    mask = np.load(path)
##    plt.imshow(mask, cmap = "Greys")
##    colorseg = img[mask,:]
#    plt.imshow(mask)
#
#    plt.show()
#    
#    if i == 3:
#        print "Finished confirming"
#        break
#    
#    i += 1
    
    
maskdir = os.path.join(rootdir, 'Validation','Mask')
#maskdir = os.path.join(rootdir, 'testset')

for filename in os.listdir(maskdir):
    path = os.path.join('Validation','Mask',filename)
    mask = np.load(path)
    plt.imshow(mask, cmap = "Greys")
    plt.show()
