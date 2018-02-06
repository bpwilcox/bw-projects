""" 
This script (optionally) runs the barrel detection algorithm and outputs the validation and Test results
Uncomment below imported scripts to run various parts of algorithm. Results of those scripts are already saved in the directory

"""

""" 1. Manual labeling. -- Labeled class data (e.g. /Mask and /ColorSeg) saved in folder for each color class """
#import label.py

""" 2. Training of Gaussian parameters -- Parameters (mean and variance) saved in color class folder"""
#import traingauss

"""3. Pixel color classification -- Red pixel classification mask data saved to /Validation/Mask and /Test/Mask and /Train/Mask"""
#import classify.py

""" 4. Training of Linear regressor   -- Detected Widths/Heights of barrels, known distances, and trained linear regression parameter saved in /Train"""
#import trainlinreg

""" 5. Detection of Bounding Boxes for red barrels -- Detected Barrel Bounding Boxes and features Width/Heights of detected barrels saved in /Validation and /Test. Detected Barrel Images also saved in /DetectedImages"""
#import detect

""" 6. Linear Regression for Distances of red barrels -- Distance to detected Barrel computed and saved to /Validation and /Test """
#import linreg



import os
import numpy as np



rootdir = os.getcwd()
valdir = os.path.join(rootdir, 'Validation','Mask')
traindir = os.path.join(rootdir, 'Train','Mask')
trainsetdir = os.path.join(rootdir, 'trainset')
testsetdir = os.path.join(rootdir, 'testset_converted') 
testdir = os.path.join(rootdir, 'Test','Mask')

## Validation Results
DetectedBarrels_Val = np.load(os.path.join(rootdir, 'Validation','Box.npy')).reshape(10,4,2)
Distances_Val = np.load(os.path.join(rootdir, 'Validation','Y.npy'))
 
n = 1
start = 1
end = 10 
print "Validation Results\n------------------------\n"
for index, filename in enumerate(os.listdir(trainsetdir)[40:]):

    if n < start:
        n +=1
        continue 

    print "ImageNo = [" + filename + "] , Vertex\_1 = " + str(DetectedBarrels_Val[index][0]) + " , Vertex\_2 = " + str(DetectedBarrels_Val[index][1]) + " ,\n                      Vertex\_3 = "+ str(DetectedBarrels_Val[index][2]) + " , Vertex\_4 = "+ str(DetectedBarrels_Val[index][3]) + " , Distance = " + str(Distances_Val[index]) + "\n"


    if n == end:
#        print "Finished Validation Results"
        break
   
    n += 1

## Test Results
DetectedBarrels_Test = np.load(os.path.join(rootdir, 'Test','Box.npy')).tolist()
Distances_Test = np.load(os.path.join(rootdir, 'Test','Y.npy'))

n = 1
start = 1
end = 10 
k = 0
print "Test Results\n------------------------\n"
for index, filename in enumerate(os.listdir(testsetdir)):

    if n < start:
        n +=1
        continue 

    if not DetectedBarrels_Test[index]:
        print "ImageNo = [" + filename.split(".")[0] + "] , No Barrel Detected\n"
        k += 1
    else:
        print "ImageNo = [" + filename.split(".")[0] + "] , Vertex\_1 = " + str(DetectedBarrels_Test[index][0][0]) + " , Vertex\_2 = " + str(DetectedBarrels_Test[index][0][1]) + " ,\n                  Vertex\_3 = "+ str(DetectedBarrels_Test[index][0][2]) + " , Vertex\_4 = "+ str(DetectedBarrels_Test[index][0][3]) + " , Distance = " + str(Distances_Test[index-k]) + "\n"


    if n == end:
#        print "Finished Validation Results"
        break
   
    n += 1
