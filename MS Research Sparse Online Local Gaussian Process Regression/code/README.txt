The code in these files performs Sparse Online Local Gaussian Process Regression (GPR) for some simple geometric shapes.

For running base version in Python:
-Install GPy
-Run SOLGPR_noROS.py 

For running ROS simulation of SOLGPR:
-Install GPy
-Install ROS (Kinetic version) and set up environment on Linux
-Put 'twolink' fold in ~/catkin_ws/src
-build catkin_ws
-in a terminal, type 'roscore'
-in another terminal, type: 'roslaunch twolink trySOLGPR.launch' 

*The script that runs the controller node for the the ROS simulation is called LGPcontrol.py and is found in /twolink/scripts/LGPcontrol.py