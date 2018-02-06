%% Inverse Kinematic Control fo 5-Linkage 2-DoF arm

clear all
close all
Parameters;


% Vector of states
QI = zeros (2,1); 
QI(1) = 2*pi/3; % motor 1 angle (rad)
QI(2) = 210*pi/180; % motor 2 angle (rad)
% QI(1) = 2.0713; 
% QI(2) = 3.5016;
% QI(1) = pi/2;
% QI(2) = pi;
% QI(3) = 0; % motor 1 anglular velocity (rad/s)
% QI(4) = 0; % motor 1 anglular velocity(rad/s)

XI = [l1*cos(QI(1))-(lend-l2)*cos(QI(2)),l1*sin(QI(1))-(lend-l2)*sin(QI(2))];

%set simulation length
TF =4;
dT= 10^-2;
tspan=0:dT:TF;


[T, Q] = ode45('invkin2d', tspan, QI);

% 
X = [l1*cos(Q(:,1))-(lend-l2)*cos(Q(:,2)),l1*sin(Q(:,1))-(lend-l2)*sin(Q(:,2))];
V=zeros(length(T)-1,1);
for i=2:length(T)
V(i) = norm(X(i,:)-X(i-1,:))/dT;
end


