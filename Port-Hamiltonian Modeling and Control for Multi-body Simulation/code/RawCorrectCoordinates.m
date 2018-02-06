clear all
close all

ArmParameters;

set = 'e';
trial=2;
load(strcat('Take_',set,num2str(trial)));


n1=t1*pi/180;
n2=t2*pi/180;
% 
% % l1=l1/1000;
% % l2=l2/1000;
% l1=0.29;    % measured from markers in data
% l2=0.29;    % measured from markers in data
% 
% r1=c1*l1;
% r2=c2*l2;

Qc = zeros(length(position)-1,6);
for i=1:length(position)-1


a=-l1*sin(n1(i));
b = l1*cos(n1(i));
c = -(l1*sin(n1(i))+l2*sin(n1(i)+n2(i)));
d=-l2*sin(n1(i)+n2(i));
e=(l1*cos(n1(i))+l2*cos(n1(i)+n2(i)));
f=l2*cos(n1(i)+n2(i));


A = [a -1 0 0 0 0;b 0 -1 0 0 0; c 0 0 d -1 0;e 0 0 f 0 -1];

C = [b-(position(i,2)-position(i,8))/1000;-a-(position(i,3)-position(i,9))/1000;e-(position(i,5)-position(i,8))/1000;-c-(position(i,6)-position(i,9))/1000];

Qi = [n1(i); position(i,2)/1000; position(i,3)/1000; n2(i); position(i,5)/1000; position(i,6)/1000];

Q = Qi-pinv(A)*C;

a=-l1*sin(Q(1));
b = l1*cos(Q(1));
c = -(l1*sin(Q(1))+l2*sin(Q(1)+Q(4)));
d=-l2*sin(Q(1)+Q(4));
e=(l1*cos(Q(1))+l2*cos(Q(1)+Q(4)));
f=l2*cos(Q(1)+Q(4));

A = [a -1 0 0 0 0;b 0 -1 0 0 0; c 0 0 d -1 0;e 0 0 f 0 -1];

C = [b-(Q(2)-position(i,8)/1000);-a-(Q(3)-position(i,9)/1000);e-(Q(5)-position(i,8)/1000);-c-(Q(6)-position(i,9)/1000)];

Q2 = Q-pinv(A)*C;

Qc(i,:)=Q2.';

end

save(strcat('Take_',set,num2str(trial)),'position','t','t1','t2','Qc');

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
