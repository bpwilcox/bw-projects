clf;
% x = 0.25*[-1 1; -1 -1; 1 1; 1 -1];
x = rand(10,2)-0.5;
% x = x(convhull(x),:);
y = rand(10,2);
y = bsxfun(@plus, y, [0.5 0]);
% y = bsxfun(@plus, x, [0.5 0.5]);
y = y(convhull(y),:);
hold on;
plot(x(convhull(x),1), x(convhull(x),2), 'r');
plot(x(:,1),x(:,2),'.')
hy = plot(y(:,1), y(:,2), 'b');
axis([-1 1 -1 1]); axis square;