%% 2.152 System Model - MIT MANUS

clear all
close all
Parameters;

% 'Simulation 'Unknown' Parameters
a = m1*lc2^2 +m3*lc3^2+m4*l1^2+I1+I3;
b = m3*l2*lc3-m4*l1*lc4;
d = m2*lc2^2+m3*l2^2+m4*lc4^2+I2+I4;

% Crank center and radius
xc = 0.2;
yc = 0.4;
r0=0.1;

% Vector of states
QI = zeros (11,1); 
% QI(1) = 2*pi/3; % motor 1 angle (rad)
% QI(2) = 210*pi/180; % motor 2 angle (rad)
QI(1) = 2.0713; 
QI(2) = 3.5016;
% QI(1) = pi/2;
% QI(2) = pi;
QI(3) = 0; % motor 1 anglular velocity (rad/s)
QI(4) = 0; % motor 1 anglular velocity(rad/s)

XI = [l1*cos(QI(1))-(lend-l2)*cos(QI(2)),l1*sin(QI(1))-(lend-l2)*sin(QI(2))];
theta0 = atan2(XI(2)-yc,XI(1)-xc);

QI(5)=xc+r0*cos(theta0); %virtual trajectory  X position
QI(6)=yc+r0*sin(theta0); %virtual trajectory  Y position
QI(7)=0; %virtual trajectory X velocity
QI(8)=0; %virtual trajectory Y velocity
QI(9) =0; %unknown parameter estimate 'a'
QI(10) =0; % unknown parameter estimate 'b'
QI(11) =0; %unknown parameter estimate 'd'
%  
% QI(9) =a;
% QI(10) =b;
% QI(11) =d;




%set simulation length
TF =10;
dT= 10^-2;
tspan=0:dT:TF;

setGlobalx(theta0)

[T, Q] = ode45('cranksys', tspan, QI);


X = [l1*cos(Q(:,1))-(lend-l2)*cos(Q(:,2)),l1*sin(Q(:,1))-(lend-l2)*sin(Q(:,2))];
for i=1:length(T)
J = [-l1*sin(Q(i,1)) (lend-l2)*sin(Q(i,2));l1*cos(Q(i,1)) -(lend-l2)*cos(Q(i,2))];
dX(i,1:2) = J*[Q(i,3),Q(i,4)]';
end

theta = 0:0.01:2*pi;
x = xc+r0*cos(theta);
y = yc+r0*sin(theta);

Th = atan2d(X(:,2)-yc*ones(length(T),1),X(:,1)-xc*ones(length(T),1));
for i = 1:length(Th)
    if Th(i)<0
        Th(i) = Th(i) + 360;
    end
    if Th(i)>360
        Th(i) = Th(i) - 360;
    end
end

rev = Th/360;
[rev2,I]=sort(rev);   



plot(x,y,'Linewidth',2)
hold on
plot(X(:,1),X(:,2),'Linewidth',1)
hold on
% plot([X(1,1) xc],[X(1,2) yc]) 
% hold on
% plot([X(1,1) X(1,1)+rhat(1)*r0],[X(1,2) X(1,2)+rhat(2)*r0]) 
xlabel('X position (m)')
ylabel('Y position (m)')
title('Circle trajectory, speed = 0.5 rev/sec')
set(gca,'FontSize',14)
axis equal
r=sqrt((X(:,1)-xc).^2+(X(:,2)-yc).^2);
v =sqrt(dX(:,1).^2+dX(:,2).^2);

v2=v(I);

figure
subplot(2,1,1)
plot(T,r,'Linewidth',2);
xlabel('Time (s)')
ylabel('Radius (m)')
title('Radius')


subplot(2,1,2)
plot(T,v,'Linewidth',2)
xlabel('Time (s)')
ylabel('Velocity (m/s)')
title('Velocity')

% figure
% plot(T,Q(:,9),'Linewidth',2)
% hold on
% plot(T,Q(:,10),'Linewidth',2)
% hold on
% plot(T,Q(:,11),'Linewidth',2)
% % plot([X(1,1) xc],[X(1,2) yc]) 
% % hold on
% % plot([X(1,1) X(1,1)+rhat(1)*r0],[X(1,2) X(1,2)+rhat(2)*r0]) 
% xlabel('Time (s)')
% ylabel('a (kg*m^2)')
% title('Parameters')
% set(gca,'FontSize',14)
% axis equal

