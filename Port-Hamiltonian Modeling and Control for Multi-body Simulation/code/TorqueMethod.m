clear all
close all

set = 'a';
trial=3;
load(strcat('Take_',set,num2str(trial)));
ArmParameters;



U1=zeros(length(Ac),2);
Q=zeros(length(Ac),2);

for i=1:length(Ac)
%Mass matrix from Paper interated every step. Remove comment to execute.
%Mass = [a1+a2+2*b1*cos(X(i,3)), a2+b1*cos(X(i,3));a2+b1*cos(X(i,3)), a2]; 

%Mass matrix from model iterated every step
a=-r1*sin(Qc(i+2,1));
b = r1*cos(Qc(i+2,1));
c = -(l1*sin(Qc(i+2,1))+r2*sin(Qc(i+2,1)+Qc(i+2,4)));
d=-r2*sin(Qc(i+2,1)+Qc(i+2,4));
e=(l1*cos(Qc(i+2,1))+r2*cos(Qc(i+2,1)+Qc(i+2,4)));
f=r2*cos(Qc(i+2,1)+Qc(i+2,4));

R = [1 0;a 0;b 0;1 1;c d;e f];
M = [I1 0 0 0 0 0;0 m1 0 0 0 0;0 0 m1 0 0 0;0 0 0 I2 0 0;0 0 0 0 m2 0;0 0 0 0 0 m2];
Mnew = R.'*M*R;

da=-b*Vc(i+1,1);
db=-a*Vc(i+1,1);
dc=-(e*Vc(i+1,1)+r2*cos(Qc(i+2,1)+Qc(i+2,4))*Vc(i+1,4));
dd=-(f*Vc(i+1,1)+f*Vc(i+1,4));
de=-(c*Vc(i+1,1)+r2*sin(Qc(i+2,1)+Qc(i+2,4))*Vc(i+1,4));
df=-(d*Vc(i+1,1)+d*Vc(i+1,4));
dR=[0 0;da 0;db 0;0 0;dc dd;de df];

G1=g*m1*r1*cos(Qc(i+2,1))+g*m2*(r2*cos(Qc(i+2,1) + Qc(i+2,4)) + l1*cos(Qc(i+2,1)));
G2=g*m2*r2*cos(Qc(i+2,1) + Qc(i+2,4));

Qo=[-G1; 0; 0; -G2; 0; 0];

U1(i,:)= Mnew*[Ac(i,1); Ac(i,4)]-R.'*(Qo-M*dR*[Vc(i+1,1); Vc(i+1,4)]);
% Qida(i,:)=R.'*(Qo-M*dR*[Vc(i+1,1); Vc(i+1,4)]);
% Q(i,:)=Mnew*[Ac(i,1); Ac(i,4)];
end



