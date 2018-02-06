clear all
close all

set = 'b';
trial=2;
load(strcat('Take_',set,num2str(trial)));
ArmParameters;



u1=zeros(length(Ac),1);
u2=zeros(length(Ac),1);
p1=zeros(length(Vq),1);
p2=zeros(length(Vq),1);


% h =0.01;


% for i=1:length(Aq)
% %Mass matrix from Paper interated every step. Remove comment to execute.
% %Mass = [a1+a2+2*b1*cos(X(i,3)), a2+b1*cos(X(i,3));a2+b1*cos(X(i,3)), a2]; 
% 
% %Mass matrix from model iterated every step
% a=-r1*sin(Qc(i+2,1));
% b = r1*cos(Qc(i+2,1));
% c = -(l1*sin(Qc(i+2,1))+r2*sin(Qc(i+2,1)+Qc(i+2,4)));
% d=-r2*sin(Qc(i+2,1)+Qc(i+2,4));
% e=(l1*cos(Qc(i+2,1))+r2*cos(Qc(i+2,1)+Qc(i+2,4)));
% f=r2*cos(Qc(i+2,1)+Qc(i+2,4));
% 
% R = [1 0;a 0;b 0;1 1;c d;e f];
% M = [I1 0 0 0 0 0;0 m1 0 0 0 0;0 0 m1 0 0 0;0 0 0 I2 0 0;0 0 0 0 m2 0;0 0 0 0 0 m2];
% Mnew = R.'*M*R;
% 
% 
% 
% p=Mnew*[Vq(i+1,1);Vq(i+1,4)];
% p1(i)=p(1);
% p2(i)=p(2);
% end
% p=[p1,p2];
% h=0.01;
% pdot=diff(p)/h;

for n=1:length(Aq)
%     a=-r1*sin(Qc(n+2,1));
% b = r1*cos(Qc(n+2,1));
% c = -(l1*sin(Qc(n+2,1))+r2*sin(Qc(n+2,1)+Qc(n+2,4)));
% d=-r2*sin(Qc(n+2,1)+Qc(n+2,4));
% e=(l1*cos(Qc(n+2,1))+r2*cos(Qc(n+2,1)+Qc(n+2,4)));
% f=r2*cos(Qc(n+2,1)+Qc(n+2,4));
% 
% R = [1 0;a 0;b 0;1 1;c d;e f];
% M = [I1 0 0 0 0 0;0 m1 0 0 0 0;0 0 m1 0 0 0;0 0 0 I2 0 0;0 0 0 0 m2 0;0 0 0 0 0 m2];
% Mnew = R.'*M*R;

a1 = m1*r1^2 + m2*l1^2+I1;
a2 = m2*r2^2+I2;
b1 = m2*l1*r2;


Mass = [a1+a2+2*b1*cos(Qc(n+2,4)), a2+b1*cos(Qc(n+2,4));a2+b1*cos(Qc(n+2,4)), a2];
    
dMass= [-2*b1*sin(Qc(n+2,4))*Vq(n+1,4), -b1*sin(Qc(n+2,4))*Vq(n+1,4); -b1*sin(Qc(n+2,4))*Vq(n+1,4),0];



p=Mass*[Vq(n+1,1);Vq(n+1,4)];
p1(n)=p(1);
p2(n)=p(2);
% pdot=Mass*[Aq(n,1);Aq(n,4)]+dMass*[Vq(n+1,1);Vq(n+1,4)];
 pdot=Mass*[Aq(n,1);Aq(n,4)];
% pdot=Mnew*[Ac(n,1);Ac(n,4)];
pd1(n)=pdot(1);
pd2(n)=pdot(2);
    
end
p=[p1,p2];
pdotcomp=[pd1.', pd2.'];

for j=1:length(Qc)-2
t1=Qc(j+2,1);
t2=Qc(j+2,4);

% S1 =[0 0; 0 0];
% S2 = [-((m2*r2^2*cos(t1 + t2)^2 + m2*r2^2*sin(t1 + t2)^2 + I2)*(2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)^2 - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*sin(t1) - 2*I2*l1*m2*r2*sin(t1 + t2)*cos(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)^2*cos(t1)*sin(t1) + 2*l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)*sin(t1)))/(I1*I2 + I1*m2*r2^2*sin(t1 + t2)^2 + I2*m2*r2^2*sin(t1 + t2)^2 + I2*l1^2*m2*cos(t1)^2 + I2*m1*r1^2*cos(t1)^2 + I2*l1^2*m2*sin(t1)^2 + I2*m1*r1^2*sin(t1)^2 + I1*m2*r2^2*cos(t1 + t2)^2 + I2*m2*r2^2*cos(t1 + t2)^2 + l1^2*m2^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*I2*l1*m2*r2*sin(t1 + t2)*sin(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)*sin(t1))^2,((m2*r2^2*cos(t1 + t2)^2 + m2*r2^2*sin(t1 + t2)^2 + l1*m2*cos(t1)*r2*cos(t1 + t2) + l1*m2*sin(t1)*r2*sin(t1 + t2))*(2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)^2 - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*sin(t1) - 2*I2*l1*m2*r2*sin(t1 + t2)*cos(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)^2*cos(t1)*sin(t1) + 2*l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)*sin(t1)))/(I1*I2 + I1*m2*r2^2*sin(t1 + t2)^2 + I2*m2*r2^2*sin(t1 + t2)^2 + I2*l1^2*m2*cos(t1)^2 + I2*m1*r1^2*cos(t1)^2 + I2*l1^2*m2*sin(t1)^2 + I2*m1*r1^2*sin(t1)^2 + I1*m2*r2^2*cos(t1 + t2)^2 + I2*m2*r2^2*cos(t1 + t2)^2 + l1^2*m2^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*I2*l1*m2*r2*sin(t1 + t2)*sin(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)*sin(t1))^2 - (l1*m2*r2*cos(t1 + t2)*sin(t1) - l1*m2*r2*sin(t1 + t2)*cos(t1))/(I1*I2 + I1*m2*r2^2*sin(t1 + t2)^2 + I2*m2*r2^2*sin(t1 + t2)^2 + I2*l1^2*m2*cos(t1)^2 + I2*m1*r1^2*cos(t1)^2 + I2*l1^2*m2*sin(t1)^2 + I2*m1*r1^2*sin(t1)^2 + I1*m2*r2^2*cos(t1 + t2)^2 + I2*m2*r2^2*cos(t1 + t2)^2 + l1^2*m2^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*I2*l1*m2*r2*sin(t1 + t2)*sin(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)*sin(t1));((m2*r2^2*cos(t1 + t2)^2 + m2*r2^2*sin(t1 + t2)^2 + l1*m2*cos(t1)*r2*cos(t1 + t2) + l1*m2*sin(t1)*r2*sin(t1 + t2))*(2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)^2 - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*sin(t1) - 2*I2*l1*m2*r2*sin(t1 + t2)*cos(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)^2*cos(t1)*sin(t1) + 2*l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)*sin(t1)))/(I1*I2 + I1*m2*r2^2*sin(t1 + t2)^2 + I2*m2*r2^2*sin(t1 + t2)^2 + I2*l1^2*m2*cos(t1)^2 + I2*m1*r1^2*cos(t1)^2 + I2*l1^2*m2*sin(t1)^2 + I2*m1*r1^2*sin(t1)^2 + I1*m2*r2^2*cos(t1 + t2)^2 + I2*m2*r2^2*cos(t1 + t2)^2 + l1^2*m2^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*I2*l1*m2*r2*sin(t1 + t2)*sin(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)*sin(t1))^2 - (l1*m2*r2*cos(t1 + t2)*sin(t1) - l1*m2*r2*sin(t1 + t2)*cos(t1))/(I1*I2 + I1*m2*r2^2*sin(t1 + t2)^2 + I2*m2*r2^2*sin(t1 + t2)^2 + I2*l1^2*m2*cos(t1)^2 + I2*m1*r1^2*cos(t1)^2 + I2*l1^2*m2*sin(t1)^2 + I2*m1*r1^2*sin(t1)^2 + I1*m2*r2^2*cos(t1 + t2)^2 + I2*m2*r2^2*cos(t1 + t2)^2 + l1^2*m2^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*I2*l1*m2*r2*sin(t1 + t2)*sin(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)*sin(t1)),(2*l1*m2*r2*cos(t1 + t2)*sin(t1) - 2*l1*m2*r2*sin(t1 + t2)*cos(t1))/(I1*I2 + I1*m2*r2^2*sin(t1 + t2)^2 + I2*m2*r2^2*sin(t1 + t2)^2 + I2*l1^2*m2*cos(t1)^2 + I2*m1*r1^2*cos(t1)^2 + I2*l1^2*m2*sin(t1)^2 + I2*m1*r1^2*sin(t1)^2 + I1*m2*r2^2*cos(t1 + t2)^2 + I2*m2*r2^2*cos(t1 + t2)^2 + l1^2*m2^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*I2*l1*m2*r2*sin(t1 + t2)*sin(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)*sin(t1)) - ((2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)^2 - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*sin(t1) - 2*I2*l1*m2*r2*sin(t1 + t2)*cos(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)^2*cos(t1)*sin(t1) + 2*l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)*sin(t1))*(I1 + m2*r2^2*cos(t1 + t2)^2 + m2*r2^2*sin(t1 + t2)^2 + l1^2*m2*cos(t1)^2 + m1*r1^2*cos(t1)^2 + l1^2*m2*sin(t1)^2 + m1*r1^2*sin(t1)^2 + 2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*l1*m2*r2*sin(t1 + t2)*sin(t1)))/(I1*I2 + I1*m2*r2^2*sin(t1 + t2)^2 + I2*m2*r2^2*sin(t1 + t2)^2 + I2*l1^2*m2*cos(t1)^2 + I2*m1*r1^2*cos(t1)^2 + I2*l1^2*m2*sin(t1)^2 + I2*m1*r1^2*sin(t1)^2 + I1*m2*r2^2*cos(t1 + t2)^2 + I2*m2*r2^2*cos(t1 + t2)^2 + l1^2*m2^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*I2*l1*m2*r2*sin(t1 + t2)*sin(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)*sin(t1))^2];

K1 = [0 0;0 0];
K2 = zeros(2,2);
K2(1)= -(2*l1^2*m2^2*r2^2*cos(t2)*sin(t2)*(m2*r2^2 + I2))/(- l1^2*m2^2*r2^2*cos(t2)^2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + m1*m2*r1^2*r2^2 + I1*m2*r2^2 + I2*m1*r1^2 + I1*I2)^2;
K2(2)=(l1*m2*r2*sin(t2))/(I1*I2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + I2*m1*r1^2 + I1*m2*r2^2 + m1*m2*r1^2*r2^2 - l1^2*m2^2*r2^2*cos(t2)^2) + (2*l1^2*m2^2*r2^2*cos(t2)*sin(t2)*(m2*r2^2 + l1*m2*cos(t2)*r2 + I2))/(- l1^2*m2^2*r2^2*cos(t2)^2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + m1*m2*r1^2*r2^2 + I1*m2*r2^2 + I2*m1*r1^2 + I1*I2)^2;
K2(3)=(l1*m2*r2*sin(t2))/(I1*I2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + I2*m1*r1^2 + I1*m2*r2^2 + m1*m2*r1^2*r2^2 - l1^2*m2^2*r2^2*cos(t2)^2) + (2*l1^2*m2^2*r2^2*cos(t2)*sin(t2)*(m2*r2^2 + l1*m2*cos(t2)*r2 + I2))/(- l1^2*m2^2*r2^2*cos(t2)^2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + m1*m2*r1^2*r2^2 + I1*m2*r2^2 + I2*m1*r1^2 + I1*I2)^2;
K2(4)=-(2*l1*m2*r2*sin(t2))/(I1*I2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + I2*m1*r1^2 + I1*m2*r2^2 + m1*m2*r1^2*r2^2 - l1^2*m2^2*r2^2*cos(t2)^2) - (2*l1^2*m2^2*r2^2*cos(t2)*sin(t2)*(m2*l1^2 + 2*m2*cos(t2)*l1*r2 + m1*r1^2 + m2*r2^2 + I1 + I2))/(- l1^2*m2^2*r2^2*cos(t2)^2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + m1*m2*r1^2*r2^2 + I1*m2*r2^2 + I2*m1*r1^2 + I1*I2)^2;

dH1 = -(1/2*[p1(j),p2(j)]*K1*[p1(j),p2(j)].'+ g*m1*r1*cos(t1)+g*m2*(r2*cos(t1 + t2) + l1*cos(t1)));
dH2 = -(1/2*[p1(j),p2(j)]*K2*[p1(j),p2(j)].'+ g*m2*r2*cos(t1 + t2));

% dH1 = -(1/2*[p1(j),p2(j)]*S1*[p1(j),p2(j)].');
% dH2 = -(1/2*[p1(j),p2(j)]*S2*[p1(j),p2(j)].');


G1(j)=g*m1*r1*cos(t1)+g*m2*(r2*cos(t1 + t2) + l1*cos(t1));
G2(j)=g*m2*r2*cos(t1 + t2);
u1(j) = pdotcomp(j,1)-dH1;
u2(j) = pdotcomp(j,2)-dH2;
% u1(j) = pdotcomp(j,1)+G1(j);
% u2(j) = pdotcomp(j,2)+G2(j);
end
G1=G1.';
G2=G2.';
U=[u1 u2];

save('inputs','U','Qc');
% H=u-pdot;




