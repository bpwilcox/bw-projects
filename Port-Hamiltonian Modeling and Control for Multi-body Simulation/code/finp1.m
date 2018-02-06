function u1=finp1(T)
% A=1;
% w=2;
% B=[5 6 7];
% c=B(1);
load('inputs');
% x=0.01:0.01:7.35;
% A= importdata('inputs.mat');
A=U;
% A=spline(x,U(:,1),T);
% 
n=round(T*100+1);
% n=length(T);
% c=A(n,1);

u1=A(n,1);

end