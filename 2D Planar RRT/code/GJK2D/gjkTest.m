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
hy = plot(y(:,1), y(:,2), 'b');
axis([-1 1 -1 1]); axis square;
%%
for i = 1:10
incollision = gjk2D(x, y);
end
if incollision, title('In collision!');
else title('Not in collision!');
end
%%
numIter = 400;
timeTaken = zeros(1,numIter);
for i = 1:numIter
    delete(hy);
    y = bsxfun(@plus, y, [-0.01 0]);
    hy = plot(y(:,1), y(:,2), 'b');
    drawnow;
    tic
    incollision = gjk2D(x, y);
    timeTaken(i) = toc;
    if incollision, title('In collision!');
    else title('Not in collision!');
    end
end
%%
% simplex = [];
% for i = 1:100
% d = 2*rand(1,2)-1;%[1 2];
% idx = getFarthestIdxInDir(x, d);
% plot(x(idx,1), x(idx,2), 'b.');
% idx = getFarthestIdxInDir(y, -d);
% plot(y(idx,1), y(idx,2), 'r.');
% simplex = cat(1,simplex,getSupport(x,y,d));
% end
% simplex = simplex(convhull(simplex),:);
% plot(simplex(:,1), simplex(:,2), 'g');