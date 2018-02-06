function [DQ] = cranksys(T,Q)

DQ = zeros(11,1);


Parameters;


%create jacobian
J = [-l1*sin(Q(1)) (lend-l2)*sin(Q(2));l1*cos(Q(1)) -(lend-l2)*cos(Q(2))];
Jdot = [-l1*cos(Q(1)) (lend-l2)*cos(Q(2)); -l1*sin(Q(1)) (lend-l2)*sin(Q(2))];

%create inertia and coriolis matrices 
Dh = [a b*cos(Q(2)-Q(1));b*cos(Q(2)-Q(1)) d];
Ch= [0 -Q(4)*b*sin(Q(2)-Q(1));Q(3)*b*sin(Q(2)-Q(1)) 0];
Dh_inv = Dh\eye(2);


%convert motor angles to X and Y position and velocity
X = [l1*cos(Q(1))-(lend-l2)*cos(Q(2));l1*sin(Q(1))-(lend-l2)*sin(Q(2))];
dX = J*[Q(3),Q(4)]';

%Simulated ideal trajectory
[xd,xddot,xdddot] = feval('generatevirtraj',T);


%Crank model parameters
m=0.1;
M=[m 0;0 m];
K = [3000 0 ;0 3000];
B = [sqrt(4*m*3000) 0;0 sqrt(4*m*3000)];

% K = 0.2*K;
% B = 0.2*B;



xc = 0.2;
yc = 0.4;
r0=0.1;


theta = atan2(X(2)-yc,X(1)-xc); %current angle around circle


% Fhand =-(M*xdddot'+B*(xddot'-dX)+K*(xd'-X));  %pretend Fhand is measured
Fhand =M*xdddot'+B*(xddot'-dX)+K*(xd'-X);  %pretend Fhand is measured


%%add random disturbances to ideal force
% Rd = -1 + (2).*rand(2,1);
% % Rd= rand(2,1);
% Random=[Rd(1)*1*Fhand(1);Rd(2)*1*Fhand(2)];
% Fhand = Fhand+Random;

%%costant Force
% Fhand = [10;10];

%reference point on crank (i.e. "constraint of crank")
Xref = [xc+r0*cos(theta);yc+r0*sin(theta)];
dXref=[0;0];


DQ(5) = Q(7);
DQ(6) = Q(8);

%Virtual trajectory EOM
Virtual = inv(M)*(Fhand-B*(dX-dXref)-K*(X-Xref));


DQ(7)=Virtual(1);
DQ(8)= Virtual(2);


Xv = [Q(5);Q(6)];
dXv = [Q(7);Q(8)];
ddXv = [DQ(7);DQ(8)];


%develop error term 's'
L = [5 0;0 5]; 
dXr = dXv+L*(Xv-X);
dQr = inv(J)*dXr;
ddQr = inv(J)*((ddXv+L*(dXv-X))-Jdot*dQr);

s = [Q(3);Q(4)]-dQr;


%Regressor matrix 'Y' formulation
Y =zeros(2,3);
Y(1,1) = ddQr(1);
Y(1,2) = cos(Q(2)-Q(1))*ddQr(2)-sin(Q(2)-Q(1))*dQr(2)^2;
Y(1,3) =0;
Y(2,1) =0;
Y(2,2) = cos(Q(2)-Q(1))*ddQr(1)-sin(Q(2)-Q(1))*dQr(1)^2;
Y(2,3) = ddQr(2);


R = [0.1 0 0;0 0.1 0;0 0 0.1];
Kd = [5 0;0 5]*1;


ahat = [Q(9);Q(10);Q(11)];
Torque = Y*ahat-J'*Fhand-Kd*s;

%update law
adot = -R*Y'*s;


DQ(9) = adot(1);
DQ(10) = adot(2);
DQ(11) = adot(3);



DQ(1) = Q(3);
DQ(2) = Q(4);                                                                          

%System EOM
ddQ = Dh_inv*(J'*Fhand+Torque-Ch*[Q(3);Q(4)]);

DQ(3) = ddQ(1);
DQ(4) = ddQ(2);

end




