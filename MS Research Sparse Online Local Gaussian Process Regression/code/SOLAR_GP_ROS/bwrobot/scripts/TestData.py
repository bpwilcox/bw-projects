import numpy as np



class TestTrajectory():
    
    def __init__(self,trajectory, robot):
        
        self.trajectory = trajectory
        self.robot = robot
        self.xtest = trajectory.xtest 
        self.ytest = robot.inkin(self.xtest)
   
    
    
    