% IK while-loop controller for 2-DoF arm
clear all
close all


%%  Initializations


F=[];       %For video
Parameters; %"actual" system parameters for simulation purposes
T=0;        %start time
dT=0.01;    %time step
stepsize = 0.005;
P1 = subplot(1,2,1);
P2 = subplot(1,2,2);
% Initialize motor positions
Q = zeros (2,1); 
Q(1) = 2*pi/3; % motor 1 angle (rad)
Q(2) = 210*pi/180; % motor 2 angle (rad)
X = forwardkin(Q);   %starting endpoint position
V =[0;0];
Pred_X = [X;V];


% Initialize random target position
r1 = -.4 + (0.6+0.4)*rand();
r2 = -.4 + (0.7+0.4)*rand();
xd = [r1;r2]; 
xd = [-0.2;0.4];

% error vector
alpha = xd-X; 
gamma = xd-X;
e=0.01; %error threshold


% % For direct update method (not currrently implemented)
eps = 0.001;

% Kalman filter
xk_last = X;
% P = cov(xt_best,xt_pred);
% P_last = cov(Last_States,Last_States);
% Pk_last = eye(2,2);
Pk = eye(4,4);
% Q = zeros(4,4);
v = 0.0001;
% R = zeros(4,4);
% R(1:2,1:2) = v*eye(2,2);
% Rk= v*eye(2,2);
Rk =v*eye(4,4);
% Rk = [v 0 0 0;0 v 0 0;0 0 0 0;0 0 0 0];
% Rk = 
% Q_noise = 0*eye(2,2);

Q_noise = 0*eye(4,4);

% R =v;
% H = [1 1 0 0];
Hk = [1 0 0 0;0 1 0 0;0 0 0 0;0 0 0 0];
% Hk = [1 0;0 1];
Fk = [1 0 dT 0;0 1 0 dT;0 0 1 0;0 0 0 1];

% Initialize Jacobian
J = trueJacob(Q);
Jinv = pinv(J);
% Wi = diag([norm(Ji(:,1),2) norm(Ji(:,2),2)]);

% dQ = Jinv*step;
% Q = Q+dQ;
% V = J*dQ/dT;
% Last_States = [X;V];

% For conditioning while loop
points=0;
n=1;
% maxSamples = 10;
count = 0;

% Saving history of Jacobians
% M = cell(maxSamples, 1) ;
M = cell(1,1); 
XTrue = [];
Noise = [];
XOpt = [];
XMeas = [];
Jacob=[];
Qs=[];
%% 

while norm(alpha) > e && points < 10
% while n <= maxSamples
    
% Save Jacobian
M{n,1} = J;
Qs(n,1)=Q(1);
Qs(n,2)=Q(2);

Jacob(n,1) = J(1,1);
Jacob(n,2) = J(1,2);
Jacob(n,3) = J(2,1);
Jacob(n,4) = J(2,2);

% Analytical Jacobian for reference
% J = [-l1*sin(Q(1)) (lend-l2)*sin(Q(2));l1*cos(Q(1)) -(lend-l2)*cos(Q(2))];    


% Update step direction each iteration
step = alpha/norm(alpha)*stepsize;
T=T+dT;

% Solve for actuator displacement

% Jinv=pinv(J); %Try as comparison to inverse update
dQ = Jinv*step;
Q = Q+dQ;


% Kalman filter prediction
% Fk = [1 0;0 1];
% Bk = J;
% uk = dQ;
% xk_pred = Fk*xk_last + Bk*uk;
% 
% Pk =Fk*Pk_last*Fk' + Q_noise;
% S = Hk*Pk*Hk'+Rk;
% K = Pk*Hk'*inv(S);
% Pk_last = Pk-K*Hk*Pk;


V = J*dQ/dT;

[xk_pred, Pk ,K] = K_pred(Fk,Pk,Hk,Q_noise,xk_last,V,Rk);

% xk_pred = Fk*[xk_last;V];
% Pk = Fk*Pk_last*Fk+ Q_noise; 
% S = Hk*Pk*Hk'+Rk;
% K = Pk*Hk'*inv(S);
% Pk_last = Pk-K*Hk'*Pk;


% Pred_States = Ft*Last_States;
% xt_pred = Ft*xlast_best;


% Evaluate displacement
% noise = sqrt(v).*randn(2,1);
noise = [0;0];
X = forwardkin(Q)+noise;
x_meas = X;
x_true = x_meas-noise;

% xk_opt = xk_pred + K*([x_meas;V] - Hk*xk_pred);
    
[xk_opt, Pk] = K_update(xk_pred,K,x_meas,V,Hk,Pk);

% xk_opt = x_meas;


XTrue(n,1:2)=x_true(1:2)';
Noise(n,1:2) = noise(1:2)';
XOpt (n,1:2) = xk_opt(1:2)';
XMeas(n,1:2) = x_meas(1:2)';
% Kalman filter update


% K = P/(P+R);
% P_last = P-K*P;

% Curr_States = Pred_States+K*([X;V]-H*Pred_States);

% xt_best = xt_pred + K*(X-xt_pred);
% xk_opt = x_true;
dX = xk_opt(1:2) - xk_last(1:2);

xk_last=xk_opt(1:2);

% dX = Curr_States(1:2)-Last_States(1:2); 
% 
% Last_States = Curr_States;
% Last_States(3:4) = V;

% xlast_best = xt_best;

% Optimize next Jacobian estimate
J = calcJ(J,dQ,dX);
% Jinv = calcinvJ(Jinv,dQ,dX);
Jinv = pinv(J);
% Alternative Method for updating true local Jacobian
% step
% dX
d=norm(step-dX);  
% if d >eps
% 
%     J=trueJacob(Q);
%     Jinv = pinv(J);
%     count=count+1;
%     T=T+4*dT;
% 
% end

% Update distance from target position
alpha = xd-xk_opt(1:2);
% gamma = xd-x_true;
% alpha = xd -x_true;

% Plot current position
A = Q(1:2,1);
% J(1,1);
% plotrobot(A,xd,T,count,J)
plotrobot(A,xd,T)
% F=[F; getframe];    %Save frame for video

% Clear graph for next update

if norm(alpha) > e
%     figure(1)
% P1   
% cla(P1)
clf    
else
% Create a new random target point
    points = points+1;
    T=0;
    % count=0;
    r1 = -.4 + (0.4+0.4)*rand();
    r2 = -.4 + (0.6+0.4)*rand();
    xd = [r1;r2];
    alpha = xd-X;
    
end

n=n+1;

end
%% 
% figure(2)
% plot(XMeas(:,1))
% hold on
% plot(XTrue(:,1))
% plot(XOpt(:,1))
% ylabel('X Pos')
% xlabel('frame')
% legend('Noisy','True', 'Estimate')
% figure(3)
% plot(XMeas(:,2))
% hold on
% plot(XTrue(:,2))
% plot(XOpt(:,2))
% ylabel('Y Pos')
% xlabel('frame')
% legend('Noisy','True', 'Estimate')
% figure(2)
% plot(XMeas)
% hold on
% plot(XTrue)
% plot(XOpt)


%% SAVE VIDEO

% myVideo = VideoWriter('myfile.avi');
% uncompressedVideo = VideoWriter('myfile.avi', 'Uncompressed AVI');
% myVideo.FrameRate = 100;  % Default 30
% % myVideo.Quality = 75;    % Default 75
% open(myVideo);
% writeVideo(myVideo, F);
% close(myVideo);
% 










