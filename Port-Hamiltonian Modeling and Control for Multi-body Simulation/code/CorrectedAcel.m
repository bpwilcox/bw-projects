clear all
close all

ArmParameters;

set = 'e';
trial=2;
load(strcat('Take_',set,num2str(trial)));
% [B,A]=butter(3,2/50);
% Qc = filtfilt(B,A,Qc);
h=0.01;
Aq = diff(Vc)/h;

for i=1:length(Aq)

a=-r1*sin(Qc(i,1));
b = r1*cos(Qc(i,1));
c = -(l1*sin(Qc(i,1))+r2*sin(Qc(i,1)+Qc(i,4)));
d=-r2*sin(Qc(i,1)+Qc(i,4));
e=(l1*cos(Qc(i,1))+r2*cos(Qc(i,1)+Qc(i,4)));
f=r2*cos(Qc(i,1)+Qc(i,4));


Cq = [a -1 0 0 0 0;b 0 -1 0 0 0; c 0 0 d -1 0;e 0 0 f 0 -1];

% C = [b-(position(i,2)-position(i,8))/1000;-a-(position(i,3)-position(i,9))/1000;e-(position(i,5)-position(i,8))/1000;-c-(position(i,6)-position(i,9))/1000];

% Qi = [n1(i); position(i,2)/1000; position(i,3)/1000; n2(i); position(i,5)/1000; position(i,6)/1000];

% Q = Qi-pinv(A)*C;

Ai= [Aq(i,1);Aq(i,2); Aq(i,3); Aq(i,4);Aq(i,5); Aq(i,6)];
A = Aq(i,:).'-pinv(Cq)*Cq*Ai;
% 
% a=-l1*sin(Qc(1));
% b = l1*cos(Qc(1));
% c = -(l1*sin(Qc(1))+l2*sin(Qc(1)+Qc(4)));
% d=-l2*sin(Qc(1)+Qc(4));
% e=(l1*cos(Qc(1))+l2*cos(Qc(1)+Qc(4)));
% f=l2*cos(Qc(1)+Qc(4));
% 
% % A = [a -1 0 0 0 0;b 0 -1 0 0 0; c 0 0 d -1 0;e 0 0 f 0 -1];
% % 
% % C = [b-(Q(2)-position(i,8)/1000);-a-(Q(3)-position(i,9)/1000);e-(Q(5)-position(i,8)/1000);-c-(Q(6)-position(i,9)/1000)];
% % 
% Ai= [A(1);A(2); A(3); A(4);A(5);A(6)];
% 
% A2 = A-pinv(A)*A*Ai;
% 
 Ac(i,:)=A.';

end

 save(strcat('Take_',set,num2str(trial)),'position','t','t1','t2','Qc','Vc','Vq','Ac','Aq');

% a=-l1*sin(Q2(1));
% b = l1*cos(Q2(1));
% c = -(l1*sin(Q2(1))+l2*sin(Q2(1)+Q2(4)));
% d=-l2*sin(Q2(1)+Q2(4));
% e=(l1*cos(Q2(1))+l2*cos(Q2(1)+Q2(4)));
% f=l2*cos(Q2(1)+Q2(4));
% 
% A = [a -1 0 0 0 0;b 0 -1 0 0 0; c 0 0 d -1 0;e 0 0 f 0 -1];
% 
% C = [b-Q2(2);-a-Q2(3);e-Q2(5);-c-Q2(6)];
% 
% Q3 = Q2-pinv(A)*C;
