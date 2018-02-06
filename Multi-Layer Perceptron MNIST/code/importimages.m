function [tri,trl,sim,slb,N,Nt,hoi,hol] = importimages(images, labels,sim,slb, trkeep, tskeep)


images = images(:, 1:trkeep);
labels = labels(1:trkeep);
sim = sim(:, 1:tskeep);
slb = slb(1:tskeep);

%% Throw out all but some digits!
% digs = [2, 3];
digs = 0:9;
inds = logical(any(labels == digs, 2));
labs = labels(inds);
dats = images(:, inds);
[~, labs] = max((labs == digs), [], 2);
N = numel(labs);
dats = [ones(1, N); dats];
tri = dats;
trl = labs;

% Same for test data
tst = logical(any(slb == digs, 2));
sim = sim(:, tst);
slb = slb(tst);
[~, slb] = max(slb == digs, [], 2);
Nt = numel(slb);
sim = [ones(1, Nt); sim];

% Develop a hold out set
hopct = 0.05;
hoind = round((1 - hopct) * N);
hoi = dats(:, hoind : end);
hol = labs(hoind : end);
tri = dats(:, 1 : (hoind - 1));
trl = labs(1 : (hoind - 1));

end
