import matplotlib.pyplot as pl
from mpl_toolkits.mplot3d.axes3d import Axes3D
import numpy as np
import Trajectory
from TestData import TestTrajectory
import RobotModels
import SOLAR_GP


#%matplotlib inline
#%matplotlib qt5

pl.close("all")

"Create Planar Robot Model"
Origin = RobotModels.Link(0,0,0)
Link = RobotModels.Link(0,0.5,0)
LinkEnd = RobotModels.Link(0,0.5,0)
YStart = np.column_stack(np.deg2rad([-30,45,30])) # initial joint position
robot = RobotModels.SerialLink([Origin, Link, Link, LinkEnd], YStart) # Create Robot structure

"Create Planar Test Case"
n = 400 # number of points in trajetory
r =1# radius of trajectory
XStart  = robot.currentX # initial taskspace position
x0 = XStart[0][0]-r # trajectory x center 
y0 = XStart[0][1] # y trajectory y center 
"Create Test Trajectory"
TestCase = TestTrajectory(Trajectory.Circle2D(n,r,x0,y0,arclength = 2*np.pi), robot)
#Test = TestTrajectory(Trajectory.nPoly2D(n,4,r,x0,y0, arclength = -2*np.pi,flip =0), robot)
#Test = TestTrajectory(Trajectory.Rect2D(n, width = 1, height = 1), robot)
#Test = TestTrajectory(Trajectory.Star2D(n,5,r,x0,y0), robot)
#Test = TestTrajectory(Trajectory.Spiral2D(n,1,0.5,x0,y0,6*np.pi), robot) 



# =============================================================================
# "Create 3D Robot Model"
# l1 = 0
# l2 = 0.2
# l3 = 0.2
# 
# Origin = RobotModels.Link(0,0,0)
# Link1 = RobotModels.Link(0,l1,np.pi/2)
# Link2 = RobotModels.Link(0,l2,0)
# Link3 = RobotModels.Link(0,l3,0)
# Y = np.column_stack(np.deg2rad([45,-45,90]))
# #Y = np.column_stack(np.deg2rad([10,30,50]))
# 
# robot = RobotModels.SerialLink([Origin, Link1, Link2, Link3], Y)
# 
# 
# =============================================================================

# =============================================================================
# n = 200 # number of points in trajetory
# r =0.075 # radius of trajectory
# XStart  = robot.currentX # initial taskspace position
# x0 = XStart[0][0]-r # trajectory x center 
# y0 = XStart[0][1] # y trajectory y center
# TestCase = TestTrajectory(Trajectory.Circle2D(n,r,x0,y0,arclength = 2*np.pi), robot)
# =============================================================================

# =============================================================================
# "Create 3D Test Case"
# Points = [[0.2,0.2,0], [0.1,0.2,0], [0.1,-0.2,0], [0.2,-0.2,0]]
# TestCase = TestTrajectory(Trajectory.PointPath(500, Points), robot)
# 
# zline = np.linspace(robot.currentX[0,2], robot.currentX[0,2]-0.2, 500)
# xline = robot.currentX[0,0] + 0.05*np.sin(75*(robot.currentX[0,2] - zline))
# yline = robot.currentX[0,1] + 0.05* (1 - np.cos(75*(robot.currentX[0,2] - zline)))
# TestCase= Trajectory.customPath(np.column_stack((xline, yline, zline)))
# =============================================================================


"Run Test"
Test = SOLAR_GP.SOLAR_GP(robot, TestCase)
Test.runTest(njit = 100, num_inducing =30, elev = 45, azim = 245, save_plots = False, wgen = 0.9, encode_angles = True, drift = 1)