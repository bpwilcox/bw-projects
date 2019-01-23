import numpy as np



class TestTrajectory():
    
    def __init__(self,trajectory, robot):
        
        self.trajectory = trajectory
        self.robot = robot
        if np.size(trajectory.xtest,1) < robot.dim:
            self.xtest = np.column_stack((trajectory.xtest, np.zeros(np.size(trajectory.xtest,0))))
        else:     
            self.xtest = trajectory.xtest

        #self.ytest = robot.inkin(self.xtest)
   
    
    
    