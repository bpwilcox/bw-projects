import numpy as np
import matplotlib.pyplot as plt
from load_data import *
from p3_utils import *
from transforms3d.euler import euler2mat, mat2euler
from numpy.linalg import inv

def Mapping(m,grid,Polar,x,scan,b_T_l):

    r = np.array([0,0,0,1])
    R_body =  euler2mat(0,0,x[2])
    h0 = np.reshape(np.array([x[0],x[1],.93]),[3, 1])

    w_T_b = np.block([[R_body,h0],[r]])
    
    
    Cart = polar2cart(Polar,scan)
    row = np.ones([1,1081])
    Cart = np.vstack((Cart,row))
    Cart = Cart[:,removescan(scan)]

    
    z_w = np.dot(np.dot(w_T_b,b_T_l),Cart)
    z_w = z_w[:,removeGround(z_w)]
    zcell = getgridz(z_w,grid)
    
    x_w = np.dot(w_T_b,b_T_l)[:2,3]
    xcell = getgridx(x_w,grid)
    
    m = logOdds(m,xcell,zcell)  

    return m

def getwTb(x):
    
    r = np.array([0,0,0,1])
    R_body =  euler2mat(0,0,x[2])
    h0 = np.reshape(np.array([x[0],x[1],.93]),[3, 1])
    w_T_b = np.block([[R_body,h0],[r]])
    
    return w_T_b

def DeadReckoning(xt,o,o_next,b_T_l):
    
    r = np.array([0,0,0,1])
    R_body =  euler2mat(0,0,xt[2])
    h0 = np.reshape(np.array([xt[0],xt[1],.93]),[3, 1])
    w_T_b = np.block([[R_body,h0],[r]])
    
    R_odom = euler2mat(0,0,o[2])
    o_xy = np.reshape(np.array([o[0],o[1],0]),[3, 1])
    w_T_l = np.block([[R_odom,o_xy],[r]])
    
    R_odom2 = euler2mat(0,0,o_next[2])
    o_xy2 = np.reshape(np.array([o_next[0],o_next[1],0]),[3, 1])
    w_T_l2 = np.block([[R_odom2,o_xy2],[r]])    
    
    A = np.matmul(b_T_l,inv(w_T_l))
    B = np.matmul(A,w_T_l2)
    C = np.matmul(B,inv(b_T_l))
    
    w_T_b = np.dot(w_T_b,C)
    

    x_next = np.zeros((3,1))
    
    x_next[0] = w_T_b[0,3]
    x_next[1] = w_T_b[1,3]
    x_next[2] = mat2euler(w_T_b[:3,:3])[2]

    
    return x_next

def LocalizationPrediction(mu,o,o_next,b_T_l):
    
    mu_next = np.zeros((3,len(mu.T)))
    r = np.array([0,0,0,1])
    
    for i,xt in enumerate(mu.T):
        noise = np.random.normal(0,1,[3,1])
        R_noise= euler2mat(0,0,0.01*noise[2,0])
        h_n = np.reshape(np.array([0.01*noise[0,0],0.01*noise[1,0],0]),[3, 1])
        Noise = np.block([[R_noise,h_n],[r]])
        
        
        R_body =  euler2mat(0,0,xt[2])
        h0 = np.reshape(np.array([xt[0],xt[1],.93]),[3, 1])
        w_T_b = np.block([[R_body,h0],[r]])
    
    
        R_odom = euler2mat(0,0,o[2])
        o_xy = np.reshape(np.array([o[0],o[1],0]),[3, 1])
        w_T_l = np.block([[R_odom,o_xy],[r]])
        
        R_odom2 = euler2mat(0,0,o_next[2])
        o_xy2 = np.reshape(np.array([o_next[0],o_next[1],0]),[3, 1])
        w_T_l2 = np.block([[R_odom2,o_xy2],[r]])    
    
        A = np.matmul(b_T_l,inv(w_T_l))
        B = np.matmul(A,w_T_l2)
        C = np.matmul(B,inv(b_T_l))
        
        D = np.matmul(Noise,C)
    
        w_T_b = np.matmul(w_T_b,D)
        
        mu_next[0,i] = w_T_b[0,3]
        mu_next[1,i] = w_T_b[1,3]
        mu_next[2,i] = mat2euler(w_T_b[:3,:3])[2]

    return mu_next


def LocalizationUpdate(mu,alpha,z,m,b_T_l,grid,Polar):
    
    
    
    res = grid[1]-grid[0]
    xr = np.arange(-4*res,5*res,res)
    yr = xr   
    thr = np.arange(-4,5,1)*np.pi/180
    corr = np.zeros((len(xr),len(yr),len(thr)))
    cmax = np.zeros((len(mu.T),1))
    mu_upd = np.zeros((3,len(mu.T)))
    r = np.array([0,0,0,1])
    
    m_th = np.zeros(m.shape).astype(np.uint8)
    thresh = m > 0.
    m_th[thresh] = 1
    thresh = m < 0.
    m_th[thresh] = 0
    
    for i,x in enumerate(mu.T):
        R_body =  euler2mat(0,0,x[2])
        h0 = np.reshape(np.array([x[0],x[1],.93]),[3, 1])
        w_T_b = np.block([[R_body,h0],[r]])
        
        
        Cart = polar2cart(Polar,z)
        row = np.ones([1,1081])
        Cart = np.vstack((Cart,row))
        Cart = Cart[:,removescan(z)]

        z_w = np.dot(np.dot(w_T_b,b_T_l),Cart)
        z_w = z_w[:,removeGround(z_w)]
        
        for j,th in enumerate(thr):
            R_th = euler2mat(0,0,th)
            h_th = np.reshape(np.array([0,0,0]),[3, 1])
            THr = np.block([[R_th,h_th],[r]])
            
            z_th = np.matmul(THr,z_w)
            
            corr[:,:,j] = mapCorrelation(m_th,grid,grid,z_th[:3,:],xr,yr)
        
        cmax[i,0] = np.max(corr)
        cmax_ind = np.unravel_index(np.argmax(corr),(len(xr),len(yr),len(thr)))
        C = np.array((xr[cmax_ind[0]],yr[cmax_ind[1]],thr[cmax_ind[2]]))
        
        R_C = euler2mat(0,0,C[2])
        h_C = np.reshape(np.array([C[0],C[1],0]),[3, 1])
        Cr = np.block([[R_C,h_C],[r]])
        w_T_b = np.matmul(Cr,w_T_b)
        
        mu_upd[0,i] = w_T_b[0,3]
        mu_upd[1,i] = w_T_b[1,3]
        mu_upd[2,i] = mat2euler(w_T_b[:3,:3])[2] 
        
    p = softmax(cmax)
    alpha = alpha*p.T/np.sum(alpha*p.T)
     
     
    
    return mu_upd,alpha

def softmax(z):
    num = np.exp(z-np.max(z))
    den = np.sum(num)
    
    s = num/den
    return s

def SLAM(N,grid,N_thresh,updateStep,ts_j,ts_l,head,scan,odom,dataset):
   
    # Initialization
    m = np.zeros([1001,1001])
    m_t = np.zeros([1001,1001,3])
    I = np.eye(3)
    h2 = np.reshape(np.array([0,0,.15]),[3, 1])
    r = np.array([0,0,0,1])
    h_T_l = np.block([[I,h2],[r]])

    
    index = np.indices((1081,1))
    ind = np.zeros([1,1081])
    ind[0,:] = index[0,:,:].flatten()
    Polar = pixel2polar(ind)
    
    # Texture Mapping Data
    
    # Load dataset
    if dataset == 0:
        r0 = get_rgb(fileRGB)
        d0 = get_depth(fileDepth)
        
        ts_d = np.zeros(len(r0))
        for i in range(len(r0)):
            ts_d[i] = r0[i]['t']
            
    elif dataset == 3:
        d0 = get_depth(fileDepth)
        r1 = get_rgb(fileRGB1)
        r2 = get_rgb(fileRGB2) 
        r3 = get_rgb(fileRGB3)
        r4 = get_rgb(fileRGB4)
        
        r0 = r1+r2+r3+r4
        
        ts_d = np.zeros(len(r0))
        for i in range(len(r0)):
            ts_d[i] = r0[i]['t']
            
    elif dataset == 'test':
        d0 = get_depth(fileDepth)
        r1 = get_rgb(fileRGB1)
        r2 = get_rgb(fileRGB2) 
        r3 = get_rgb(fileRGB3)
        r4 = get_rgb(fileRGB4)        
        r5 = get_rgb(fileRGB5)
        r6 = get_rgb(fileRGB6) 
        r7 = get_rgb(fileRGB7)
        r8 = get_rgb(fileRGB8)  
        r9 = get_rgb(fileRGB9) 
        
        r0 = r1+r2+r3+r4+r5+r6+r7+r8+r9
        
        ts_d = np.zeros(len(r0))
        for i in range(len(r0)):
            ts_d[i] = r0[i]['t']
            
    # Camera Parameters
    IRCalib = getIRCalib()
    RGBCalib = getRGBCalib()
    R_rgb = getExtrinsics_IR_RGB()


    cu = IRCalib['cc'][0]
    cv = IRCalib['cc'][1]    
    fu = IRCalib['fc'][0]
    fv = IRCalib['fc'][1]
    
    cu_r = RGBCalib['cc'][0]
    cv_r = RGBCalib['cc'][1]   
    fu_r = RGBCalib['fc'][0]
    fv_r = RGBCalib['fc'][1]

   
    
    r = np.array([0,0,0,1])
    R =  euler2mat(0,0,0)
    hc = np.reshape(np.array([0,0,.07]),[3, 1])
    h_T_c = np.block([[R,hc],[r]])

    R_oc = np.array([[0,-1,0],[0,0,-1],[1,0,0]])
    K = np.array([[fu_r,0,cu_r],[0,fv_r,cv_r],[0,0,1]])
    
    R_r = R_rgb['rgb_R_ir']
    hr = np.reshape(R_rgb['rgb_T_ir'],[3,1])
    w_T_rgb = np.block([[R_r,hr],[r]])
    

        

    xpath = []
    tpath = []
    mu = np.zeros((3,N))
    alpha = np.ones((1,N))/N
    count = 0
    # Get First Map
    tind= np.argmin(np.abs(ts_j[0,:]-ts_l[0,0]))
    b_T_l =transformL2b(h_T_l,head[:,tind])
    mu = LocalizationPrediction(mu,np.array([0,0,0]),odom[0,:],b_T_l) 

    mu,alpha = LocalizationUpdate(mu,alpha,scan[0,:],m,b_T_l,grid,Polar)
    best = np.argmax(alpha)
    mu_best = mu[:,best]
    # Mapping
    m = Mapping(m,grid,Polar,mu_best,scan[0,:],b_T_l) 
    xpath.append(mu_best)
    tpath.append(ts_l[0,0])
    j = 0
    plotcurrent(m,xpath,count,dataset,j)
    count = count+1
#    for j in range(len(odom)-1):
    for j in range(1,len(odom)):
    
        # Prediction
        tind= np.argmin(np.abs(ts_j[0,:]-ts_l[0,j]))
        b_T_l =transformL2b(h_T_l,head[:,tind])
#        mu = LocalizationPrediction(mu,odom[j,:],odom[j+1,:],b_T_l) 
        mu = LocalizationPrediction(mu,odom[j-1,:],odom[j,:],b_T_l) 
        
        if j%updateStep == 0:  
            print(j)         
            #Update
            mu,alpha = LocalizationUpdate(mu,alpha,scan[j,:],m,b_T_l,grid,Polar)

            best = np.argmax(alpha)
            mu_best = mu[:,best]
            # Mapping
            m = Mapping(m,grid,Polar,mu_best,scan[j,:],b_T_l)
            if dataset == 0 or dataset == 3 or dataset == 'test':
                m_t = TextureMap(r0,d0,R_oc,cu,cv,fu,fv,K,w_T_rgb,h_T_c,ts_d,mu_best,ts_l[0,j],m_t,head,ts_j,grid)
            # Resampling
            N_eff = 1/np.sum(alpha**2)          
            if N_eff <=N_thresh:
                mu,alpha = resampling(mu,alpha)               
            xpath.append(mu_best)
            tpath.append(ts_l[0,j])
            if j%2400 == 0:
                print(j)
                plotcurrent(m,xpath,count,dataset,j)
                count = count + 1
            
            
    return m, xpath, tpath, m_t, count 


def TextureMap(r0,d0,R_oc,cu,cv,fu,fv,K,w_T_rgb,h_T_c,ts_d,x,t, m_t,head,ts_j,grid):
        

    res = grid[1]-grid[0]

    # Updating texture map

    ind = np.argmin(np.abs(t-ts_d))
    w_T_b = getwTb(x)
    ts_d = ts_d[ind]
    Im_rgb = r0[ind]['image']
    Im_d = d0[ind]['depth']

    x_ir = np.zeros((Im_d.shape[0]*Im_d.shape[1]))
    y_ir = np.zeros((Im_d.shape[0]*Im_d.shape[1]))
    z_ir = np.zeros((Im_d.shape[0]*Im_d.shape[1]))
    
    ind_d = 0
    for i in range(0,Im_d.shape[0],3):
        for j in range(Im_d.shape[1]):
            z_ir[ind_d] = Im_d[i,j]/1000
            x_ir[ind_d] = ((j-cu)*z_ir[ind_d])/fu
            y_ir[ind_d] = ((i-cv)*z_ir[ind_d])/fv
            ind_d = ind_d + 1
            
    z_ir = z_ir[0:ind_d]
    x_ir = x_ir[0:ind_d]
    y_ir = y_ir[0:ind_d]
    p_ir = np.ones((4,z_ir.shape[0]))
    

    
    p_ir[0,:] = x_ir
    p_ir[1,:] = y_ir
    p_ir[2,:] = z_ir
    p_ir = np.dot(w_T_rgb,p_ir)
    p_ir[0:3,:] = np.dot(np.linalg.inv(R_oc),p_ir[0:3,:])

    
    ind_s = np.argmin(np.abs(ts_d-ts_j[0,:]))
    
    b_T_h = getbTh(head[:,ind_s])
    
    p_b = np.dot(b_T_h,p_ir)
    p_w = np.dot(w_T_b,p_b)
    
    ground = p_w[2,:] < 0.1
    p_w = p_w[:,ground]
    

    p_b = np.dot(np.linalg.inv(w_T_b),p_w)
    p_h = np.dot(np.linalg.inv(b_T_h),p_b)
    p_c = np.dot(np.linalg.inv(h_T_c),p_h)
    p_ir = np.dot(R_oc,p_c[0:3,:])
    p_ir = p_ir/p_ir[2,:]
    P = np.dot(K,p_ir)

#    
    
    for i in range(p_w.shape[1]):
        xis = np.ceil((p_w[0,i] - grid[0]) / res ).astype(np.int16)-1
        yis = np.ceil((p_w[1,i] - grid[0]) / res ).astype(np.int16)-1
        indGood_1 = np.logical_and(np.logical_and(np.logical_and((xis > 1), (yis > 1)), (xis < len(grid))), (yis < len(grid)))
        indGood_2 = np.logical_and(np.logical_and(np.logical_and((P[0,i] > 1), (P[1,i] > 1)), (P[1,i] < Im_rgb.shape[0])), (P[0,i] < Im_rgb.shape[1]))
        if (indGood_1 and indGood_2):
            P_rgb = Im_rgb[P[1,i].astype(np.int),P[0,i].astype(np.int)]
            m_t[xis,yis] = P_rgb[[2,1,0]]            
        
    return m_t

def resampling(mu,alpha):
    
    N = len(alpha.T)
    j = 0
    c = alpha[0,0]
    mu_resamp = np.zeros(mu.shape)
    alpha_resamp = np.ones(alpha.shape)/N
    
    for k in range(N):
        u = np.random.uniform(0,1/N)
        beta = u + k/N
        while(beta > c):
            j = j+1
            c = c+alpha[0,j]
        
        mu_resamp[:,k] = mu[:,j] 
        
        
    return mu_resamp, alpha_resamp


def pixel2polar(ind):
    
    Polar = np.zeros((1081,1))   
    
    theta = (270/1080)*ind[0,:]-135
    Polar[:,0] = theta*np.pi/180.
  
    
    return Polar

def polar2cart(Polar,scan):
    
    cart = np.zeros([3,1081])
    r = scan
 
    x = r*np.cos(Polar[:,0])
    y = r*np.sin(Polar[:,0]) 
    
    cart[0,:] = x
    cart[1,:] = y
    
    
    return cart

def removeGround(z):
    rmv = z[2,:] > 0.1
    
    return rmv

def logOdds(m, xcell, zcell):
    g0 = 1/9
    g1 = 9
    for z in zcell:
        Cell = bresenham2D(int(xcell[0]), int(xcell[1]), z[0], z[1])
        Occ = Cell[:,-1]
        Free = Cell[:,:-1]
        m[int(Occ[0]),int(Occ[1])] += np.log(g1)
        m[Free[0,:].astype(int),Free[1,:].astype(int)] += np.log(g0)
      
    return m
    
def getgridx(start,grid):
    xx = np.digitize(start[0],grid)
    yy = np.digitize(start[1],grid)
    xcell = np.array((xx,yy))
    return xcell

def getgridz(z,grid):
    zx = np.digitize(z[0,:],grid)
    zy = np.digitize(z[1,:],grid)
    zcell = np.array((zx.T,zy.T)).T
    return zcell

def getbTh(head):
    
    r = np.array([0,0,0,1])
    h1 = np.reshape(np.array([0,0,.33]),[3, 1])
    R_head = euler2mat(0,head[1],0)
    R_neck = euler2mat(0,0,head[0])
    R = np.dot(R_neck,R_head)
    b_T_h =  np.block([[R,h1],[r]])
    
    return b_T_h

def transformL2b(h_T_l,head):
    
    r = np.array([0,0,0,1])
    h1 = np.reshape(np.array([0,0,.33]),[3, 1])
    R_head = euler2mat(0,head[1],0)
    R_neck = euler2mat(0,0,head[0])
    R = np.dot(R_neck,R_head)
    b_T_h =  np.block([[R,h1],[r]])
    b_T_l = np.dot(b_T_h,h_T_l)
    
        
    return b_T_l

def removescan(scan):
    
    rmv = np.logical_and((scan < 30),(scan > 0.1))
    
    return rmv

def threshm(m):
    

    m_th = np.zeros(m.shape)
    thresh = m > 0.
    m_th[thresh] = 1
    thresh = m < 0.
    m_th[thresh] = 0
    thresh = m==0
    m_th[thresh] = 0.5

    return m_th

def threshm2(m):
    

    m_th = np.zeros(m.shape)
    thresh = m > 0.
    m_th[thresh] = 0
    thresh = m < 0.
    m_th[thresh] = 1
    thresh = m==0
    m_th[thresh] = 0.5

    return m_th

def textmap(m,m_t):
    
    m_th = threshm2(m)
    m_new = np.zeros([1001,1001,3])
    m_new[:,:,0] = m_th
    m_new[:,:,1] = m_th
    m_new[:,:,2] = m_th
    
    A = m_new == 0.5   
    F = m_t != 0
    
    m_new[F] = m_t[F]
    m_new[A] = 0.5
        
    return m_new

def plotcurrent(m,xpath,count,dataset,j):
    
    xpath = np.squeeze(np.asarray(xpath))  
    m_th = threshm(m)
    fname  = 'Map_' + str(dataset) + '_' + str(count) + '.png'
    
    if (count > 0):       

        x_path = np.ceil((xpath[:,0] - grid[0]) / res ).astype(np.int16)-1
        y_path = np.ceil((xpath[:,1] - grid[0]) / res ).astype(np.int16)-1
        plt.imshow(m_th, cmap = "Greys")
        plt.plot(y_path,x_path,linewidth=2, color='firebrick') 
    else:
        plt.imshow(m_th, cmap = "Greys")
        
    plt.title('Dataset: '+ str(dataset) + ', Iteration: '+ str(j))
      
#    plt.savefig(fname)
    return 

dataset = 0
#dataset = 'test'


if dataset == 0:
    fileLidar = 'trainset/lidar/train_lidar' + str(dataset)
    fileJoint = 'trainset/joint/train_joint' + str(dataset)
    
    fileDepth = 'trainset/cam/DEPTH_' + str(dataset)
    fileRGB = 'trainset/cam/RGB_' + str(dataset)
    
elif dataset == 3:
    fileLidar = 'trainset/lidar/train_lidar' + str(dataset)
    fileJoint = 'trainset/joint/train_joint' + str(dataset)
    
    fileDepth = 'trainset/cam/DEPTH_' + str(dataset)
    fileRGB1 = 'trainset/cam/RGB_' + str(dataset) +'_1'
    fileRGB2 = 'trainset/cam/RGB_' + str(dataset) +'_2'
    fileRGB3 = 'trainset/cam/RGB_' + str(dataset) +'_3'
    fileRGB4 = 'trainset/cam/RGB_' + str(dataset) +'_4'
    
elif dataset == 'test':
    fileLidar = 'testset/lidar/test_lidar'
    fileJoint = 'testset/joint/test_joint' 
    fileDepth = 'testset/cam/DEPTH'
    
    fileRGB1 = 'testset/cam/RGB_' +'1'
    fileRGB2 = 'testset/cam/RGB_' +'2'
    fileRGB3 = 'testset/cam/RGB_' +'3'
    fileRGB4 = 'testset/cam/RGB_' +'4'
    fileRGB5 = 'testset/cam/RGB_' +'5'
    fileRGB6 = 'testset/cam/RGB_' +'6'
    fileRGB7 = 'testset/cam/RGB_' +'7'
    fileRGB8 = 'testset/cam/RGB_' +'8'
    fileRGB9 = 'testset/cam/RGB_' +'9'
    
else:
    fileLidar = 'trainset/lidar/train_lidar' + str(dataset)
    fileJoint = 'trainset/joint/train_joint' + str(dataset)

Lidar = get_lidar(fileLidar)
Joint = get_joint(fileJoint)

head = Joint['head_angles']
ts_j = Joint['ts']

scan = []
ts_l = []
odom = []

for d in Lidar:
    scan.append(d['scan'])
    ts_l.append(d['t'])
    odom.append(d['pose'])

scan = np.squeeze(np.asarray(scan))
ts_l = np.squeeze(np.asarray(ts_l)).reshape([1,len(ts_l)])
odom = np.squeeze(np.asarray(odom))


#-----------------------------------------------------------------------------#

## Hyperparameters
N = 25
N_thresh = 5
grid = np.linspace(-30,30,1001)
updateStep = 100
res = grid[1]-grid[0]
#
##-----------------------------------------------------------------------------#
#
## SLAM 
m,xpath,tpath,m_t,count = SLAM(N,grid,N_thresh,updateStep,ts_j,ts_l,head,scan,odom,dataset)

fname  = 'Map_' + str(dataset) + '_' + str(count) + '.png'
last = len(odom)-1
plotcurrent(m,xpath,count,dataset,last)

xpath = np.squeeze(np.asarray(xpath))   
tpath = np.squeeze(np.asarray(tpath))


        

#----------------------------------------------------------------------------#            

## Visualize Map and Trajectory
#pdf = 1 - 1/(1+np.exp(m))        
###plt.imshow(pdf, cmap = "Greys")

#m_th = threshm(m)
#plt.figure()
#plt.imshow(m_th, cmap = "Greys")

if dataset ==0 or dataset ==3 or dataset == 'test':
    m_final = textmap(m,m_t)
    x_path = np.ceil((xpath[:,0] - grid[0]) / res ).astype(np.int16)-1
    y_path = np.ceil((xpath[:,1] - grid[0]) / res ).astype(np.int16)-1
    
    plt.figure()
    plt.imshow(m_final)
    plt.plot(y_path,x_path,linewidth=2, color='firebrick')
    plt.title('Dataset: '+ str(dataset))
    
    fname  = 'Map_' + str(dataset) + '.png'
#    plt.savefig(fname)



#-----------------------------------------------------------------------------#












