%Single SEA model
clear all,close all,clc
%Open Loop

Ksea=843;  %Spring stiffness
m1=0.6;    %mass, motor side
m2=0.6*0.4; %mass, link side
D=0.1;   %Damping, link side 
B=0.1;  %Damping, motor side 

A1=[0 1 0 0;
   -Ksea/m2 -D/m2 Ksea/m2 0;
    0 0 0 1;
    Ksea/m1 0 -Ksea/m1 -B/m1];

B1=[0;
    0;
    0;
    1/m1];


C1=[1 0 0 0];
%C1=[-Ksea -D Ksea 0];

D1=[0];

sys=ss(A1,B1,C1,D1);

RC=rank(ctrb(A1,B1)); %Controllability of SEA
RO=rank(obsv(A1,C1));   %Observability of SEA




%system is fully contollable, but not observable looking at the link side
%velocity
Q=C1'*C1;

R=[1];

[K,S,e]=lqr(A1,B1,Q,R);
 
Ac=A1-B1*K;
sysc=ss(Ac,B1,C1,D1);
figure
pzmap(sysc)
figure 
bode(sys)
grid minor

figure
pzmap(sys)

tr=zpk(sys);

figure
step(sys)

figure

rlocus(sys)

% x0=[1 0 1 0];
% figure
% initial(sys,x0)

%%
%Closed Loop
Kd=10;
Bd=-0.05;

Ac=[0 1 0 0;
    -Ksea/m2 -D/m2 Ksea/m2 0;
    0 0 0 1;
    Ksea/m1-Kd/m1 -Bd/m1 -Ksea/m1 -B/m1];

Bc=[0;
    0;
    0;
    Kd/m1];
%The poles in the rhp are coming from the damping term!?!?!

Cc=[0 1 0 0];

Dc=[0];

sys2=ss(Ac,Bc,C1,D1)

figure
bode(sys2)
grid minor
figure
pzmap(sys2)
tr2=zpk(sys2);

x0=[1 0 1 0];
figure
initial(sys2,x0)
