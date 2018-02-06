function [DX] = pHdiff(T,X)

ArmParameters;
% DeriveTorque;

% DX = zeros(4,1);  
DX = zeros(6,1);

%For reference: 
%DX(1) - q1dot, X(1) - q1
%DX(2) - p1dot, X(2) - p1
%DX(3) - q2dot, X(3) - q2 
%DX(4) - p2dot, X(4) - p2  

% u1=feval('finp1',T);
% u2=feval('finp2',T);
% 
% %Define variables for constraints                                                                      
% a=-r1*sin(X(1));
% b = r1*cos(X(1));
% c = -(l1*sin(X(1))+r2*sin(X(1)+X(3)));
% d=-r2*sin(X(1)+X(3));
% e=(l1*cos(X(1))+r2*cos(X(1)+X(3)));
% f=r2*cos(X(1)+X(3));
% 
% %define constraints
% R = [1 0;a 0;b 0;1 1;c d;e f];
% %Initial Mass matrix with original coordinates (6x6)
% M = [I1 0 0 0 0 0;0 m1 0 0 0 0;0 0 m1 0 0 0;0 0 0 I2 0 0;0 0 0 0 m2 0;0 0 0 0 0 m2];
% %New Mass matrix reduced for 2 angle coordinates (2x2)
% Mnew = R.'*M*R;
% 
% 
% %velocity qdot calculated in terms of mass matrix and momentum vector ([X(2),X(4)]
% Q = inv(Mnew)*[X(2),X(4)].';
% 
% DX(1) = Q(1);   %qdot(1)
% DX(3)= Q(2);    %qdot(2)
% 
% %Here I've constructed two matrices (S1,S2) which represent the gradient of
% %inverse mass matrix Mnew wih respect to q1 and q2. These were solved using
% %Matlab's partial differential operator with symbolic variables and entered
% %directly here.
% 
% t1= X(1);   %q1
% t2= X(3);   %q2                  
% 
% S1 =[0 0; 0 0];
% S2 = [-((m2*r2^2*cos(t1 + t2)^2 + m2*r2^2*sin(t1 + t2)^2 + I2)*(2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)^2 - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*sin(t1) - 2*I2*l1*m2*r2*sin(t1 + t2)*cos(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)^2*cos(t1)*sin(t1) + 2*l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)*sin(t1)))/(I1*I2 + I1*m2*r2^2*sin(t1 + t2)^2 + I2*m2*r2^2*sin(t1 + t2)^2 + I2*l1^2*m2*cos(t1)^2 + I2*m1*r1^2*cos(t1)^2 + I2*l1^2*m2*sin(t1)^2 + I2*m1*r1^2*sin(t1)^2 + I1*m2*r2^2*cos(t1 + t2)^2 + I2*m2*r2^2*cos(t1 + t2)^2 + l1^2*m2^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*I2*l1*m2*r2*sin(t1 + t2)*sin(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)*sin(t1))^2,((m2*r2^2*cos(t1 + t2)^2 + m2*r2^2*sin(t1 + t2)^2 + l1*m2*cos(t1)*r2*cos(t1 + t2) + l1*m2*sin(t1)*r2*sin(t1 + t2))*(2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)^2 - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*sin(t1) - 2*I2*l1*m2*r2*sin(t1 + t2)*cos(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)^2*cos(t1)*sin(t1) + 2*l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)*sin(t1)))/(I1*I2 + I1*m2*r2^2*sin(t1 + t2)^2 + I2*m2*r2^2*sin(t1 + t2)^2 + I2*l1^2*m2*cos(t1)^2 + I2*m1*r1^2*cos(t1)^2 + I2*l1^2*m2*sin(t1)^2 + I2*m1*r1^2*sin(t1)^2 + I1*m2*r2^2*cos(t1 + t2)^2 + I2*m2*r2^2*cos(t1 + t2)^2 + l1^2*m2^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*I2*l1*m2*r2*sin(t1 + t2)*sin(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)*sin(t1))^2 - (l1*m2*r2*cos(t1 + t2)*sin(t1) - l1*m2*r2*sin(t1 + t2)*cos(t1))/(I1*I2 + I1*m2*r2^2*sin(t1 + t2)^2 + I2*m2*r2^2*sin(t1 + t2)^2 + I2*l1^2*m2*cos(t1)^2 + I2*m1*r1^2*cos(t1)^2 + I2*l1^2*m2*sin(t1)^2 + I2*m1*r1^2*sin(t1)^2 + I1*m2*r2^2*cos(t1 + t2)^2 + I2*m2*r2^2*cos(t1 + t2)^2 + l1^2*m2^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*I2*l1*m2*r2*sin(t1 + t2)*sin(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)*sin(t1));((m2*r2^2*cos(t1 + t2)^2 + m2*r2^2*sin(t1 + t2)^2 + l1*m2*cos(t1)*r2*cos(t1 + t2) + l1*m2*sin(t1)*r2*sin(t1 + t2))*(2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)^2 - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*sin(t1) - 2*I2*l1*m2*r2*sin(t1 + t2)*cos(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)^2*cos(t1)*sin(t1) + 2*l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)*sin(t1)))/(I1*I2 + I1*m2*r2^2*sin(t1 + t2)^2 + I2*m2*r2^2*sin(t1 + t2)^2 + I2*l1^2*m2*cos(t1)^2 + I2*m1*r1^2*cos(t1)^2 + I2*l1^2*m2*sin(t1)^2 + I2*m1*r1^2*sin(t1)^2 + I1*m2*r2^2*cos(t1 + t2)^2 + I2*m2*r2^2*cos(t1 + t2)^2 + l1^2*m2^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*I2*l1*m2*r2*sin(t1 + t2)*sin(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)*sin(t1))^2 - (l1*m2*r2*cos(t1 + t2)*sin(t1) - l1*m2*r2*sin(t1 + t2)*cos(t1))/(I1*I2 + I1*m2*r2^2*sin(t1 + t2)^2 + I2*m2*r2^2*sin(t1 + t2)^2 + I2*l1^2*m2*cos(t1)^2 + I2*m1*r1^2*cos(t1)^2 + I2*l1^2*m2*sin(t1)^2 + I2*m1*r1^2*sin(t1)^2 + I1*m2*r2^2*cos(t1 + t2)^2 + I2*m2*r2^2*cos(t1 + t2)^2 + l1^2*m2^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*I2*l1*m2*r2*sin(t1 + t2)*sin(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)*sin(t1)),(2*l1*m2*r2*cos(t1 + t2)*sin(t1) - 2*l1*m2*r2*sin(t1 + t2)*cos(t1))/(I1*I2 + I1*m2*r2^2*sin(t1 + t2)^2 + I2*m2*r2^2*sin(t1 + t2)^2 + I2*l1^2*m2*cos(t1)^2 + I2*m1*r1^2*cos(t1)^2 + I2*l1^2*m2*sin(t1)^2 + I2*m1*r1^2*sin(t1)^2 + I1*m2*r2^2*cos(t1 + t2)^2 + I2*m2*r2^2*cos(t1 + t2)^2 + l1^2*m2^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*I2*l1*m2*r2*sin(t1 + t2)*sin(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)*sin(t1)) - ((2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)^2 - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*sin(t1) - 2*I2*l1*m2*r2*sin(t1 + t2)*cos(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)^2*cos(t1)*sin(t1) + 2*l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)*sin(t1))*(I1 + m2*r2^2*cos(t1 + t2)^2 + m2*r2^2*sin(t1 + t2)^2 + l1^2*m2*cos(t1)^2 + m1*r1^2*cos(t1)^2 + l1^2*m2*sin(t1)^2 + m1*r1^2*sin(t1)^2 + 2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*l1*m2*r2*sin(t1 + t2)*sin(t1)))/(I1*I2 + I1*m2*r2^2*sin(t1 + t2)^2 + I2*m2*r2^2*sin(t1 + t2)^2 + I2*l1^2*m2*cos(t1)^2 + I2*m1*r1^2*cos(t1)^2 + I2*l1^2*m2*sin(t1)^2 + I2*m1*r1^2*sin(t1)^2 + I1*m2*r2^2*cos(t1 + t2)^2 + I2*m2*r2^2*cos(t1 + t2)^2 + l1^2*m2^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + l1^2*m2^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*cos(t1 + t2)^2*sin(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*cos(t1)^2 + m1*m2*r1^2*r2^2*sin(t1 + t2)^2*sin(t1)^2 + 2*I2*l1*m2*r2*cos(t1 + t2)*cos(t1) + 2*I2*l1*m2*r2*sin(t1 + t2)*sin(t1) - 2*l1^2*m2^2*r2^2*cos(t1 + t2)*sin(t1 + t2)*cos(t1)*sin(t1))^2];
% 
% %Total gradient of the Hamiltonian (H) with respect to q1 and q2. Set equal
% %to the p1dot and p2dot respectively. 
% dH1 = -(1/2*[X(2),X(4)]*S1*[X(2),X(4)].'+ g*m1*r1*cos(t1)+g*m2*(r2*cos(t1 + t2) + l1*cos(t1)));
% dH2 = -(1/2*[X(2),X(4)]*S2*[X(2),X(4)].'+ g*m2*r2*cos(t1 + t2));
% 
%   
% DX(2) =u1 + dH1;
% DX(4) =u2 +dH2;


%-------------------------------------------------------------------------------------------------------------------------------
% Below is the code for executing the simulation using the Mass Matrix given
% in the Paper (and seen elsewhere). Remove comments below (and make all above
% code comments to execute.

% 
% u1=feval('finp1',T);
% u2=feval('finp2',T);
q=feval('qdes1',T);
dq=feval('qdes2',T);
ddq=feval('qdes3',T);

%constants
a1 = m1*r1^2 + m2*l1^2+I1;
a2 = m2*r2^2+I2;
b1 = m2*l1*r2;


t1= X(1);   %q1
t2= X(3);   %q2

%Given Mass matrix
Mass = [a1+a2+2*b1*cos(t2), a2+b1*cos(t2);a2+b1*cos(t2), a2];

S=inv(Mass);
DX(1)= S(1)*X(2)+S(3)*X(4); %qdot(1)
DX(3)= S(2)*X(2)+S(4)*X(4); %qdot(2)



%gradients of inverse mass matrix
K1 = [0 0;0 0];
K2 = zeros(2,2);
K2(1)= -(2*l1^2*m2^2*r2^2*cos(t2)*sin(t2)*(m2*r2^2 + I2))/(- l1^2*m2^2*r2^2*cos(t2)^2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + m1*m2*r1^2*r2^2 + I1*m2*r2^2 + I2*m1*r1^2 + I1*I2)^2;
K2(2)=(l1*m2*r2*sin(t2))/(I1*I2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + I2*m1*r1^2 + I1*m2*r2^2 + m1*m2*r1^2*r2^2 - l1^2*m2^2*r2^2*cos(t2)^2) + (2*l1^2*m2^2*r2^2*cos(t2)*sin(t2)*(m2*r2^2 + l1*m2*cos(t2)*r2 + I2))/(- l1^2*m2^2*r2^2*cos(t2)^2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + m1*m2*r1^2*r2^2 + I1*m2*r2^2 + I2*m1*r1^2 + I1*I2)^2;
K2(3)=(l1*m2*r2*sin(t2))/(I1*I2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + I2*m1*r1^2 + I1*m2*r2^2 + m1*m2*r1^2*r2^2 - l1^2*m2^2*r2^2*cos(t2)^2) + (2*l1^2*m2^2*r2^2*cos(t2)*sin(t2)*(m2*r2^2 + l1*m2*cos(t2)*r2 + I2))/(- l1^2*m2^2*r2^2*cos(t2)^2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + m1*m2*r1^2*r2^2 + I1*m2*r2^2 + I2*m1*r1^2 + I1*I2)^2;
K2(4)=-(2*l1*m2*r2*sin(t2))/(I1*I2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + I2*m1*r1^2 + I1*m2*r2^2 + m1*m2*r1^2*r2^2 - l1^2*m2^2*r2^2*cos(t2)^2) - (2*l1^2*m2^2*r2^2*cos(t2)*sin(t2)*(m2*l1^2 + 2*m2*cos(t2)*l1*r2 + m1*r1^2 + m2*r2^2 + I1 + I2))/(- l1^2*m2^2*r2^2*cos(t2)^2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + m1*m2*r1^2*r2^2 + I1*m2*r2^2 + I2*m1*r1^2 + I1*I2)^2;

Kp = [80 0;0 80];
Ki = [50 0; 0 50];
Kd = [3 0; 0 3];
Kc = [190 0;0 190];

dQc = inv(Kd)*Kc*([X(1)-q(1);X(3)-q(2)]-[X(5);X(6)]);
DX(5)=dQc(1);
DX(6)=dQc(2);

v=Kc*([X(1)-q(1);X(3)-q(2)]-[X(5);X(6)]);
q1=X(1);
q2=X(3);
qd1 = q(1);
qd2 = q(2);

gM1 = [0 0;0 0];
gM2 = [ -2*l1*m2*r2*sin(t2), -l1*m2*r2*sin(t2); -l1*m2*r2*sin(t2), 0];
dMass= [-2*b1*sin(X(3))*dq(2), -b1*sin(X(3))*dq(2); -b1*sin(X(3))*dq(2),0];
V1=g*m1*r1*cos(t1)+g*m2*(r2*cos(t1 + t2) + l1*cos(t1));
V2=g*m2*r2*cos(t1 + t2);
U = Mass*[ddq(1);ddq(2)]+dMass*[dq(1);dq(2)]-[0;-(qd1*(2*l1*m2*qd1*r2*sin(t2) + l1*m2*qd2*r2*sin(t2)))/2 - (l1*m2*qd1*qd2*r2*sin(t2))/2]+[V1;V2]-Kp*[X(1)-qd1;X(3)-qd2]-v;




% dK1 = 90*q1 - 90*qd1;
% dK2 = 60*q2 - 60*qd2;
% % 
% E1=[q(1)-X(1);q(2)-X(3)];
% E2=[dq(1)-DX(1);dq(2)-DX(3)];
% Qpd = Kp*E1+Kd*E2;
% 
% D = Kd*[DX(1);DX(3)];

dH1 = -(1/2*[X(2),X(4)]*K1*[X(2),X(4)].'+ g*m1*r1*cos(t1)+g*m2*(r2*cos(t1 + t2) + l1*cos(t1)));
dH2 = -(1/2*[X(2),X(4)]*K2*[X(2),X(4)].'+ g*m2*r2*cos(t1 + t2));

% dTau=-Ki*(-[dH1;dH2]+D+Kp*[X(1)-qd1;X(3)-qd2]);
% DX(5)=dTau(1);
% DX(6)=dTau(2);


% U=[u1;u2]-D-Kp*[X(1)-qd1;X(3)-qd2]+[X(5);X(6)];
% U=[u1;u2]-D-Kp*[X(1)-qd1;X(3)-qd2];
% U= [u1;u2]+Qpd;



% %gradients of full hamiltonian 
% dH1 = -(1/2*[X(2),X(4)]*K1*[X(2),X(4)].'+ g*m1*r1*cos(t1)+g*m2*(r2*cos(t1 + t2) + l1*cos(t1))+dK1);
% dH2 = -(1/2*[X(2),X(4)]*K2*[X(2),X(4)].'+ g*m2*r2*cos(t1 + t2)+dK2);

% dH1 = -(1/2*[X(2),X(4)]*K1*[X(2),X(4)].'+ g*m1*r1*cos(t1)+g*m2*(r2*cos(t1 + t2) + l1*cos(t1)));
% dH2 = -(1/2*[X(2),X(4)]*K2*[X(2),X(4)].'+ g*m2*r2*cos(t1 + t2));
% 
% 
% dTau=-Ki*(-[dH1;dH2]+D+Kp*[X(1)-qd1;X(3)-qd2]);
% % 
% DX(5)=dTau(1);
% DX(6)=dTau(2);


% U=[u1;u2]-D-Kp*[X(1)-qd1;X(3)-qd2]+[X(5);X(6)];
% dH1 = -(1/2*[X(2),X(4)]*K1*[X(2),X(4)].');
% dH2 = -(1/2*[X(2),X(4)]*K2*[X(2),X(4)].');

% DX(2) = u1 + dH1;
% DX(4) = u2 + dH2;

% DX(2) =-D(1) + dH1+u1;
% DX(4) =-D(2) + dH2+u2;

DX(2) = dH1+U(1);
DX(4) = dH2+U(2);

% DX(2)=U(1);
% DX(4)=U(2);
% 
% 
% 
% dq=feval('qdes2',T);
% 
% t1=q(1);
% t2=q(2);
% 
% %Given Mass matrix
% M = [a1+a2+2*b1*cos(t2), a2+b1*cos(t2);a2+b1*cos(t2), a2];
% 
% K1 = [0 0;0 0];
% K2 = zeros(2,2);
% K2(1)= -(2*l1^2*m2^2*r2^2*cos(t2)*sin(t2)*(m2*r2^2 + I2))/(- l1^2*m2^2*r2^2*cos(t2)^2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + m1*m2*r1^2*r2^2 + I1*m2*r2^2 + I2*m1*r1^2 + I1*I2)^2;
% K2(2)=(l1*m2*r2*sin(t2))/(I1*I2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + I2*m1*r1^2 + I1*m2*r2^2 + m1*m2*r1^2*r2^2 - l1^2*m2^2*r2^2*cos(t2)^2) + (2*l1^2*m2^2*r2^2*cos(t2)*sin(t2)*(m2*r2^2 + l1*m2*cos(t2)*r2 + I2))/(- l1^2*m2^2*r2^2*cos(t2)^2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + m1*m2*r1^2*r2^2 + I1*m2*r2^2 + I2*m1*r1^2 + I1*I2)^2;
% K2(3)=(l1*m2*r2*sin(t2))/(I1*I2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + I2*m1*r1^2 + I1*m2*r2^2 + m1*m2*r1^2*r2^2 - l1^2*m2^2*r2^2*cos(t2)^2) + (2*l1^2*m2^2*r2^2*cos(t2)*sin(t2)*(m2*r2^2 + l1*m2*cos(t2)*r2 + I2))/(- l1^2*m2^2*r2^2*cos(t2)^2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + m1*m2*r1^2*r2^2 + I1*m2*r2^2 + I2*m1*r1^2 + I1*I2)^2;
% K2(4)=-(2*l1*m2*r2*sin(t2))/(I1*I2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + I2*m1*r1^2 + I1*m2*r2^2 + m1*m2*r1^2*r2^2 - l1^2*m2^2*r2^2*cos(t2)^2) - (2*l1^2*m2^2*r2^2*cos(t2)*sin(t2)*(m2*l1^2 + 2*m2*cos(t2)*l1*r2 + m1*r1^2 + m2*r2^2 + I1 + I2))/(- l1^2*m2^2*r2^2*cos(t2)^2 + l1^2*m2^2*r2^2 + I2*l1^2*m2 + m1*m2*r1^2*r2^2 + I1*m2*r2^2 + I2*m1*r1^2 + I1*I2)^2;
% 
%  
% p=M*[dq(1);dq(2)];
% 
% dH3 = -(1/2*p.'*K1*p+ g*m1*r1*cos(t1)+g*m2*(r2*cos(t1 + t2) + l1*cos(t1)));
% dH4 = -(1/2*p.'*K2*p+ g*m2*r2*cos(t1 + t2));
% 
% 
% 
% 
% 
% dTau=-Ki*([dH3;dH4]+Kd*[dq(1);dq(2)]);
% 
% DX(5)=dTau(1);
% DX(6)=dTau(2);

% DX(2) = u1;
% DX(4) = u2;


end




