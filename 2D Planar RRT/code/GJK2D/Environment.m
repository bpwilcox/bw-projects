%% Create Environment
close all
a = 30;
b = 1;
c = 35;
d = 5;
e = 11;
f = 28;
% Obstacle 1
hold on
o1 = [e,c;e+b,c;e,0;e+b,0];
plot(o1(convhull(o1),1), o1(convhull(o1),2), 'r');

% plot(o1(:,1),o1(:,2),'.')
axis([-(e+b+f) (e+b+f) -(c) c]);
% Obstacle 2
o2 = [-(e+b),c;-e,c;-(e+b),d;-e,d];
plot(o2(convhull(o2),1), o2(convhull(o2),2), 'r');
% Obstacle 3
o3 = [-(e+b),0;-e,0;-(e+b),-c;-e,-c];
plot(o3(convhull(o3),1), o3(convhull(o3),2), 'r');
% Obstacle 4
o4 = [e,-d;e+b,-d;e,-c;e+b,-c];
plot(o4(convhull(o4),1), o4(convhull(o4),2), 'r');