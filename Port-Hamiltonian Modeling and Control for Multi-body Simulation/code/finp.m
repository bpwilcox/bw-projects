function u1=finp(T)
% A=1;
% w=2;
% u=A*sin(w*T);

A=importdata('inputs.mat');
n = T*100+1;
u1=A(n,1);

end