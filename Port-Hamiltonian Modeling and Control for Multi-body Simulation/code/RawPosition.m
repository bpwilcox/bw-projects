clear all
close all

set = 'e';
trial=2;
load(strcat('Take_',set,num2str(trial)));


t = 1:length(position);
t=t/100;


t1=ones(length(position)-1,1);
t2=ones(length(position)-1,1);

j=1:length(position)-1;
X1=position(j,3)-position(j,9);
Y1=position(j,2)-position(j,8);
X2=position(j,6)-position(j,3);
Y2=position(j,5)-position(j,2);

t1 = atan2(X1,Y1)*180/pi;
t2 = atan2(X2,Y2)*180/pi-t1;

% for i=1:length(position)-1
%     
%    t1(i)=atan((position(i,3)-position(i,9))/(position(i,2)-position(i,8)))*180/pi;
%    
%    t2(i)= atan((position(i,6)-position(i,3))/(position(i,5)-position(i,2)))*180/pi-t1(i);
% 
% end


% %ratios
% c1=0.436;   % upper arm center of mass/segment length
% c2=0.682;   % forearm-hand center of mass/segment length
% 
% h =0.001;
% v1 = diff(t1)/h;
% v2 = diff(t2)/h;
% a1 = diff(v1)/h;
% a2 = diff(v2)/h;

save(strcat('Take_',set,num2str(trial)),'position','t','t1','t2');


subplot(1,2,1)
plot(t(1:length(position)-1),t1)
subplot(1,2,2)
plot(t(1:length(position)-1),t2)

