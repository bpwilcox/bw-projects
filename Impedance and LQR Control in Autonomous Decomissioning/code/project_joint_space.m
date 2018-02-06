%2.151 Project
%State Space Model of a Torque Controlled, Planar Robot With 3 DOFs and
%Series Elastic Actuators
clear all,close all,clc


%Model neglecting Series Elastic Actuators
%Open Loop
CIM =[11.3011 1.1257 2.3917;
    1.1257 6.1354 0.2495;
    2.3917 0.2495 1.1338];

%Damping. For now, set to zero.
Damping=[0.01 0 0;
    0 0.01 0;
    0 0 0.01];

jj =[-0.3199 -0.0883 -0.2295;
    0.3004 -0.3639 0.0017;
    0 0 1.0000];

JSIM=[1.4495 -0.2502 0.0645;
    -0.2502 0.3728 0.0172;
    0.0645 0.0172 0.0312];

Ir1=0.044; %kgm^2
Ir2=0.6; %kgm^2
Ir3=Ir2;

Ir=[Ir1 0 0;
    0 Ir2 0;
    0 0 Ir3];

% K=[100 0 0;
%     0 100 0;
%     0 0 0];

% K=zeros(3);

% B=[1 0 0;
%     0 1 0;
%     0 0 1];

% B=zeros(3);
% 
% A1=[zeros(3) eye(3);
%     -inv(JSIM+Ir)*jj'*K*jj -inv(JSIM+Ir)*(Damping+jj'*B*jj)];

A1=[zeros(3) eye(3);
    zeros(3) -inv(JSIM+Ir)*(Damping)];

% B1=[zeros(3);
%     inv(JSIM+Ir)*jj'*K*jj];

B1=[zeros(3);
    inv(JSIM+Ir)];



% C1=[0 0 0 jj(2,:)];
C1=[jj(1,:) 0 0 0];

% C1=[0 0 jj(1,3) 0 0 0];

D1=[0];


%Do we need/want in companion form? 
% Ctrb = [B1 A1*B1 A1^2*B1 A1^3*B1 A1^4*B1 A1^5*B1]
% rank(Ctrb);
% a = charpoly(A1);
% Atpz = toeplitz(a(1:6))
% % Atpz = [60 1;1 0];
% T=Ctrb*Atpz; 
% Ac = inv(T)*A*T;
% Bc = inv(T)*B;
% Cc = C*T;
% sys = ss(Ac,Bc,Cc,D);



% sys1=ss(A1,B1(:,2),C1,D1);
% Ctrb2 = ctrb(sys1)
% rank(ctrb(sys1));
% 
% Q = C1'*C1;
Q = eye(6);
Q(1,1);
Q(2,2);
Q(3,3);
Q(4,4);
Q(5,5);
Q(6,6);


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

% figure
% bode(sys1)

% [NUM,DEM]=ss2tf(A1,B1(:,1),C1,D1);
% figure
% bode(NUM,DEM)

x0=[0 1 0 0 0 0];
figure
initial(sys1,sys2, sys3,x0)
% figure
% step(sys1)
% pzmap(sys1)
% zpk(sys1)



%%

% %Model including Series Elastic Actuators
% %Stiffness of joints
% Ksea=[843 0 0;
%     0 843 0;
%     0 0 250];
% 
% 
% E=[0.01 0 0;
%     0 0.01 0;
%     0 0 0.01];
% 
% Z=zeros(3);
% 
% A3=[Z eye(3) Z Z;
%     -inv(JSIM)*Ksea -inv(JSIM)*E inv(JSIM)*Ksea Z;
%     Z Z Z eye(3);
%     inv(Ir)*Ksea-inv(Ir)*jj'*K*jj -Ir*jj'*B*jj -inv(Ir)*Ksea -inv(Ir)*Damping];
% 
% B3=[Z;Z;Z;inv(Ir)*jj'*K*jj];
% 
% C3=[0 0 0 jj(2,:) 0 0 0 0 0 0];
% 
% D3=[0];
% 
% sys2=ss(A3,B3(:,2),C3,D3);
% 
% figure
% bode(sys2)
% 
% % [NUM,DEM]=ss2tf(A1,B1(:,1),C1,D1);
% % figure
% % bode(NUM,DEM)
% 
% x02=[0 1 0 0 0 0 0 0 0 0 0 0];
% figure
% initial(sys2,x02)
% figure
% step(sys2)
% pzmap(sys2)
% zpk(sys2)
