clear all
close all

set = 'c';
trial=1;
load(strcat('filtTake_',set,num2str(trial)));
%  for i=[ 500]
% subplot(1,2,1)
% plot(filt(i,1)/1000,filt(i,3)/1000,'bo')
% hold on
% plot(filt(i,4)/1000,filt(i,6)/1000,'go')
% hold on
% plot(filt(i,7)/1000,filt(i,9)/1000,'ro')
% axis([-2 2 -2 2])
%  end
% 
%   for j=[1 500 814 ]
% 
% plot(filt(j,2)/1000,filt(j,3)/1000,'bo')
% hold on
% plot(filt(j,5)/1000,filt(j,6)/1000,'go')
% hold on
% plot(filt(j,8)/1000,filt(j,9)/1000,'ro')
% axis([-2 2 -2 2])
%  end
% 
% 
for i=1:length(filt)-1
  
   arm1(i)=sqrt((filt(i,3)-filt(i,9))^2 + (filt(i,2)-filt(i,8))^2); 
   arm2(i)=sqrt((filt(i,6)-filt(i,3))^2 + (filt(i,5)-filt(i,2))^2);
  
   arm1y(i)=sqrt((filt(i,3)-filt(i,9))^2 + (filt(i,2)-filt(i,8))^2 +(filt(i,1)-filt(i,7))^2 ); 
   arm2y(i)=sqrt((filt(i,6)-filt(i,3))^2 + (filt(i,4)-filt(i,1))^2 + (filt(i,5)-filt(i,2))^2);
%   
   A(i) = filt(i,3)-filt(i,9);
   B(i) = filt(i,1)-filt(i,7);
   C(i) = filt(i,2)-filt(i,8);
   
end

subplot(1,2,1)
plot(t(1:length(filt)-1),arm1)
subplot(1,2,2)
plot(t(1:length(filt)-1),arm1y)

% % subplot(2,2,3)
% % plot(t(1:length(filt)-1),B)
% % subplot(2,2,4)
% % plot(t(1:length(filt)-1),C)
% 
% % 
% % plot(filt(:,[1,4,7]),'DisplayName','filt(:,[1,4,7])')
% % hold on 
% % plot((1:length(filt)-1),B)
% 
