function [X,dX,ddX] = generatevirtraj(T)

% T = 0:0.01:4;



xc = ones(length(T),1)*0.2;
yc = ones(length(T),1)*0.4;
r0 = 0.1;
speed = 0.5; %rev/sec
w=speed*2*pi;
C = [xc,yc];

theta0 = getGlobalx;
% theta =  124.4008*pi/180+w*T';

theta =  theta0+w*T';
% theta = 0;

X = [r0*cos(theta), r0*sin(theta)];
 
X = C+X;

dX = [-r0*sin(theta)*w,r0*cos(theta)*w];
% dX=[0 0];

ddX=[-r0*cos(theta)*w^2,-r0*sin(theta)*w^2];
% ddX = [0 0];




end