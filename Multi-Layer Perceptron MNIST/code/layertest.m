%% Generates test cases and plots for Programming Assignment 1
clear all
close all
%% This folder has the loading code used to access the MNIST data
addpath('mnistHelper');

%% Load the data, take only the first 20000 training points and 2000 test points
images = loadMNISTImages('mnistdata/train-images.idx3-ubyte');
labels = loadMNISTLabels('mnistdata/train-labels.idx1-ubyte');
sim = loadMNISTImages('mnistdata/t10k-images.idx3-ubyte');
slb = loadMNISTLabels('mnistdata/t10k-labels.idx1-ubyte');

% Cut down to 20000 train, 2000 test
trkeep = numel(labels);
tskeep = numel(slb);
% trkeep = 20000;
% tskeep = 2000;
images = images(:, 1:trkeep);
labels = labels(1:trkeep);
sim = sim(:, 1:tskeep);
slb = slb(1:tskeep);
[images, sim] = preprocess(images, sim);

% Throw out all but some digits!
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

d = size(tri, 1);
ncl = max(trl);

weight_opts.layers = [256];
weight_opts.funs = {'sigmoid', 'softmax'};
weight_opts.distr = 'zeros';

W = initw(weight_opts,d,ncl);

batchsize = 128;

% Set the data and parameters for the experiment
p.tri = tri;
p.trl = trl;
p.hoi = hoi;
p.hol = hol;
p.homin = 0.03;
% p.tsi = sim;
% p.tsl = slb;
p.eta = 0.1;
p.shuffle = 1;
p.ann = 'hyp';
p.annpar = 1 / 256;
p.maxit = 2048;
p.esi = 3;
p.mom = 0.9;
p.l1 = 0;
p.l2 = 0.0005;
p.batchsize = batchsize;
p.hodelmin = 0.0001;
p.winit = W;
p = netregdefs(p);

x = p.tri;
labs = p.trl;

[w, out] = netreg(p);
iters = 1:length(out.trc);

[~, tpe] = classifier(w, x, labs);
[~, spe] = classifier(w, sim, slb);
