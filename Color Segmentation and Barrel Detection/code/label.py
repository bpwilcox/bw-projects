# -*- coding: utf-8 -*-
"""https://stackoverflow.com/users/login?ssrc=head&returnurl=https%3a%2f%2fstackoverflow.com%2fquestions%2f23585126%2fhow-do-i-get-interactive-plots-again-in-spyder-ipython-matplotlib
Created on Tue Oct 24 13:45:25 2017

@author: BPWilcox
"""

from skimage import io
import os
import numpy as np
import matplotlib.pyplot as plt
from roipoly import roipoly

rootdir = os.getcwd()
traindir = os.path.join(rootdir, 'trainset')
i = 1

start  = 1
end = 40

print "Begin Labeling...\n"
for filename in os.listdir(traindir):

    if i < start:
        i +=1
        continue 
    
    path = os.path.join(traindir, filename)
    img = io.imread(path)
    nimg= img[:,:,0] 
    next = 0
    savemask = os.path.join('BarrelRed', 'mask', str(i))
    savecolorseg = os.path.join('BarrelRed', 'colorseg', str(i))
#    saveit = os.path.join('BarrelRed', 'mask', str(i))

    

    while (next==0):
    
        plt.imshow(img)
    
    
    #plt.imshow(img)
        MyROI = roipoly(roicolor = 'r')
        plt.imshow(img)
        MyROI.displayROI()
        plt.show()
        print 'Image '+ str(i) +':\n'
        userin = input("0 - Next\n1 - Second Barrel\n2 - Red (not Barrel)\n3 - Yellow\n4 - Brown\n5 - Redo\n6 - Quit\n")
        

        if userin == 5:
            print "Redo"
            print savemask
            continue          
        elif userin == 6:
            break


        
        mask = MyROI.getMask(nimg)
        colorseg = img[mask,:]
#        np.save(savemask, mask)
        np.save(savecolorseg, colorseg)
    

        if userin == 0:
            print "Next"
            next = 1
        elif userin == 1:
            print "Second Barrel"
            savemask = os.path.join('BarrelRed', 'mask', str(i)+'_2')
            savecolorseg = os.path.join('BarrelRed', 'colorseg', str(i)+'_2')
        elif userin == 2:
            print "Red (not Barrel)"
            savemask = os.path.join('NotBarrelRed', 'mask',str(i))
            savecolorseg = os.path.join('NotBarrelRed', 'colorseg', str(i))
        elif userin == 3:
            print "Yellow"
            savemask = os.path.join('Yellow', 'mask',str(i))
            savecolorseg = os.path.join('Yellow', 'colorseg', str(i))
        elif userin == 4:
            print "Brown"
            savemask = os.path.join('Brown', 'mask',str(i))
            savecolorseg = os.path.join('Brown', 'colorseg', str(i))



    if userin == 6:
        break        
    
    if i == end:    
        break
    
    i += 1
    
 print "Finished labeling\n"