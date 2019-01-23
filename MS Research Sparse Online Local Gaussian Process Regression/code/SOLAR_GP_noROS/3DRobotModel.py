import numpy as np
import RobotModels
import Trajectory
import matplotlib.pyplot as pl
from mpl_toolkits.mplot3d.axes3d import Axes3D

#ax = pl.axes(projection='3d')

# =============================================================================
# # Base frame
# L1 = RobotModels.Link(0,0,0)
# L2 = RobotModels.Link(0,0.5,0)
# #L3 = RobotModels.Link(0,0.2,0)
# 
# robot = RobotModels.SerialLink([L1,L2,L2,L2])
# 
# q = np.column_stack(np.deg2rad([0,60,90]))
# 
# T, R1 = robot.fkin(q)
# robot.fkin_joint(q)
# arm = robot.plotrobot(q)
# robot.set_Y(q)
# robot.plot3D(q)
# =============================================================================

l1 = 0
l2 = 0.2
l3 = 0.2

Origin = RobotModels.Link(0,0,0)
Link1 = RobotModels.Link(0,l1,np.pi/2)
Link2 = RobotModels.Link(0,l2,0)
Link3 = RobotModels.Link(0,l3,0)
bot = RobotModels.SerialLink([Origin, Link1, Link2, Link3])
Y = np.column_stack(np.deg2rad([10,30,50]))
X,R = bot.fkin(Y)
ax = bot.plot3D(Y, elev = 45, azim = 240)

Points = [[0.2,0.2,0], [0.1,0.2,0], [0.1,-0.2,0], [0.2,-0.2,0]]
Path = Trajectory.PointPath(50, Points)
TestPoints= Path.xtest
ax.plot3D(TestPoints[:,0], TestPoints[:,1], TestPoints[:,2], '-')

# Data for a three-dimensional line

zline = np.linspace(X[0,2], X[0,2]-0.2, 400)
xline = X[0,0] + 0.05*np.sin(75*(X[0,2] - zline))
yline = X[0,1] + 0.05* (1 - np.cos(75*(X[0,2] - zline)))
Path = Trajectory.customPath(np.column_stack((xline, yline, zline)))

TestPoints= Path.xtest

ax.plot3D(TestPoints[:,0], TestPoints[:,1], TestPoints[:,2], 'gray')

#ax.plot3D(xline, yline, zline, 'gray')

# =============================================================================
# # Data for three-dimensional scattered points
# zdata = 15 * np.random.random(100)
# xdata = np.sin(zdata) + 0.1 * np.random.randn(100)
# ydata = np.cos(zdata) + 0.1 * np.random.randn(100)
# ax.scatter3D(xdata, ydata, zdata, c=zdata, cmap='Greens');
# 
# =============================================================================

# =============================================================================
# fname = 'Figures/' + str(0) 
# pl.savefig(fname)
# =============================================================================
    