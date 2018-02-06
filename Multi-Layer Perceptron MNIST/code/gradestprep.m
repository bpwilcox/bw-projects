%% Generates test cases and plots for Programming Assignment 1
clear all

%% This folder has the loading code used to access the MNIST data
addpath('mnistHelper');

%% Load the data, take only the first 20000 training points and 2000 test points
images = loadMNISTImages('mnistdata/train-images.idx3-ubyte');
labels = loadMNISTLabels('mnistdata/train-labels.idx1-ubyte');
sim = loadMNISTImages('mnistdata/t10k-images.idx3-ubyte');
slb = loadMNISTLabels('mnistdata/t10k-labels.idx1-ubyte');

% Cut down train and test data
trkeep = 1000;
tskeep = 500;
images = images(:, 1:trkeep);
labels = labels(1:trkeep);
sim = sim(:, 1:tskeep);
slb = slb(1:tskeep);

% Throw out all but some digits!
digs = 0:9;
inds = logical(any(labels == digs, 2));
labs = labels(inds);
dats = images(:, inds);
[~, labs] = max((labs == digs), [], 2);
N = numel(labs);
dats = [ones(1, N); dats];

% Size parameters...
d = size(dats, 1);		% Dimension of input data
ncl = max(labs);		% Number of classes (distinct outputs)
jhid = 16;			% Number of hidden nodes.x

% Initialize the net model values...
W = cell(2, 2);
W{1, 1} = randn(jhid, d);
W{1, 2} = 'sigmoid';
W{2, 1} = randn(ncl, jhid + 1);
W{2, 2} = 'softmax';

% Calculate the gradient!
[WX, loss] = forwardprop(W, dats, labs);
G = backprop(WX, W, dats, labs);
