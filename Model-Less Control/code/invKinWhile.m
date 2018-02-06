% IK while-loop controller for 2-DoF arm
clear all
close all

Q = zeros (2,1); 
Q(1) = 2*pi/3; % motor 1 angle (rad)
Q(2) = 210*pi/180; % motor 2 angle (rad)
% Q(1) = 150*pi/180;
Parameters;


% xd = [-0.1362;-0.2254]; 

xd = forwardkin([150*pi/180;120*pi/180]);
X = [l1*cos(Q(1))-(lend-l2)*cos(Q(2));l1*sin(Q(1))-(lend-l2)*sin(Q(2))];


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
while norm(alpha) > e
    n=n+1;
    
J = [-l1*sin(Q(1)) (lend-l2)*sin(Q(2));l1*cos(Q(1)) -(lend-l2)*cos(Q(2))];
Pseudo_J = pinv(J);


step = alpha/norm(alpha)*0.005;

dQ = Pseudo_J*step; 

Q = Q+dQ;
T=T+dT;

X = forwardkin(Q);
% X = [l1*cos(Q(1))-(lend-l2)*cos(Q(2));l1*sin(Q(1))-(lend-l2)*sin(Q(2))];
% X=awgn(X,20);
alpha = xd-X;

norm(X-Xlast);

Xlast = X;



A = Q(1:2,1);


Origin =[0 0];
Link1 =[l1*cos(A(1)) l1*sin(A(1))];
Link2 =[l2*cos(A(2)) l2*sin(A(2))];
Link3 = [l2*cos(A(2))+l1*cos(A(1)) l2*sin(A(2))+l1*sin(A(1))];
Link4 = [l1*cos(A(1))-(lend-l2)*cos(A(2)) l1*sin(A(1))-(lend-l2)*sin(A(2))];

plot(Origin(1),Origin(2),'ro')
hold on

plot(xd(1),xd(2),'+')
% plot(x,y)
plot(Link1(1),Link1(2),'ro')
plot(Link2(1),Link2(2),'ro')
plot(Link3(1),Link3(2),'ro')
plot(Link4(1),Link4(2),'ro')


plot([Origin(1) Link1(1)],[Origin(2) Link1(2)],'b')
plot([Origin(1) Link2(1)],[Origin(2) Link2(2)],'b')

plot([Link2(1) Link3(1)],[Link2(2) Link3(2)],'b')
plot([Link3(1) Link4(1)],[Link3(2) Link4(2)],'b')
title(strcat('Time: ',num2str(T)))

axis([-0.5 0.6 -0.5 0.7])
daspect([1 1 1])

drawnow

if norm(alpha) > e
clf
else
    
T=0;

r1 = -.4 + (0.4+0.4)*rand();
r2 = -.4 + (0.6+0.4)*rand();
xd = [r1;r2]; 
alpha = xd-X;
end

end









