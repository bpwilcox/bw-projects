% IK while-loop controller for 2-DoF arm
clear all
close all

figure(1)
f = getframe;
[im,map] = rgb2ind(f.cdata,256,'nodither');
Parameters2;

Q = zeros (3,1);
Q(1) = pi/3; % motor 1 angle (rad)
Q(2) = pi/6; % motor 2 angle (rad)
Q(3) = 0;
% Q(1) = 150*pi/180;



% xd = [-0.1362;-0.2254]; 

% xd = [-0.2;0.4];
xd = [0.4;0.4];

X = forwardkin_2(Q);


e=0.01;

alpha = xd-X;
% step = alpha/norm(alpha);
% K = 10;


% dQ = Pseudo_J*K*norm(alpha)*step; 
% dQ = Pseudo_J*K*(alpha);

T=0;
dT= 0.01;
Xlast = X;
n=1;
J = jacob2(Q);
i=0;
j = 0;
while norm(alpha) > e
    n=n+1;
    

Pseudo_J = pinv(J);


step = alpha/norm(alpha)*0.005;

dQ = Pseudo_J*step;
Ql = [0;-165*pi/180;0];
Qh = [2*pi;165*pi/180;l1];
% 
% if all((Pseudo_J*alpha+Q)< Qh) && all((Pseudo_J*alpha+Q)> Ql)
% 
% else
%   
% step = [-step(2);step(1)];
% dQ = Pseudo_J*step;
% end

lb = Ql-Q;
ub = Qh-Q;

% fun = @(dq) 1000*norm(J*dq-step);
fun = @(dq) norm(xd-forwardkin_2(Q+dq))+1/norm(Ql-(Q+dq))+ 1/norm(Qh-(Q+dq));
fun = @(dq) norm(xd-forwardkin_2(Q+dq));
% fun = @(dq)norm(Pseudo_J*step-dq);
stry = [Q+dQ;Q];
nonlcon = [];
% A = [eye(3);-eye(3)];
% b = [0.05;0.05;.1;-0.05;-0.05;-.1];
% A = dQ'/0.01^2;
% b = dQ'*dQ/0.01^2;
A = J;
b = step;
Aeq = [];
beq = [];
%

%minmize(alpha) = xd - X 
%where X = forwardkin_2(Q)
%where Q = Q+dQ
%where dQ = Pseudo_J*step

%alternatively -> minimize 




% if all(Q+dQ < Qh) && all(Q+dQ > Ql)
% j = j+1    
% else
%     i = i+1
x0 = zeros(3,1);
x0=dQ;
x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub);
% end
% stry = [Q+dQ;dQ];

% fun = @(s)norm(pinv(jacob2(s(1:3)-s(4:6)))*step-s(4:6));
% fun = @(s)norm(pinv(jacob2(s(4:6)))*step-(s(1:3)-s(4:6)));

% lb = [-pi;-pi;0;-Inf;-Inf;-Inf];
% ub = [pi;pi;l1;Inf;Inf;Inf];
% lb = [-2*pi;-2*pi;0;-2*pi;-2*pi;0;];
% ub = [2*pi;2*pi;l1;2*pi;2*pi;l1;];

% fun(x);

% options = optimoptions(@fmincon,'MaxFunEvals',4000);

Q = Q+x;


T=T+dT;

X = forwardkin_2(Q);
% X = [l1*cos(Q(1))-(lend-l2)*cos(Q(2));l1*sin(Q(1))-(lend-l2)*sin(Q(2))];
% X=awgn(X,20);
alpha = xd-X;
dX = X-Xlast;
norm(dX);

% if norm(dX) > norm(step)+0.0001
%     
%    i=i+1
% end
% Xlast = X;

% dQ = x(1:3)-x(4:6);
% J = calcJ(J,dQ,dX);
J = jacob2(Q);



A = Q(1:3,1);

l = l1+Q(3);

plotrobot2(Q,xd,T)
% 
% Origin =[0 0];
% % Link1 =[l1*cos(A(1)) l1*sin(A(1))];
% Link1 = [l*cos(Q(1)) l*sin(Q(1))];
% Link2 =[l*cos(Q(1))+l2*cos(Q(1)+Q(2));l*sin(Q(1))+l2*sin(Q(1)+Q(2))];
% % Link2 =[l*cos(Q(1))+l2*cos(Q(2));l*sin(Q(1))+l2*sin(Q(2))];
% % Link2 =[l2*cos(A(2)) l2*sin(A(2))];
% % Link3 = [l2*cos(A(2))+l1*cos(A(1)) l2*sin(A(2))+l1*sin(A(1))];
% % Link4 = [l1*cos(A(1))-(lend-l2)*cos(A(2)) l1*sin(A(1))-(lend-l2)*sin(A(2))];
% 
% plot(Origin(1),Origin(2),'ro')
% hold on
% 
% plot(xd(1),xd(2),'+')
% % plot(x,y)
% plot(Link1(1),Link1(2),'ro')
% plot(Link2(1),Link2(2),'ro')
% % plot(Link3(1),Link3(2),'ro')
% % plot(Link4(1),Link4(2),'ro')
% 
% 
% plot([Origin(1) Link1(1)],[Origin(2) Link1(2)],'b')
% plot([Link1(1) Link2(1)],[Link1(2) Link2(2)],'b')
% 
% % plot([Link2(1) Link3(1)],[Link2(2) Link3(2)],'b')
% % plot([Link3(1) Link4(1)],[Link3(2) Link4(2)],'b')
% title(strcat('step: ',num2str(T)))
% 
% axis([-1 1 -1 1])
% daspect([1 1 1])
% 
% drawnow limitrate

if norm(alpha) > e
    
    clf
else
   
    
    T=0;

r1 = -.4 + (0.4+0.4)*rand();
r2 = -.4 + (0.6+0.4)*rand();
xd = [r1;r2]; 
alpha = xd-X;
end

end









