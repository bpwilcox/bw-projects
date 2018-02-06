clear all
close all

set = 'a';
trial=3;
load(strcat('filtTake_',set,num2str(trial)));

% plot(filt(700,1)/1000,filt(700,3)/1000,'o')
% hold on
% plot(filt(700,4)/1000,filt(700,6)/1000,'o')
% hold on
% plot(filt(700,7)/1000,filt(700,9)/1000,'o')
% 



% t1=atan(filt(1,3)/filt(1,1))*180/pi
% t2 =atan(filt(1,6)/filt(1,4))*180/pi
% t3 =atan(filt(1,9)/filt(1,7))*180/pi
t1=ones(length(filt)-1,1);
t2=ones(length(filt)-1,1);
arm1=ones(length(filt)-1,1);
arm2=ones(length(filt)-1,1);
arm3=ones(length(filt)-1,1);
for i=1:length(filt)-1
    
   t1(i)=atan((filt(i,3)-filt(i,9))/(filt(i,2)-filt(i,8)))*180/pi;
   
   t2(i)= atan((filt(i,6)-filt(i,3))/(filt(i,5)-filt(i,2)))*180/pi-t1(i);

   arm1(i)=sqrt((filt(i,3)-filt(i,9))^2 + (filt(i,2)-filt(i,8))^2); 
   arm2(i)=sqrt((filt(i,6)-filt(i,3))^2 + (filt(i,5)-filt(i,2))^2);
   %arm3(i)=sqrt((filt(i,6)-filt(i,9))^2 + (filt(i,4)-filt(i,7))^2);
end


%ratios
c1=0.436;   % upper arm center of mass/segment length
c2=0.682;   % forearm-hand center of mass/segment length

l1=sum(arm1)/length(arm1);    % measured from markers in data
l2=sum(arm2)/length(arm2);    % measured from markers in data

r1=c1*l1;
r2=c2*l2;


h =0.001;
v1 = diff(t1)/h;
v2 = diff(t2)/h;
a1 = diff(v1)/h;
a2 = diff(v2)/h;

save(strcat('filtTake_',set,num2str(trial)),'filt','vel','accel','t','t1','t2','v1','v2','a1','a2','l1','l2','r1','r2');


subplot(2,2,1)
plot(t(1:length(filt)-1),t1)
subplot(2,2,2)
plot(t(1:length(filt)-1),t2)
% subplot(2,2,3)
% plot(t(1:length(filt)-1),arm1)
% subplot(2,2,4)
% plot(t(1:length(filt)-1),arm2)


