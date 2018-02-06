function qd1=qdes1(T)

load('Take_b2');

A=Qc;


n=round(T*100+1);

%  c=A(n,1);

qd1=[A(n+2,1) A(n+2,4)];

end