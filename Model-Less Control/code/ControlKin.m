function [DZ] = ControlKin(T,Z)

DZ = zeros(4,1);
X = zeros(2,1);
Q = zeros(2,1);
% 
X(1) = Z(1);
X(2) = Z(2);
Q(1) = Z(3);
Q(2) = Z(4);

dT= 10^-2;
xd = [0.4;0]; 
Parameters;
stepsize = 0.005;

%create jacobian
J = [-l1*sin(Q(1)) (lend-l2)*sin(Q(2));l1*cos(Q(1)) -(lend-l2)*cos(Q(2))];


% Pseudo_J = (J'*J)\J';
Pseudo_J = pinv(J);% J'*inv(J*J');

% X = [l1*cos(Q(1))-(lend-l2)*cos(Q(2));l1*sin(Q(1))-(lend-l2)*sin(Q(2))];


% 
% DQ(1) = Q(3)/0.01;
% DQ(2) = Q(4)/0.01;
% dx = [0.001;0.001];
% e=0.001;

alpha = xd-X;
% step = alpha/norm(alpha);
step = alpha/norm(alpha)*stepsize;
K = 2;


% dQ = Pseudo_J*alpha; 
% dQ = Pseudo_J*K*(alpha);

% if norm(alpha) > step
% dQ = Pseudo_J*step;
% else
dQ = Pseudo_J*(alpha);
% dQ = [0;0];  
% end

dX = J*dQ;
% if norm(dX) < step*10
% DZ(1) = dX(1);
% DZ(2) = dX(2);
% DZ(3) = dQ(1);
% DZ(4) = dQ(2); 

% else
%     
% dQ = Pseudo_J*step*10;
% dX = J*dQ;
%    

DZ(1) = dX(1)/dT;
DZ(2) = dX(2)/dT;
DZ(3) = dQ(1)/dT;
DZ(4) = dQ(2)/dT;   
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




