function [DQ] = invkin2d_2(T,Q)

DQ = zeros(8,1);


Parameters;


%create jacobian
J = [-l1*sin(Q(1)) (lend-l2)*sin(Q(2));l1*cos(Q(1)) -(lend-l2)*cos(Q(2))];
%Jdot = [-l1*cos(Q(1)) (lend-l2)*cos(Q(2)); -l1*sin(Q(1)) (lend-l2)*sin(Q(2))];


%convert motor angles to X and Y position and velocity
X = [l1*cos(Q(1))-(lend-l2)*cos(Q(2));l1*sin(Q(1))-(lend-l2)*sin(Q(2))];
dX = J*[Q(3),Q(4)]';


xd = [0.5;0.5]; 
xdd = [0;0];


%convert X and Y position to motor angles
theta1 = 
theta2 = 


K1 = eye(2)*200;
K2 = eye(2)*30;



DQ(1) = Q(3);
DQ(2) = Q(4);                                                                          

Qs = J\(K1*(xd-X)+K2*(xdd-dX));




DQ(3) = Qs(1);
DQ(4) = Qs(2);




end




