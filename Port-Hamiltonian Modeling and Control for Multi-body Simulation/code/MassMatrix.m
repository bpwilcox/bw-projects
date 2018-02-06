clear all

syms  a b c d e f qt1 qt2 qx1 qx2 qy1 qy2  pt1 pt2 px1 px2 py1 py2 T T2 Fx Fy t1dot t2dot x1dot x2dot y1dot y2dot g k m1 m2 F1 F2 n1 n2 I1 I2 t1 t2 r1 r2 l1 q1 q2 qd1 qd2;

a=-r1*sin(t1);
b = r1*cos(t1);
c = -(l1*sin(t1)+r2*sin(t1+t2));
d=-r2*sin(t1+t2);
e=(l1*cos(t1)+r2*cos(t1+t2));
f=r2*cos(t1+t2);


q=[q1;q2];
qd=[qd1;qd2];

Kp = [60 0;0 40];

K = 1/2*(q-qd).'*Kp*(q-qd);
dK1=diff(K,q1);
dK2=diff(K,q2);
V1= m1*g*r1*sin(t1);
V2=m2*g*(l1*sin(t1)+r2*sin(t1+t2));

L1=diff(-V1-V2,t1);
L2=diff(-V2-V1,t2);

% zdot = [t1dot;t2dot];
A = [1 0;a 0;b 0;1 1;c d;e f];
% % 
% R1 = [cos(t1) -sin(t1);sin(t1) cos(t1)];
% R2 = [cos(t1+t2) -sin(t1+t2);sin(t1+t2) cos(t1+t2)];
% 
% 
% Jv1 = [a 0;b 0];
% Jv2 = [c d;e f];
% Jw1 = [0 0;1 0];
% Jw2 = [0 0;1 1];
% 
% % M = m1*Jv1.'*Jv1 + m2*Jv2.'*Jv2 + Jw1.'*I1*Jw1+Jw2.'*I2*Jw2;
% 
%  K1 = diff(inv(M),t1);
%  K2 = diff(inv(M),t2);
% 
% 

% 
M = [I1 0 0 0 0 0;0 m1 0 0 0 0;0 0 m1 0 0 0;0 0 0 I2 0 0;0 0 0 0 m2 0;0 0 0 0 0 m2];
Mnew = A.'*M*A;

% dM1 = diff(Mnew,t1);
% dM2 = diff(Mnew,t2);
% % p = Mnew*zdot;
% % T = 1/2*p.'*inv(Mnew)*p;
% % Tcheck = 1/2*zdot.'*R.'*M*R*zdot;
% % 
% % 
% S1 = diff(inv(Mnew),t1);
% S2 = diff(inv(Mnew),t2);
% 
% ptry = [pt1 px1 py2 pt2 px2 py2];
% 
% V = [m1*g*-a, m2*g*-c];
% dV1 = diff(V,t1);
% dV2 = diff(V,t2);
% 
% 
a1 = m1*r1^2 + m2*l1^2+I1;
a2 = m2*r2^2+I2;
b1 = m2*l1*r2;

Mass = [a1+a2+2*b1*cos(t2), a2+b1*cos(t2);a2+b1*cos(t2), a2];
% K1 = diff(inv(Mass),t1);
% K2 = diff(inv(Mass),t2);
S1=diff(Mass*qd,t1)*qd.';
S2=diff(Mass*qd,t2)*qd.';

N1=1/2*diff(qd.'*Mass*qd,t1);
N2=1/2*diff(qd.'*Mass*qd,t2);

P=1/2*qd.'*diff(Mass,t2)*qd;
Y2=diff(Mass,t2);
Y1=diff(Mass,t1);
