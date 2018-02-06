
%ratios
k1=0.028;   % upper arm weight/body weight
k2=0.022;   % forearm-hand weight/body weight
c1=0.436;   % upper arm center of mass/segment length
c2=0.682;   % forearm-hand center of mass/segment length
d1=0.322;   % upper arm radius of gyration/segment length
d2=0.468;   % forearm-hand radius of gyration/segment length

W=75;       % Body weight in kg
g=9.81;     % gravitational acceleration


l1=0.29;    % measured from markers in data
l2=0.29;    % measured from markers in data

r1=c1*l1;
r2=c2*l2;
m1=k1*W;
m2=k2*W;
I1=m1*(l1*d1)^2;
I2=m2*(l2*d2)^2;