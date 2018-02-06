clear all
close all

set = 'b';
trial=2;
load(strcat('Take_',set,num2str(trial)));
ArmParameters;

for i=1:length(Ac)
a=-r1*sin(Qc(i,1));
b = r1*cos(Qc(i,1));
c = -(l1*sin(Qc(i,1))+r2*sin(Qc(i,1)+Qc(i,4)));
d=-r2*sin(Qc(i,1)+Qc(i,4));
e=(l1*cos(Qc(i,1))+r2*cos(Qc(i,1)+Qc(i,4)));
f=r2*cos(Qc(i,1)+Qc(i,4));

R = [1 0;a 0;b 0;0 1;c d;e f];
M = [I1 0 0 0 0 0;0 m1 0 0 0 0;0 0 m1 0 0 0;0 0 0 I2 0 0;0 0 0 0 m2 0;0 0 0 0 0 m2];
Mnew = R.'*M*R;

t1=Qc(i,1);
t2=Qc(i,4);
G1(i)=g*m1*r1*cos(t1)+g*m2*(r2*cos(t1 + t2) + l1*cos(t1));
G2(i)=g*m2*r2*cos(t1 + t2);

Qe = [G1(i) 0  0 G2(i) 0 0].';

Cq = [a -1 0 0 0 0;b 0 -1 0 0 0; c 0 0 d -1 0;e 0 0 f 0 -1];
Cqt=Cq.';
[Q,R] = qr(Cqt);

Q1=Q(:,[1:4]); 
Q2=Q(:,[5:6]);

R1=R([1:4],[1:4]);

B=Q2.';

J= [Cqt B.'];
F = inv(J)*(Qe-M*Ac(i,:).');
f1(i)=F(1);
f2(i)=F(2);
f3(i)=F(3);
f4(i)=F(4);
f5(i)=F(5);
f6(i)=F(6);

% 
% Fc=Cqt*[f1(i) f2(i) f3(i)].';
% Ff=Cqt*[f4(i) f5(i) f6(i)].';
end

f1=f1.';
f2=f2.';
f3=f3.';
f4=f4.';
f5=f5.';
f6=f6.';
L=[f1 f2 f3 f4 f5 f6];
