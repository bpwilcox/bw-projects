addpath GJK2D
clear all; close all;

a = 30;
b = 1;
c = 35;
d = 5;
e = 11;
f = 28;


numLinks = 2;
L = repmat(Link('d', 0, 'a', 10, 'alpha', 0, 'm', .001, 'r', [-0.5, 0, 0]), numLinks, 1);
R = SerialLink(L);
R.base = trotx(pi/2)*R.base;

w = 1;
%% Create Obstacles

% Obstacle 1
o1 = [e,0;e+b,0;e+b,c;e,c];
% Obstacle 2
o2 = [-(e+b),d;-e,d;-e,c;-(e+b),c];
% Obstacle 3
o3 = [-(e+b),-c;-e,-c;-e,0;-(e+b),0];
% Obstacle 4
o4 = [e,-c;e+b,-c;e+b,-d;e,-d];


obs{1} = o1;
obs{2} = o2;
obs{3} = o3;
obs{4} = o4;


%% Check Collisions

theta1 = 0:1:359;
theta2 = 0:1:359;
theta1 = theta1*pi/180;
theta2 = theta2*pi/180;

[THETA1,THETA2] = meshgrid(theta1,theta2);

Collisions = 2*ones(length(theta1),length(theta2));
Qcoll = [];
Qfree = [];
for i = 1:length(theta1)
    
    for j = 1:length(theta2)
        
        P = generateArmPolygons(R, [theta1(i) theta2(j)], w);
        
        if ~gjk2Darray(P,obs)
            Qcoll = [Qcoll;theta1(i) theta2(j)];
        elseif theta2(j) == pi
            Qcoll = [Qcoll;theta1(i) theta2(j)];
        else
            Qfree = [Qfree;theta1(i) theta2(j)];
        end
        
        %        Collisions(i,j) = gjk2Darray(P,obs);
        
    end
end

plot(Qcoll(:,1),Qcoll(:,2),'.')


