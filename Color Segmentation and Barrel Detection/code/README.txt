Brian Wilcox 

ECE Project 1: Red Barrel Detection Algorithm

Libraries used:
cv2
numpy
matplotlib
os
skimage

Scripts (with short descriptions):
roipoly.py - used for drawing bounded regions
label.py - manual color class labelling of training images 
traingauss.py - trains gaussian model parameters from labeled class pixels  
classify.py - classifies validation and test set pixels into color classes & extracts mask for barrel red)
trainlinreg.py - trains linear regression parameter on distance to barrel via features (width, height) learned from detection of red barrels on training set 
linreg.py - linear regression for distance to barrel on validation and test sets
GetResults.py - (optionally) runs above scripts and outputs validation and test results. 

Note 1: The scripts save all relevant data into the directory (therefore all results are saved to file, typically as '*.npy' file)
Note 2: classify.py takes a long time to run (~20-40 min) since no optimization was done. 

How to Run:
-Run 'GetResult.py' 
-You may run the above mentioned scripts (if desired) by uncommenting their respective imports in 'GetResults.py'

Images of detected barrels are found in /DetectedImages

