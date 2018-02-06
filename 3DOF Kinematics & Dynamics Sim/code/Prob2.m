%% ECE 285 Assignment 1 
addpath rvctools
startup_rvc
close all
clear all
%% Problem 2

% b)
%% Set up Symbolic definitions

% Angles
q1 = sym('q1');
q2 = sym('q2');
q3 = sym('q3');
q = [q1 q2 q3];

% Angular Velocities
qd1 = sym('qd1');
qd2 = sym('qd2');
qd3 = sym('qd3');
qd = [qd1 qd2 qd3];

% Angular Accelerations

qdd1 = sym('qdd1');
qdd2 = sym('qdd2');
qdd3 = sym('qdd3');
qdd = [qdd1 qdd2 qdd3];

% Lengths
l1 = sym(0);
l2 = sym('l2');
l3 = sym('l3');
l = [l1 l2 l3];

% Masses
m1 = sym(0);
m2 = sym('m2');
m3 = sym('m3');
mp = sym('mp'); % payload
m = [m1 m2 m3];

% Radii
r1 = sym('r1');
r2 = sym('r2');
r3 = sym('r3');
r = [r1 r2 r3];

I1 = sym(zeros(3,3)); % link inertia
I2 = [sym((1/12))*m2*(3*r2^2+l2^2) 0 0;0 sym((1/12))*m2*(3*r2^2+l2^2) 0;0 0 sym((1/2))*m2*r2^2];
I3 = [(1/12)*m3*(3*r3^2+l3^2) 0 0;0 (1/12)*m3*(3*r3^2+l3^2) 0;0 0 (1/2)*m3*r3^2];

%% Set Parameter Values

% Link radius
R = [0.1 0.02 0.02];

% Link length
L = [0 0.2 0.2];

% Link Volumes
v1 = pi*R(1)^2*L(1); 
v2 = pi*R(2)^2*L(2);
v3 = pi*R(3)^2*L(3);

% Link Mass
p = 10^4; % density
M = [p*v1 p*v2 p*v3];
Mp = 0;
% Link Inertia 

I1_p = zeros(3,3); % link inertia
I2_p = [(1/12)*M(2)*(3*R(2)^2+L(2)^2) 0 0;0 (1/12)*M(2)*(3*R(2)^2+L(2)^2) 0;0 0 (1/2)*M(2)*R(2)^2];
I3_p = [(1/12)*M(3)*(3*R(3)^2+L(3)^2) 0 0;0 (1/12)*M(3)*(3*R(3)^2+L(3)^2) 0;0 0 (1/2)*M(3)*R(3)^2];
% I3_p = I2_p;

I(:,:,1) = I1_p;
I(:,:,2) = I2_p;
I(:,:,3) = I3_p;

% gravity
g = sym('g');

%% Construct Robot Model


L1_sym = Link('d', 0, 'a', l1, 'alpha', sym(-pi/2),'m',m1,'I',I1,'r',[-l1/sym(2) 0 0].');
L2_sym = Link('d', 0, 'a', l2, 'alpha', 0,'m',m2,'I',I2,'r',[-l2/sym(2) 0 0].');
L3_sym = Link('d', 0, 'a', l3, 'alpha', 0,'m',m3,'I',I3,'r',[-l3/sym(2) 0 0].');

L1 = Link('d', 0, 'a', L(1), 'alpha', -pi/2,'m',M(1),'I',I(:,:,1),'r',[-L(1)/2 0 0].');
L2 = Link('d', 0, 'a', L(2), 'alpha', 0,'m',M(2),'I',I(:,:,2),'r',[-L(2)/2 0 0].');
L3 = Link('d', 0, 'a', L(3), 'alpha', 0,'m',M(3),'I',I(:,:,3),'r',[-L(3)/2 0 0].');

symbot = SerialLink([L1_sym L2_sym L3_sym], 'name', 'my robot');
bot = SerialLink([L1 L2 L3], 'name', 'my robot');


%% Calculate Dynamics Equations

% Return symbolic Inertia matrix, Coriolis matrix, and gravity terms vector
[Dsym,Gsym,Csym] = dyneq(q(1),q(2),q(3));

%% From part b)

Th1b = [pi/3 pi/2 pi/3];
Th2b = [pi/3 pi/2 pi/3];
Th3b = [0 pi/2 0];

dTh1b = [0 0 0];
dTh2b = [pi/4 pi/4 pi/2];
dTh3b = [pi/4 pi/4 pi/2];

% 
D1b = double(subs(Dsym,[q m mp l r],[Th1b M Mp L R]));
D2b = double(subs(Dsym,[q m mp l r],[Th2b M Mp L R]));
D3b = double(subs(Dsym,[q m mp l r],[Th3b M Mp L R]));

C1b = double(subs(Csym,[q qd m mp l],[Th1b dTh1b M Mp L]));
C2b = double(subs(Csym,[q qd m mp l],[Th2b dTh2b M Mp L]));
C3b = double(subs(Csym,[q qd m mp l],[Th3b dTh3b M Mp L]));

G1b = double(subs(Gsym,[q m mp l g],[Th1b M Mp L 9.81]));
G2b = double(subs(Gsym,[q m mp l g],[Th2b M Mp L 9.81]));
G3b = double(subs(Gsym,[q m mp l g],[Th3b M Mp L 9.81]));

%% From part c)

Th1c = [0 0 pi/2];
Th2c = [pi/2 pi/2 pi/4];
Th3c = [pi/3 pi/2 0];
dThc = [0 0 0]; %i.e. held in place
ddThc = [0 0 0]; %i.e. held in place

D1c = double(subs(Dsym,[q m mp l r],[Th1c M Mp L R]));
D2c = double(subs(Dsym,[q m mp l r],[Th2c M Mp L R]));
D3c = double(subs(Dsym,[q m mp l r],[Th3c M Mp L R]));

C1c = double(subs(Csym,[q qd m mp l],[Th1c dThc M Mp L]));
C2c = double(subs(Csym,[q qd m mp l],[Th2c dThc M Mp L]));
C3c = double(subs(Csym,[q qd m mp l],[Th3c dThc M Mp L]));

G1c = double(subs(Gsym,[q m mp l g],[Th1c M Mp L 9.81]));
G2c = double(subs(Gsym,[q m mp l g],[Th2c M Mp L 9.81]));
G3c = double(subs(Gsym,[q m mp l g],[Th3c M Mp L 9.81]));

Tau1 = D1c*ddThc.'+C1c*dThc.'+G1c;
Tau2 = D2c*ddThc.'+C2c*dThc.'+G2c;
Tau3 = D3c*ddThc.'+C3c*dThc.'+G3c;


%% part d)
Mp=0;
Thd = [0 -pi/6 pi/3];
q0 = Thd;
qd0 = [0 0 0];

% %without gravity compensation
[t Qwog Qd] = bot.fdyn(5,[],q0,qd0);
% bot.plot(Qwog,'movie','nogravcomp')

% %with gravity compensation
[t Qwg Qd] = bot.fdyn(5,@taufun,q0,qd0,Dsym,Csym,Gsym,M,Mp,L,R,m,mp,l,r,q,qd);
% bot.plot(Qwg,'movie','gravcomp')
%% part e)

Mp = 3;

% De = double(subs(Dsym,[q m mp l r],[q0 M Mp L R]));
% Ce = double(subs(Csym,[q qd m mp l],[q0 qd0 M Mp L]));
% Ge = double(subs(Gsym,[q m mp l g],[q0 M Mp L 9.81]));
% Te = De*[0 0 0].'+Ce*qd0.'+Ge;


% L4_sym = Link('d', 0, 'a', 0, 'alpha',0 ,'I', I3);
% symbot2 = SerialLink([L1_sym L2_sym L3_sym L4_sym], 'name', 'my robot');
% symbot2.payload(sym('mp'),[0 0 0])

% Create another link to add point mass
L4 = Link('d', 0, 'a', 0, 'alpha',0 ,'I', I(:,:,3));
L4.I = ones(3,3)*1E-8;

bot2 = SerialLink([L1 L2 L3 L4], 'name', 'my robot');
bot2.payload(Mp,[0 0 0])

% without load compensation
Mp = 0;
T =  linspace(0 ,5,200);
[t Qnmp Qd] = bot2.fdyn(T(2:end),@taufun,[q0 0],[qd0 0],Dsym,Csym,Gsym,M,Mp,L,R,m,mp,l,r,q,qd);
% bot2.plot(Qnmp,'movie','noloadcomp')

% with load compensation
Mp = 3;
[t Qmp Qd] = bot2.fdyn(T(2:end),@taufun,[q0 0],[qd0 0],Dsym,Csym,Gsym,M,Mp,L,R,m,mp,l,r,q,qd);
% bot2.plot(Qmp,'movie','loadcomp')

%% part f) Create trajectory

P1 = [0.2 0.2 0];
P2 = [0.1 0.2 0];
P3 = [0.1 -0.2 0];
P4 = [0.2 -0.2 0];


T1 = transl(P1);
T2 = transl(P2);
T3 = transl(P3);
T4 = transl(P4);

n = 50;

C12 = ctraj(T1,T2,n);
C23 = ctraj(T2,T3,n);
C34 = ctraj(T3,T4,n);
C41 = ctraj(T4,T1,n);




% inverse kinematics
Mk = [1 1 1 0 0 0];
Q0 = randn(1,3)*0.0001;

q1 = bot.ikunc(T1,Q0);

% % 
q12 = bot.ikine(C12,q1,Mk);
q23 = bot.ikine(C23,q12(end,:),Mk);
q34 = bot.ikine(C34,q23(end,:),Mk);
q41 = bot.ikine(C41,q34(end,:),Mk);

Qref = [q12;q23;q34;q41];
Qref = [Qref zeros(length(Qref),1)];



%% Forward dynamics & control for trajectory
tref = linspace(0 ,8,length(Qref))';
T = linspace(0 ,2,200);
Mp = 3;
[t Q Qd] = bot2.nofriction.fdyn(T(2:end),@taufun2,Qref(1,:),[qd0 0],Dsym,Csym,Gsym,M,Mp,L,R,m,mp,l,r,q,qd,Qref,tref);

% bot2.plot(Q,'movie','trajcontrol')



