%Based heavily on Professor Neville Hogan’s 2.183j Course notes “Skeletal Configuration Modulates Interactive
%Dynamics”
%syms m2 I2 m3 I3 m4 I4 m5 I5 m6 I6 m7 I7
%lower shoulder
m2=3.226980;
I2=0.02078749298;
m2=[m2 0 0;0 m2 0;0 0 I2];
%upper elbow
m3=4.312720;
I3=0.02661733557;
m3=[m3 0 0;0 m3 0; 0 0 I3];
%lower elbow
m4=2.072060;
I4=0.00926852064;
m4=[m4 0 0;0 m4 0; 0 0 I4];
%upper forearm
m5=2.246650;
I5=0.01667742825;
m5=[m5 0 0;0 m5 0; 0 0 I5];
%lower forearm
m6=1.609790;
I6=0.0055275524;
m6=[m6 0 0;0 m6 0; 0 0 I6];
%wrist/hand
m7=0.350930+0.191250;
I7=0.00025289155;
m7=[m7 0 0;0 m7 0; 0 0 I7];
Z=zeros(3);
M=[m2 Z Z Z Z Z;Z m3 Z Z Z Z;Z Z m4 Z Z Z;Z Z Z m5 Z Z; Z Z Z Z m6 Z;Z Z Z Z Z m7];
x1=0; %m shoulder offset
y1=0; %m should offset
l1=0.438809; %m link length 1
l2=0.37442; %m link length 2
l3=0.229525; %m link length 3
rc1=0.06845;
rc2=0.18086;
rc3=0.02611;
rc4=0.13952;
rc5=0.06041;
rc6=0.19;
phi1=atan(69/433.809); %angle offset from joint 1 to joint 2
phi2=atan(10/374.29); %angle offset form joint 2 to to joint 3
syms q1 q2 q3 theta1 theta2 theta3 beta1 beta2 beta3 real %angles commanded on baxter
%syms x1 y1 l1 l2 l3 rc1 rc2 rc3 rc4 rc5 rc6 phi1 phi2 real
%absolute angles for forward kinematics
%theta1=beta1-phi1;
%theta2=beta2-phi2;
%theta3=beta3;
%forward kinematics
x2=x1+l1*cos(theta1);
y2=y1+l1*sin(theta1);
x3=x2+l2*cos(theta2);
y3=y2+l2*sin(theta2);
x4=x3+l3*cos(theta3);
y4=y3+l3*sin(theta3);
%Endpoint Vector Array
xu=[x4 y4 theta3];
th=[theta1 theta2 theta3];
jj=jacobian(xu,th);
jj=subs(jj,[theta1 theta2 theta3], [(q1+phi1) (q1+phi1+q2+phi2) (q1+phi1+q2+phi2+q3)]);
xc1=x1+rc1*cos(beta1);
yc1=y1+rc1*sin(beta1);
xc2=x1+rc2*cos(beta1);
yc2=y1+rc2*sin(beta1);
xc3=x1+l1*cos(beta1+phi1)+rc3*cos(beta2);
yc3=y1+l1*sin(beta1+phi1)+rc3*sin(beta2);
xc4=x1+l1*cos(beta1+phi1)+rc4*cos(beta2);
yc4=y1+l1*sin(beta1+phi1)+rc4*sin(beta2);
xc5=x1+l1*cos(beta1+phi1)+l2*cos(beta2+phi2)+rc5*cos(beta3);
yc5=y1+l1*sin(beta1+phi1)+l2*sin(beta2+phi2)+rc5*sin(beta3);
xc6=x1+l1*cos(beta1+phi1)+l2*cos(beta2+phi2)+rc6*cos(beta3);
yc6=y1+l1*sin(beta1+phi1)+l2*sin(beta2+phi2)+rc6*sin(beta3);
%Uncoupled Coordinate Vector Array
uc=[xc1 yc1 beta1 xc2 yc2 beta1 xc3 yc3 beta2 xc4 yc4 beta2 xc5 yc5 beta3 xc6 yc6 beta3];
%Generalized coordinate vecotr
be=[beta1 beta2 beta3];
j=jacobian(uc,be);
JSIM=j'*M*j;
JSIM=subs(JSIM,[beta1 beta2 beta3], [q1 (q1+q2+phi1) (q1+phi1+q2+phi2+q3)])

%Linearized model of Baxter constrained to planar motion: only joints S0, E1, and
%W1 can move
Ir1=0.044; %kgm^2
Ir2=0.6; %kgm^2
Ir3=Ir2;

Ir=[Ir1 0 0;
    0 Ir2 0;
    0 0 Ir3];

CIM=inv(jj*inv(JSIM+Ir)*transpose(jj));
q1=0.659; %rad
q2=2.06; %rad
q3=-1.34; %rad

CIM=eval(CIM)
jj=eval(jj)
JSIM=simplify(JSIM)
JSIM_r=eval(JSIM)

