%2.151 Project
%State Space Model of a Torque Controlled, Planar Robot With 3 DOFs and
%Series Elastic Actuators
clear all,clc, close all


%Model neglecting Series Elastic Actuators
%Open Loop
CIM =[11.3011 1.1257 2.3917;
    1.1257 6.1354 0.2495;
    2.3917 0.2495 1.1338];

%Damping. For now, set to zero.
Damping=[0 0 0;
    0 0 0;
    0 0 0];

jj =[-0.3199 -0.0883 -0.2295;
    0.3004 -0.3639 0.0017;
    0 0 1.0000];


A1=[zeros(3) eye(3);
    zeros(3) -inv(CIM)*Damping];

B1=[zeros(3);
    inv(CIM)*inv(jj')];

C1=[1 0 0 0 0 0];

D1=[0];

figure
sys = ss(A1,B1,C1,D1);
pzmap(sys)
zpk(sys)

l1=0.438809; %m link length 1
l2=0.37442; %m link length 2
l3=0.229525; %m link length 3




Q = eye(6);
Q(1,1) = 1/(l1/2+l2/2+l3/2)^2;
Q(2,2)=1e-2;
Q(3,3)=1e-2;
Q(4,4)=1e-2;
Q(5,5)=1e-2;
Q(6,6)=1e-2;


p1 = 1e-6;  %cheap
p2=1; %equal weight
p3 = 1e6; %expensive

R = eye(3);

R(1,1) = 1/(50^2);
R(2,2) = 1/(15^2);
R(3,3) = 1/(15^2);

R1 =p1*R;
R2 = p2*R;
R3 = p3*R;

[K1,S1,e1] = lqr(A1,B1,Q,R1);
[K2,S2,e2] = lqr(A1,B1,Q,R2);
[K3,S3,e3] = lqr(A1,B1,Q,R3);

Ac1 = A1-B1*K1;
Ac2 = A1-B1*K2;
Ac3 = A1-B1*K3;

sys1 = ss(Ac1,B1,C1,D1);
sys2 = ss(Ac2,B1,C1,D1);
sys3 = ss(Ac3,B1,C1,D1);

x0=[0.5 0 0 0 0 0];
figure
initial(sys1,sys2, sys3,x0)


% sys1=ss(A1,B1(:,2),C1,D1);
% 
% figure
% bode(sys1)
% 
% % [NUM,DEM]=ss2tf(A1,B1(:,1),C1,D1);
% % figure
% % bode(NUM,DEM)
% 
% x0=[0 1 0 0 0 0];
% figure
% initial(sys1,x0)
figure
% step(sys1)
pzmap(sys1)
zpk(sys1)
figure
% step(sys1)
pzmap(sys2)
zpk(sys2)
figure
% step(sys1)
pzmap(sys3)
zpk(sys3)



%%
% %Closed Loop
% 
% jj =[-0.3199 -0.0883 -0.2295;
%     0.3004 -0.3639 0.0017;
%     0 0 1.0000];
% 
% K=[100 0 0;
%     0 100 0;
%     0 0 0];
% 
% B=[1 0 0;
%     0 1 0;
%     0 0 1];
% 
% A2=[zeros(3) eye(3);
%     -inv(CIM)*K -inv(CIM)*(Damping+B)];
% 
% B2=[zeros(3);
%     inv(CIM)*K];
% 
% C2=[-jj'*K -jj'*B];
% 
% D2=[jj'*K];


% sys3=ss(A2,B2(:,2),C1,D1);
% 
% figure
% bode(sys3)
% 
% x0=[0 0.0254 0 0 0 0];
% figure
% initial(sys3,x0)
% figure
% step(sys3)
% pzmap(sys3)
% zpk(sys3)

% x0=[0.0254 0 0 0 0 0];
% figure
% initial(sys2,x0)
% figure
% step(sys2)
% pzmap(sys2)
% zpk(sys2)



%%
% 
% 
% %Stiffness of joints
% Ksea=[843 0 0;
%     0 843 0;
%     0 0 250];
% 
% 
% E=[0 0 0;
%     0 0 0;
%     0 0 0];
% 
% %Inertia due to the motors
% Ir=[Ir1 0 0;
%     0 Ir2 0;
%     0 0 Ir3];
% 
% A3=[Z eye(3) Z Z;
%     -inv(JSIM)*Ksea -inv(JSIM)*E inv(JSIM)*Ksea Z;
%     Z Z Z eye(3);
%     inv(Ir)*Ksea Z -inv(Ir)*Ksea -inv(Ir)*D];
% 
% B3=[Z;Z;Z;inv(Ir)];