import numpy as np
import matplotlib.pyplot as pl
from mpl_toolkits.mplot3d.axes3d import Axes3D

class TwoLink2D():
    
    def __init__(self,l1 = 1, l2 = 1, *args):
        
        self.l1 = l1
        self.l2 = l2
                
        
    def fkin(self,Q):
        X = self.l1*np.cos(Q[:,0])+self.l2*np.cos(Q[:,0]+Q[:,1])
        Y = self.l1*np.sin(Q[:,0])+self.l2*np.sin(Q[:,0]+Q[:,1])
        P = np.column_stack((X,Y))
        return P    
    def fkin_1(self,Q):
        X = self.l1*np.cos(Q[:,0])
        Y = self.l1*np.sin(Q[:,0])
        P = np.column_stack((X,Y))       
        return P
            
    def inkin(self,X):
    
        a = np.sqrt(1-((X[:,0]**2+X[:,1]**2-self.l1**2-self.l2**2)/float((2*self.l1*self.l2)))**2)
        b = (X[:,0]**2+X[:,1]**2-self.l1**2-self.l2**2)/float((2*self.l1*self.l2))
    
        Q2 = np.arctan2(a,b)
    
        Q1 = np.arctan2(X[:,1],X[:,0])-np.arctan2(self.l2*np.sin(Q2),self.l1+self.l2*np.cos(Q2))
    
        Q = np.column_stack((Q1,Q2))
        return Q    
    
    
    "To be added: fdyn, indyn, plotrobot"
    def plotrobot(self,Q):
        origin = np.zeros([len(Q),2])
        link1 = self.fkin_1(Q)
        link2 = self.fkin(Q)
        
        arm = np.vstack((origin,link1,link2))
        
        return arm
        
class ThreeLink2D():
    
    def __init__(self,l1 = 1, l2 = 1, l3 = 1, *args):
        
        self.l1 = l1
        self.l2 = l2
        self.l3 = l3
                
        
    def fkin(self,Q):
        X = self.l1*np.cos(Q[:,0])+self.l2*np.cos(Q[:,0]+Q[:,1])
        Y = self.l1*np.sin(Q[:,0])+self.l2*np.sin(Q[:,0]+Q[:,1])
        P = np.column_stack((X,Y))
        return P    
    def fkin_1(self,Q):
        X = self.l1*np.cos(Q[:,0])
        Y = self.l1*np.sin(Q[:,0])
        P = np.column_stack((X,Y))       
        return P
            
    def inkin(self,X):
    
        a = np.sqrt(1-((X[:,0]**2+X[:,1]**2-self.l1**2-self.l2**2)/float((2*self.l1*self.l2)))**2)
        b = (X[:,0]**2+X[:,1]**2-self.l1**2-self.l2**2)/float((2*self.l1*self.l2))
    
        Q2 = np.arctan2(a,b)
    
        Q1 = np.arctan2(X[:,1],X[:,0])-np.arctan2(self.l2*np.sin(Q2),self.l1+self.l2*np.cos(Q2))
    
        Q = np.column_stack((Q1,Q2))
        return Q    
    
    
    "To be added: fdyn, indyn, plotrobot"
    def plotrobot(self,Q):
        origin = np.zeros([len(Q),2])
        link1 = self.fkin_1(Q)
        link2 = self.fkin(Q)
        
        arm = np.vstack((origin,link1,link2))
        
        return arm        
    
class nLink2D():
    
    def __init__(self, Links = [1,1,1], base = np.array([0,0]),*args):
        
        
        self.num_links = len(Links)
        self.Links = Links
        self.base = base
        
    def fkin(self,Q):
        Ql = 0
        X = self.base[0]
        Y = self.base[1]
        
        for i in range(0,self.num_links):
            Ql = Ql + Q[:,i] 
            X = X + self.Links[i]*np.cos(Ql)
            Y = Y + self.Links[i]*np.sin(Ql)
        P = np.column_stack((X,Y))
        
        return P    
    
    
    
    def fkin_joint(self,Q):
        
        Ql = 0
        X = self.base[0]
        Y = self.base[1]
        self.LinksXY = []
        self.LinksXY.append(self.base)
        
        for i in range(0,self.num_links):
            Ql = Ql + Q[:,i] 
            X = X + self.Links[i]*np.cos(Ql)
            Y = Y + self.Links[i]*np.sin(Ql)
            self.LinksXY.append(np.column_stack((X,Y)))
            
    def inkin(self,X):
        
        self.l1 = self.Links[0]
        self.l2 = self.Links[1]
        
        a = np.sqrt(1-((X[:,0]**2+X[:,1]**2-self.l1**2-self.l2**2)/float((2*self.l1*self.l2)))**2)
        b = (X[:,0]**2+X[:,1]**2-self.l1**2-self.l2**2)/float((2*self.l1*self.l2))
    
        Q2 = np.arctan2(a,b)
    
        Q1 = np.arctan2(X[:,1],X[:,0])-np.arctan2(self.l2*np.sin(Q2),self.l1+self.l2*np.cos(Q2))
    
        Q = np.column_stack((Q1,Q2))
        return Q    
    
    
    "To be added: fdyn, indyn, plotrobot"
    def plotrobot(self,Q):

        self.fkin_joint(Q)
        arm = np.vstack((self.LinksXY[:]))
        return arm        
    
class TwoLink3D():
    
    def __init__(self,l1 = 1, l2 = 1, *args):
        
        self.l1 = l1
        self.l2 = l2
        

class Link():

    def __init__(self, d, a, alpha, *args):
        self.d = d
        self.a = a
        self.alpha = alpha
        
class SerialLink():

    def __init__(self, Links, initY = [], is3D = True, name = 'robot', *args):
        self.Links = Links
        self.num_links = len(Links)
        self.dh_table = self._create_dh_table()
        self.name = name
        
        if is3D:
            self.dim = 3
        else:
            self.dim = 2    
            
        if initY == []:
            self.currentY = np.zeros([1, self.num_links-1])
        else:
            self.currentY = initY
            
        self.currentX,_ = self.fkin(self.currentY)
        
    def _create_dh_table(self):
        dh_table = np.empty([self.num_links,3])
        for i in range(0, self.num_links):
            dh = np.hstack((self.Links[i].alpha, self.Links[i].a, self.Links[i].d))
            dh_table[i, :] = dh
        return dh_table
    
    def add_link(self, Link):      
        self.Links.append(Link)
        self.num_links = len(self.Links)
        self.dh_table = self._create_dh_table()
    
    def set_Y(self, Q):
        self.currentY = Q
        self.currentX,_ = self.fkin(self.currentY)
        
    def T(self, frame, theta):
        alpha = self.Links[frame].alpha
        a = self.Links[frame].a
        d = self.Links[frame].d
        
        H = np.array([[np.cos(theta), -np.sin(theta), 0, a],
           [np.sin(theta)*np.cos(alpha), np.cos(theta)*np.cos(alpha), -np.sin(alpha), -d*np.sin(alpha)],
           [np.sin(theta)*np.sin(alpha), np.cos(theta)*np.sin(alpha),  np.cos(alpha),  d*np.cos(alpha)],
           [0, 0, 0, 1]
           ])
    
        return H
    
    def fkin(self, q, to_frame = -1, from_frame = 0):
        if to_frame < 0:
            to_frame = self.num_links
        H = np.eye(4)
        q = np.column_stack([q, 0])
        for i in range(from_frame, to_frame):
            H = np.matmul(H, self.T(i, q[0,i]))        
        P = H[:self.dim,-1].reshape(1,self.dim)
        R = H[:self.dim,:self.dim]
        return P, R
    
    def fkin_joint(self,Q):
    
        self.LinksXY = []

        for j in range(0,self.num_links):
            P,_ = self.fkin(Q,j+1)
            self.LinksXY.append(P)
    
    "To be added: fdyn, indyn, plotrobot"
    def plotrobot(self,Q):

        self.fkin_joint(Q)
        arm = np.vstack((self.LinksXY[:]))
        return arm   
    
    def plot3D(self, Q = [], elev = 30, azim = 30):
        ax = pl.axes(projection='3d')
        if Q == []:
            Q = self.currentY
            
        r = np.sum(self.dh_table[:,1])
        xmin = -r
        xmax = r
        ymin = -r
        ymax = r
        zmin = -r
        zmax = r
        #pl.figure(1)
        #pl.autoscale(False)
        ax.set_xlim(xmin, xmax)
        ax.set_ylim(ymin, ymax)
        ax.set_zlim(zmin, zmax)
        
        #pl.axis('scaled')
        #pl.axis([xmin, xmax, ymin, ymax])

        "Plot robot arm"
        arm = self.plotrobot(Q)  
        
        ax.plot3D([0,0],[0,0],[zmin,0],'k-',linewidth=2)
        ax.plot3D(arm[:,0],arm[:,1],arm[:,2],'b-',linewidth=5)
        ax.plot3D(arm[:,0],arm[:,1],arm[:,2],'ko',linewidth=5)

        ax.view_init(elev, azim)
        pl.tight_layout()
        #pl.show(block=True)
        #pl.cla()
        return ax
    
        

    