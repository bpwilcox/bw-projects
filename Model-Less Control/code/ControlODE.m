%% Inverse Kinematic Control fo 5-Linkage 2-DoF arm

clear all
close all
Parameters;


% Vector of states
QI = zeros (2,1); 
QI(1) = 2*pi/3; % motor 1 angle (rad)
QI(2) = 210*pi/180; % motor 2 angle (rad)
XI(1) = l1*cos(QI(1))-(lend-l2)*cos(QI(2));
XI(2) = l1*sin(QI(1))-(lend-l2)*sin(QI(2));

% QI(1) = 2.0713; 
% QI(2) = 3.5016;
% QI(1) = pi/2;
% QI(2) = pi;
% QI(3) = 0; % motor 1 anglular velocity (rad/s)
% QI(4) = 0; % motor 1 anglular velocity(rad/s)

% XI = [l1*cos(QI(1))-(lend-l2)*cos(QI(2)),l1*sin(QI(1))-(lend-l2)*sin(QI(2))];

ZI = zeros(4,1);

ZI(1) = XI(1);
ZI(2) = XI(2);
ZI(3) = QI(1);
ZI(4) = QI(2);

% ZI(1) = QI(1);
% ZI(2) = QI(2);



%set simulation length
TF =2;
dT= 10^-2;
tspan=0:dT:TF;

[T, Z] = ode45('ControlKin', tspan, ZI);

% 
% X = [l1*cos(Z(:,1))-(lend-l2)*cos(Z(:,2)),l1*sin(Z(:,1))-(lend-l2)*sin(Z(:,2))];
X = Z(:,1:2);
V=zeros(length(T)-1,1);
for i=2:length(T)
V(i) = norm(X(i,:)-X(i-1,:))/dT;
end

xd = [0.4;0];
A = Z(:,3:4);

for i=1:length(tspan)
    
plotrobot([A(i,1),A(i,2)],xd,tspan(i))
clf
end
