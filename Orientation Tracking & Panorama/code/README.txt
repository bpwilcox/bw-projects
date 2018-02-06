Brian Wilcox 

ECE Project 2: Orientation Tracking 

Libraries used:
numpy
matplotlib
transforms3d

Scripts (with short descriptions):
load_data.py - loads in IMU, cam, and vicon data into python
quatstuff.py - creates quaternion functions
bias.py - scales and unbiases imu data 
UKF.py - performs UKF filter for orientation roll, pitch, and yaw
panorama.py - generates panorama from orientation and camera images

*There is a version of each of the files above appended with '_test' which are the same except they don't include vicon data

How to Run:

For test data:
-In 'load_data_test.py', change variable 'filenum' to the number of file for imu, cam, and vicon data
-Run 'panorama_test.py'

For train data with camera data available:
-In 'load_data.py', change variable 'filenum' to the number of file for imu and cam data
-Run 'panorama.py'

For training data without camera data:
-In 'load_data.py', change variable 'filenum' to the number of file for imu and vicon data
-comment out line 31 (reading in cam data)
-uncomment line 32 (set cam data to empty)
-Run 'UKF.py'


Note: to direct to the appropriate directory of train/test files, please put (with matching names & spelling):
-folder BrianWilcox_P2/train1/trainset/...
-folder BrianWilcox_P2/testset/...
as subdirectories under the parent (assuming current conventions for naming cam, imu, and vicon subdirectories hold)

Images are saved automatically in scripts, but you may also find all images (orientation, acceleration, panorama) in the 'Images' folder
