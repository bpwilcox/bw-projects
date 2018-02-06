%2.151 Project
%State Space Model of a Torque Controlled, Planar Robot With 3 DOFs and
%Series Elastic Actuators
clear all,clc, close all


%%

%Model neglecting Series Elastic Actuators
%Open Loop
CIM =[11.3011 1.1257 2.3917;
    1.1257 6.1354 0.2495;
    2.3917 0.2495 1.1338];

%Damping. For now, set to zero.
% Damping=[0.1 0 0;
%     0 0.1 0;
%     0 0 0.1];

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

%%
%LQR design for Baxter


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



% Q = C1'*C1;


p1 = 1e-2;  %cheap
p2=1; %equal weight
p3 = 1e2; %expensive

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


sys = ss(A1,B1,C1,D1);
sys1 = ss(Ac1,B1,C1,D1);
sys2 = ss(Ac2,B1,C1,D1);
sys3 = ss(Ac3,B1,C1,D1);

%%

%Observer design for single SEA

Ksea=843;  %Spring stiffness
m1=0.6;    %mass, motor side
m2=0.6*0.4; %mass, link side
D=0.1;   %Damping, link side 
B=0.1;  %Damping, motor side 

Asea=[0 1 0 0;
   -Ksea/m2 -D/m2 Ksea/m2 0;
    0 0 0 1;
    Ksea/m1 0 -Ksea/m1 -B/m1];

Bsea=[0;
    0;
    0;
    1/m1];


Csea=[1 0 0 0];
%C1=[-Ksea -D Ksea 0];

Dsea=[0];

Qs=Csea'*Csea;

Rs=[1/1];

[K,S,e]=lqr(Asea,Bsea,Qs,Rs);

Ac=Asea-Bsea*K;

syssea=ss(Asea,Bsea,Csea,Dsea);
syssc=ss(Ac,Bsea,Csea,Dsea);
op = 5*pole(syssc);

L = place(Asea',Csea',op')';

% At = [ Asea-Bsea*K             Bsea*K
%        zeros(size(Asea))    Asea-L*Csea ];
% 
% Bt = [    Bsea
%        zeros(size(Bsea)) ];
% 
% Ct = [ Csea    zeros(size(Csea)) ];

At = [ Asea           -Bsea*K
       L*Csea    Asea-Bsea*K-L*Csea ];

Bt = [    Bsea
       Bsea ];

Ct = [ Csea    zeros(size(Csea)) ];
Ct2 = [zeros(size(Csea)) Csea ];
Ct3 = [-Ksea -D Ksea 0 zeros(size(Csea))];

syst = ss(At,Bt,Ct,Dsea);
syst2 = ss(At,Bt,Ct2,Dsea);
% syst3 = ss(At,Bt,Ct3,Dsea);
% [b,a] = ss2tf(At,Bt,Ct,Dsea);


%%

%Plots

%LQR Plots 

% figure
% pzmap(sys)
% zpk(sys)
x0=[0.3 0 0 0 0 0];
% figure
% initial(sys1,sys2, sys3,x0)
% figure
% step(sys1,sys2,sys3)
% figure
% pzmap(sys1)
% zpk(sys1)
% figure
% pzmap(sys2)
% zpk(sys2)
% figure
% pzmap(sys3)
% zpk(sys3)
% figure
% bode(sys1.sys2,sys3)
% figure

[y1,t1,x1] = initial(sys1,x0) ;
% initial(sys1,x0)
% figure
[y2,t2,x2] = initial(sys2,x0) ;
% initial(sys2,x0)
% figure
[y3,t3,x3] = initial(sys3,x0) ;
% initial(sys3,x0)
u1 = [-K1*x1']' ;
u2 = [-K2*x2']' ;
u3 = [-K3*x3']' ;


J1 = x0*S1*x0' ;
J2 = x0*S2*x0' ;
J3 = x0*S3*x0' ;

%

% Control Effort plots

figure
plot(t1,u1,'LineWidth',1)
xlabel('time (sec)')
ylabel('control effort u (Nm)')
title('Cheap (p=0.01) control')
legend('Shoulder actuator', 'Elbow actuator', 'Wrist actuator')
figure
plot(t2,u2, 'LineWidth',1)
xlabel('time (sec)')
ylabel('control effort u (Nm)')
title('Constraint (p=1) control')
legend('Shoulder actuator', 'Elbow actuator', 'Wrist actuator')
figure
plot(t3,u3, 'LineWidth',1)
xlabel('time (sec)')
ylabel('control effort u (Nm)')
title('Expensive (p=100) control')
legend('Shoulder actuator', 'Elbow actuator', 'Wrist actuator')

%%
%Observer Plots

figure
pzmap(syssea)
zpk(syssea)

figure
pzmap(syssc)
zpk(syssc)

figure
pzmap(syst)
zpk(syst)

x0 = [0.05 0 0 0];  % initial condition for estimator 
% x0 = [0 0 0 0];  % initial condition for estimator 
t = 0:0.003:15;


figure
lsim(syst,ones(size(t)),t,[0 0 0 0 x0]); % simulated step input of 1
figure
lsim(syst2,ones(size(t)),t,[0 0 0 0 x0]);
figure
% bode(syssea,syst)




