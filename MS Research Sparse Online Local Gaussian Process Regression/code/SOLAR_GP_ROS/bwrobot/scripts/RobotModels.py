import numpy as np
import matplotlib.pyplot as pl

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
    