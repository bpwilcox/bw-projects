ArmParameters;
load('q');
load('p');
load('Tau');
load('Take_d3');

Kp = [30 0;0 20];
Kd = [5 0; 0 5];
Ki = [50 0; 0 50];


a1 = m1*r1^2 + m2*l1^2+I1;
a2 = m2*r2^2+I2;
b1 = m2*l1*r2;





U=zeros(length(Tau),2);

for i=1:length(Tau)
   qs = q(i,:)+[Qc(i,1) Qc(i,4)];
   Mass = [a1+a2+2*b1*cos(qs(2)), a2+b1*cos(qs(2));a2+b1*cos(qs(2)), a2];
   qdot=inv(Mass)*p(i,:).';
   
   U(i,:)=-Kp*q(i,:).'-Kd*qdot+ Tau(i,:).';
    
end


