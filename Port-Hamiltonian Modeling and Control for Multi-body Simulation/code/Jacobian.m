
syms l1 l2 t1 t2 v1 v2 x1 x2 y1 y2 dx1 dx2 dy1 dy2 dt1 dt2


a=-l1*sin(t1);
b = l1*cos(t1);
c = -(l1*sin(t1)+l2*sin(t1+t2));
d=-l2*sin(t1+t2);
e=(l1*cos(t1)+l2*cos(t1+t2));
f=l2*cos(t1+t2);

% 
% A = [a -1 0 0 0 0;b 0 -1 0 0 0; c 0 0 d -1 0;e 0 0 f 0 -1];
% 
% B = [v1; x1; y1; v2; x2; y2];
% 
% C=A*B;

C = [b-x1;-a-y1;e-x2;-c-y2];

J=jacobian(C, [t1 x1 y1 t2 x2 y2]);

q =[dt1; dx1 ;dy1; dt2; dx2 ;dy2];

K= J*q;


% D = pinv(J);

