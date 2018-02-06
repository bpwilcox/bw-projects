Brian Wilcox 

ECE Project 3: SLAM 

Libraries used:
numpy
matplotlib
transforms3d


Scripts (with short descriptions):
load_data.py - pre-made script contains functions for reading in data and calibration parameters
p3_utils.py - pre-made script contains functions for map correlation and bresenham algorithm
SLAM.py - performs SLAM and texture mapping 

Folder structure & names*:
-----------------
Train Data:
'trainset
.../cam/'
.../joint/'
.../lidar/'

Test Data:
'testset
.../cam/'
.../joint/'
.../lidar/'

*In order to read in data, the folder names and structure should follow the above format

How to Run:
- in 'SLAM.py' change variable for dataset (line 565) to whichever set {1,2,3,test} you want to run for SLAM.
- run 'SLAM.py'
- Check /figures folder for images of the maps over time for each dataset as well as texture maps