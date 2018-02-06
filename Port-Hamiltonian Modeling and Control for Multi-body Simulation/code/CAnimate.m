clear all
close all
ArmParameters;
set = 'b';
trial=2;
load(strcat('Take_',set,num2str(trial)));
load('trialdata');
i =1;
% a = [position(i,8)/1000, Qc(i,2), Qc(i,5)];
% b = [position(i,9)/1000, Qc(i,3), Qc(i,6)];

a = [ position(i,8)/1000, l1*cos(Qc(i,1)), l1*cos(Qc(i,1))+l2*cos(Qc(i,1)+Qc(i,4))];
b = [ position(i,9)/1000, l1*sin(Qc(i,1)), l1*sin(Qc(i,1))+l2*sin(Qc(i,1)+Qc(i,4))];
% 
% a = [ 0, l1*cos(X(i,1)), l1*cos(X(i,1))+l2*cos(X(i,1)+X(i,3))];
% b = [ 0, l1*sin(X(i,1)), l1*sin(X(i,1))+l2*sin(X(i,1)+X(i,3))];



 
% hold on
h = plot(a,b,'XDataSource','a','YDataSource','b');
%   axis ([-0.7 0.7 -0.7 0.7])
%  axis ([-1 1 -1 1])
 axis ([-1 1 0 2])
%   axis equal
% y=plot(a,b,'o');

for k = 1:length(X)
    
% a = [0, Qc(k,2), Qc(k,5)];
% b = [0, Qc(k,3), Qc(k,6)];
% 
% a = [position(k,8)/1000, Qc(k,2), Qc(k,5)];
% b = [position(k,9)/1000, Qc(k,3), Qc(k,6)];


% % plot(a,b,'o')
a = [position(k,8)/1000, l1*cos(Qc(k,1))+position(k,8)/1000, l1*cos(Qc(k,1))+l2*cos(Qc(k,1)+Qc(k,4))+position(k,8)/1000];
b = [position(k,9)/1000, l1*sin(Qc(k,1))+position(k,9)/1000, l1*sin(Qc(k,1))+l2*sin(Qc(k,1)+Qc(k,4))+position(k,9)/1000];

% a = [ 0, l1*cos(X(k,1)), l1*cos(X(k,1))+l2*cos(X(k,1)+X(k,3))];
% b = [ 0, l1*sin(X(k,1)), l1*sin(X(k,1))+l2*sin(X(k,1)+X(k,3))];

arm1(k) = sqrt((a(2)-a(1))^2+(b(2)-b(1))^2);
arm2(k) = sqrt((a(3)-a(2))^2 + (b(3)-b(2))^2);

   refreshdata(h,'caller') 
%    refreshdata(y)
   drawnow
end

% for j=1:length(position)-1
%     
% a = [0,l1*cos(Qc(j,1)), l1*cos(Qc(j,1))+l2*cos(Qc(j,1)+Qc(j,4))];
% b = [0, l1*sin(Qc(j,1)), l1*sin(Qc(j,1))+l2*sin(Qc(j,1)+Qc(j,4))];
%     
% arm1(i) = sqrt(a(2)^2+b(2)^2);
% arm2(i) = sqrt((a(3)-a(2))^2 + (b(3)-b(2))^2);
% end

