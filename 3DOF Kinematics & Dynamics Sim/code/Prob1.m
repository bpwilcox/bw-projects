%% ECE 285 Assignment 1 
addpath rvctools
startup_rvc
close all
clear all
%% Problem 1

%% c) create robot

%Parameters
l1 = 0.5;
l2 = 0.5;
l3 = 0.2;

l = [l1 l2 l3];
%Angle Configuration
th1 = pi/3;
th2 = pi/2;
th3 = 0;
Th = [th1 th2 th3]


% L0 = Link('d', 0, 'a', 0, 'alpha', 0)
L1 = Link('d', 0, 'a', l1, 'alpha', 0);
L2 = Link('d', 0, 'a', l2, 'alpha', 0);
L3 = Link('d', 0, 'a', l3, 'alpha', 0);
bot = SerialLink([L1 L2 L3], 'name', 'my robot')
bot.fkine(Th)
% bot.plot([th1 th2 th3])


% S = fkin(Th,l);
% X = l1*cos(th1) + l2*cos(th1+th2) + l3*cos(th1+th2+th3)
% Y = l1*sin(th1) + l2*sin(th1+th2) + l3*sin(th1+th2+th3)
% o = th1 + th2 + th3

%% e) simple control

% Cartesian trajectory
P1 = [1.2 0 0];
P2 = [0.5 0.5 0];
P3 = [0.5 -0.5 0];
P4 = [0.4 0 0];


T1 = transl(P1);
T2 = transl(P2);
T3 = transl(P3);
T4 = transl(P4);


C12 = ctraj(T1,T2,50);
C23 = ctraj(T2,T3,50);
C34 = ctraj(T3,T4,50);
C41 = ctraj(T4,T1,50);


% inverse kinematics
M = [1 1 0 0 0 1];
% Q0 =[0 0 0];
Q0 = randn(1,3)*0.0001;

q1 = bot.ikine(T1,Q0,'pinv',M);


q12 = bot.ikunc(C12,q1);
q23 = bot.ikunc(C23,q12(end,:));
q34 = bot.ikunc(C34,q23(end,:));
q41 = bot.ikunc(C41,q34(end,:));

% animation
% bot.plot([q12;q23;q34;q41],'trail','-','movie','newmovie')
bot.plot([q12;q23;q34;q41],'trail','-')





 




