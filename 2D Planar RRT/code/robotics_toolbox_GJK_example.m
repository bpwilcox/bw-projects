addpath GJK2D
clear all; close all;

time_delay = 0.05;
axLim = [-3 3 -10 10 -3 3];
numLinks = 2;
L = repmat(Link('d', 0, 'a', 1, 'alpha', 0, 'm', .001, 'r', [-0.5, 0, 0]), numLinks, 1);
R = SerialLink(L);
R.base = trotx(pi/2)*R.base;

R.plotopt = {'view', 'x', 'noshading', 'noname', 'ortho', ...
    'workspace', axLim, 'tile1color', [1,1,1], 'delay', time_delay, 'trail', '',...
    'noshadow', 'nobase', 'nowrist', ...
    'linkcolor', 'b', 'toolcolor', 'b', ...
    'jointcolor', 0.2*[1 1 1], 'jointdiam', 2,'scale', 0.5};
axis(axLim); axis square; hold on;
% R.plot([0 0]);
w = 0.075; % get width of robot arm based on its size in the figure

obs{1} = 2*[-0.1 -0.1; 0.1 -0.1; 0.1 0.1; -0.1 0.1];
obs{1} = bsxfun(@plus, obs{1}, [0.5 1]);%; 1 0.9; 1.2 0.9; 1.2 1.1; 1 1.1];

for i = 1:length(obs)
    obs{i} = cat(1, obs{i}, obs{i}(1,:));
    fill3(obs{i}(:,1), ones(size(obs{i}(:,1))), obs{i}(:,2), 0.8*[1 1 1], 'facealpha', 1)
end

base_angle = [linspace(0,pi/2,25), linspace(pi/2,0,25)];
for i = 1:length(base_angle)
    P = generateArmPolygons(R, [base_angle(i) 0], w);
    if ~gjk2Darray(P, obs)
        title('In collision')
    else
        title('Not in collision')
    end
    R.plot([base_angle(i) 0])
    drawnow limitrate;
end