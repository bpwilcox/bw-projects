clear all

% for set = ['a','b','c','d','e']
%     

set='b';

% for i=1:3
    
trial=2;
load(strcat('Take_',set,num2str(trial),'.mat'));

[B,A]=butter(3,2/50);
filt = filtfilt(B,A,Qc);

h =0.001;

v1 = diff(filt(:,1))/h;
a1 = diff(v1)/h;
v2 =diff(filt(:,4))/h;
a2= diff(v2)/h;




save(strcat('Take_',set,num2str(trial)),'position','t','t1','t2','Qc','v1','a1','v2','a2');

% end
% end