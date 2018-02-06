% IK while-loop controller for 2-DoF arm
clear all
close all

% figure(1)
% f = getframe;
% [im,map] = rgb2ind(f.cdata,256,'nodither');
Parameters2;

Q = zeros (3,1);
Q(1) = pi/3; % motor 1 angle (rad)
Q(2) = pi/6; % motor 2 angle (rad)
Q(3) = 0;
% Q(1) = 150*pi/180;


qd = [pi/2;150*pi/180;l1];

% xd = [-0.1362;-0.2254]; 

% xd = [-0.2;0.4];
xd = [0.4;0.4];

X = forwardkin_2(Q);


e=0.01;

alpha = xd-X;
% step = alpha/norm(alpha);
% K = 10;


% dQ = Pseudo_J*K*norm(alpha)*step; 
% dQ = Pseudo_J*K*(alpha);

T=0;
dT= 0.01;
Xlast = X;
n=1;
J = jacob2(Q);
i=0;
j = 0;
while norm(alpha) > e
n=n+1;
    
K = 10*[2 0 0; 0 2 0; 0 0 2];
alpha = qd-Q;
qdot = K*alpha;

Q =Q+qdot*dT;
T=T+dT;
X = forwardkin_2(Q);

alpha = qd-Q;
% dX = X-Xlast;
% norm(dX);
norm(alpha)

plotrobot2(Q,forwardkin_2(qd),T)


if norm(alpha) > e
    
    clf
else
   
    
    T=0;

r1 = -.4 + (0.4+0.4)*rand();
r2 = -.4 + (0.6+0.4)*rand();
xd = [r1;r2]; 
alpha = qd-Q;
end

end









