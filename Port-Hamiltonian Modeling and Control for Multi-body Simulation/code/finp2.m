function u2=finp2(T)
% A=1;
% w=2;
% B=[5 6 7];
% c=B(2);
load('inputs');
% x=0.01:0.01:7.35;
A=U;
% A=spline(x,U(:,2),T);
n=round(T*100+1);
% n=length(T);


u2=A(n,2);

end