

a=1;
b=2;
c=3;
d=4;
e=5;
f=6;
Cqt = [a b c e;-1 0 0 0; 0 -1 0 0;0 0 d f; 0 0 -1 0; 0 0 0 -1];
% Q=zeros(6,6);
% R=zeros(6,4);


[Q,R] = qr(Cqt)

