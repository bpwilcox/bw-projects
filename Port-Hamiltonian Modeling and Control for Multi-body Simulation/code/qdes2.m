function qd2=qdes2(T)

load('Take_b2');
A=Vc;


n=round(T*100+1);

%  c=A(n,1);

qd2=[A(n+1,1) A(n+1,4)];

end