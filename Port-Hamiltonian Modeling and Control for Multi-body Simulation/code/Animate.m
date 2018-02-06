clear all
close all

set = 'b';
trial=2;
load(strcat('filtTake_',set,num2str(trial)));

i =1;
a = [filt(i,8)/1000, filt(i,2)/1000, filt(i,5)/1000];
b = [filt(i,9)/1000, filt(i,3)/1000, filt(i,6)/1000];
c = [filt(i,7)/1000, filt(i,1)/1000, filt(i,4)/1000];



axis equal
hold on
h = plot3(a,b,c,'XDataSource','a','YDataSource','b','ZDataSource','c');
axis ([-0.5 0.5 0.5 1.8 -1 1])
% j = plot(d,b,'YDataSource','b');
for k = 1:length(filt)
a = [filt(k,8)/1000, filt(k,2)/1000, filt(k,5)/1000];
b = [filt(k,9)/1000, filt(k,3)/1000, filt(k,6)/1000]; 
c = [filt(k,7)/1000, filt(k,1)/1000, filt(k,4)/1000];
%  b = [filt(i,6)/1000,filt(i,3)/1000];
%  d = [filt(i,5)/1000,filt(i,2)/1000];
%  plot(a,c,'o-')
%  hold on 
% plot (d,b,'o-')

 
   refreshdata(h,'caller') 
   drawnow
end


%  a = [filt(i,8)/1000,filt(i,2)/1000];
%  c = [filt(i,9)/1000,filt(i,3)/1000];
%  b = [filt(i,6)/1000,filt(i,3)/1000];
%  d = [filt(i,5)/1000,filt(i,2)/1000];
%  plot(a,c,'o-')
%  hold on 
% plot (d,b,'o-')
% axis equal
%  
%  
 
 
% t = 0:pi/100:2*pi;
% y = exp(sin(t));
% h = plot(t,y,'YDataSource','y');
% for k = 1:0.01:10
%    y = exp(sin(t.*k));
%    refreshdata(h,'caller') 
%    drawnow
% end