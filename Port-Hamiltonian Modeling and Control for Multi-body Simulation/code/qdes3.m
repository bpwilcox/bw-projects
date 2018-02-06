function qd3=qdes3(T)

load('Take_b2');

A=Ac;


n=round(T*100+1);

%  c=A(n,1);

qd3=[A(n,1) A(n,4)];

end