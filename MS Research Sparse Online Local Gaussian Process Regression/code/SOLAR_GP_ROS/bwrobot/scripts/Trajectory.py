import numpy as np


class Circle2D():
    
    def __init__(self,num_points, radius = 0.5, center_x = -0.25, center_y = 1, arclength = 2*np.pi, *args):
        
        self.num_points = num_points
        self.radius = radius
        self.center_x = center_x
        self.center_y = center_y
        self.arclength = arclength
        self.xtest = self._createXtest()
        
        
    def _createXtest(self):
    
        theta = np.linspace(0,self.arclength,self.num_points)
        Xc = self.radius*np.cos(theta) + self.center_x
        Yc = self.radius*np.sin(theta) + self.center_y
    
        X_test = np.column_stack((Xc,Yc))
        
        return X_test
    
class Spiral2D():
    
    def __init__(self,num_points, start_radius = 0.5, end_radius = 1.5, center_x = -0.25, center_y = 1, arclength = 2*np.pi, *args):
        
        self.num_points = num_points
        self.start_radius = start_radius
        self.end_radius = end_radius
        self.center_x = center_x
        self.center_y = center_y
        self.arclength = arclength
        self.xtest = self._createXtest()
        
        
    def _createXtest(self):
        self.radius = np.linspace(self.start_radius,self.end_radius,self.num_points)
        theta = np.linspace(0,self.arclength,self.num_points)
        Xc = np.multiply(self.radius,np.cos(theta)) + self.center_x
        Yc = np.multiply(self.radius,np.sin(theta)) + self.center_y
    
        X_test = np.column_stack((Xc,Yc))
        
        return X_test
        
    
class Rect2D():
    
    def __init__(self,num_points, width = 0.5, height = 0.5, center_x = -0.25, center_y = 1, radius = 0.5, *args):
        
        self.num_points = num_points
        self.width = width
        self.height = height
        self.center_x = center_x
        self.center_y = center_y
        self.xtest = self._createXtest()
        self.radius = radius
        
        
    def _createXtest(self):
    
        n = int(self.num_points/4)
        
        C1 = np.array([self.center_x + self.width/2, self.center_y + self.height/2])
        C2 = np.array([self.center_x - self.width/2, self.center_y + self.height/2])
        C3 = np.array([self.center_x - self.width/2, self.center_y - self.height/2])
        C4 = np.array([self.center_x + self.width/2, self.center_y - self.height/2])
        
        C12 = np.column_stack((np.linspace(C1[0],C2[0],n),np.linspace(C1[1],C2[1],n)))
        C23 = np.column_stack((np.linspace(C2[0],C3[0],n),np.linspace(C2[1],C3[1],n)))
        C34 = np.column_stack((np.linspace(C3[0],C4[0],n),np.linspace(C3[1],C4[1],n)))
        C41 = np.column_stack((np.linspace(C4[0],C1[0],n),np.linspace(C4[1],C1[1],n)))
        
        
        X_test = np.vstack((C12,C23,C34,C41))
        
        return X_test    
    
class nPoly2D():
    
    def __init__(self,num_points, num_sides,  radius = 0.5, center_x = -0.25, center_y = 1, *args):
        
        self.num_points = num_points
        self.num_sides = num_sides
        self.radius = radius
        self.center_x = center_x
        self.center_y = center_y
        self.xtest = self._createXtest()
        
        
    def _createXtest(self):
    
        Path = []
        n = int(self.num_points/self.num_sides)
        
        theta = np.linspace(0,2*np.pi,self.num_sides+1)
        Xc = self.radius*np.cos(theta) + self.center_x
        Yc = self.radius*np.sin(theta) + self.center_y
               
        C = np.column_stack((Xc,Yc))
        for i in range(0,self.num_sides):           
            Link = np.column_stack((np.linspace(C[i][0],C[i+1][0],n),np.linspace(C[i][1],C[i+1][1],n)))            
            Path.append(Link)

        X_test = np.vstack((Path[:]))

        return X_test    
        
class Star2D():
    
    def __init__(self,num_points, num_sides,  radius = 0.5, center_x = -0.25, center_y = 1, *args):
        
        self.num_points = num_points
        self.num_sides = num_sides
        self.radius = radius
        self.center_x = center_x
        self.center_y = center_y
        self.xtest = self._createXtest()
        
        
    def _createXtest(self):
    
        Path = []
        Xc = []
        Yc = []
        C = []
        n = int(self.num_points/(self.num_sides*2))
        
        theta_out = np.linspace(0,2*np.pi,self.num_sides+1)
        Xc_out = self.radius*np.cos(theta_out) + self.center_x
        Yc_out = self.radius*np.sin(theta_out) + self.center_y

        theta_in = np.linspace(2*np.pi/(2*self.num_sides),2*np.pi+2*np.pi/(2*self.num_sides),self.num_sides+1)
        Xc_in = self.radius/2*np.cos(theta_in) + self.center_x
        Yc_in = self.radius/2*np.sin(theta_in) + self.center_y

        C_out = np.column_stack((Xc_out,Yc_out))
        C_in = np.column_stack((Xc_in,Yc_in))

        for cout,cin in zip(C_out[:-1],C_in[:-1]):
            C.append(cout)
            C.append(cin)
            
        C.append(C_out[-1])
        C = np.vstack((C[:]))
        
        for i in range(0,self.num_sides*2):           
            Link = np.column_stack((np.linspace(C[i][0],C[i+1][0],n),np.linspace(C[i][1],C[i+1][1],n)))            
            Path.append(Link)
        
        
        X_test = np.vstack((Path[:]))
        
        return X_test
    
    
