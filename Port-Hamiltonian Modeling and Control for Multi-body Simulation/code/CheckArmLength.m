clear all
close all

set = 'c';
trial=1;
load(strcat('Take_',set,num2str(trial)));

% filt=Take_c1;

%  for i=[1   814]
% %  a = [filt(i,8)/1000,filt(i,2)/1000];
% %  
% %  c = [filt(i,9)/1000,filt(i,3)/1000];
% %  
% %  b = [filt(i,6)/1000,filt(i,3)/1000];
% %  d = [filt(i,5)/1000,filt(i,2)/1000];
% %  plot(a,c,'o-')
% %  
% % hold on 
% % plot (d,b,'o-')
% % axis equal
% 
% 
% 
% a = [filt(i,8)/1000, filt(i,2)/1000, filt(i,5)/1000];
% b = [filt(i,9)/1000, filt(i,3)/1000, filt(i,6)/1000]; 
% c = [filt(i,7)/1000, filt(i,1)/1000, filt(i,4)/1000];
% 
% plot3(a,c,b,'o-')
% % axis equal
% hold on



% axis([-2 2 -2 2])
%  hold on
%  plot(a,b)
% plot(filt(i,2)/1000,filt(i,3)/1000,'bo')
% hold on
% plot(filt(i,5)/1000,filt(i,6)/1000,'go')
% hold on
% % plot(filt(i,8)/1000,filt(i,9)/1000,'ro')
% 
%  end
% 



Take_b2=Take_c1;

for i=1:length(Take_b2)-1
 arm1(i)=sqrt((Take_b2(i,3)-Take_b2(i,9))^2 + (Take_b2(i,1)-Take_b2(i,7))^2+(Take_b2(i,2)-Take_b2(i,8))^2); 
 arm2(i)=sqrt((Take_b2(i,6)-Take_b2(i,3))^2 + (Take_b2(i,4)-Take_b2(i,1))^2+(Take_b2(i,5)-Take_b2(i,2))^2);

end
t=1:length(Take_b2);
t=t/100;
  subplot(1,2,1)
plot(t(1:length(Take_b2)-1),arm1)
subplot(1,2,2)
plot(t(1:length(Take_b2)-1),arm2)