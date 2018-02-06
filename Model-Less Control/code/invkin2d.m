function [DQ] = invkin2d(T,Q)

DQ = zeros(2,1);


Parameters;


%create jacobian
J = [-l1*sin(Q(1)) (lend-l2)*sin(Q(2));l1*cos(Q(1)) -(lend-l2)*cos(Q(2))];
%Jdot = [-l1*cos(Q(1)) (lend-l2)*cos(Q(2)); -l1*sin(Q(1)) (lend-l2)*sin(Q(2))];


% Pseudo_J = (J'*J)\J';
Pseudo_J = pinv(J);% J'*inv(J*J');

X = [l1*cos(Q(1))-(lend-l2)*cos(Q(2));l1*sin(Q(1))-(lend-l2)*sin(Q(2))];

xd = [0.4;0]; 
% 
% DQ(1) = Q(3)/0.01;
% DQ(2) = Q(4)/0.01;
% dx = [0.001;0.001];
% e=0.001;

alpha = xd-X;
step = alpha/norm(alpha);
% K = 10;


dQ = Pseudo_J*norm(alpha)*step; 
% dQ = Pseudo_J*K*(alpha);



% if norm(alpha) > e

DQ(1) = dQ(1);
DQ(2) = dQ(2);      
% else
% DQ(1) = 0;
% DQ(2) = 0;  
% end

%convert motor angles to X and Y position and velocity
% X = [l1*cos(Q(1))-(lend-l2)*cos(Q(2));l1*sin(Q(1))-(lend-l2)*sin(Q(2))];
% dX = J*[Q(3),Q(4)]';
% 
% %Simulated ideal trajectory
% xd = [0.5;0.5]; 
% xdd = [0;0];
% K1 = eye(2)*200;
% K2 = eye(2)*30;
% 
% 
% 
%                                                                           
% 
% Qs = J\(K1*(xd-X)+K2*(xdd-dX));
% 
% 





end




