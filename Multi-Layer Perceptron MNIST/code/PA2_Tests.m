%% Test cases and plots for PA2

clear all
close all
%% Problem 3) Base case - 1 hidden layer, include momentum, regularization,
%annealing


testcomp = struct;
k=0;

%Import data

%% Generates test cases and plots for Programming Assignment 1


%% This folder has the loading code used to access the MNIST data
addpath('mnistHelper');

%% Load the data, take only the first 20000 training points and 2000 test points
images = loadMNISTImages('mnistdata/train-images.idx3-ubyte');
labels = loadMNISTLabels('mnistdata/train-labels.idx1-ubyte');
tsimages = loadMNISTImages('mnistdata/t10k-images.idx3-ubyte');
tslabels= loadMNISTLabels('mnistdata/t10k-labels.idx1-ubyte');

%% Pre-process
% images = images/255;
images = images -mean(images);
% sim = sim/255;
tsimages = tsimages-mean(tsimages);

% %% Cuttin Data
% trkeep = numel(labels);
% tskeep = numel(tslabels);
trkeep = 20000;
tskeep = 2000;
[tri,trl,sim,slb,N,Nt,hoi,hol] = importimages(images, labels,tsimages,tslabels, trkeep, tskeep);

%% Weight initialization (zeros for part Problem 3)
d = size(tri, 1);
ncl = max(trl);

weight_opts.layers = [256];
weight_opts.funs = {'sigmoid','softmax'};
weight_opts.distr = 'zeros';
W = initw(weight_opts,d,ncl);

%% Set the data and parameters for the experiment
batchsize = N;
p.batchsize = batchsize;
p.tri = tri;
p.trl = trl;
p.hoi = hoi;
p.hol = hol;
p.tsi = sim;
p.tsl = slb;
p.hodelmin = 0.0001;
p.homin = 0.03;
p.eta = 0.1;
p.shuffle = 0;
p.ann = 'hyp';
T = 256;
p.annpar = 1 / T;
% p.trmin = 0.01;
p.maxit = 1024;
p.esi = 3;
p.mom = 0;
p.l1 = 0;
p.l2 = 0.0005;
p.reprate = round(N / batchsize);
% p.trdelmin = 0.0001;
p.winit = W;

p = netregdefs(p);

x = p.tri;
labs = p.trl;

%% Run Algorithm and Generate Plots


[w, out] = netreg(p);
[classtrain, tre] = classifier(w, p.tri, labs);
[classtest, tse] = classifier(w, sim, slb);

%%
% epochs = 1/p.reprate:1/p.reprate:length(out.trc)/p.reprate;
iters = 1:length(out.trc);

titlep = 'Base Case';
filename = 'base_f';
makeplots(iters,out,titlep,filename)

k=k+1;
testcomp(k).test = filename;
testcomp(k).numits = length(out.trc);
testcomp(k).accuracy_train = 1-min(tre);
testcomp(k).accuracy_test = 1-min(tse);

%% Check gradient comparison
% gradestprep;
% gradest;

%% Problem 4) Tricks of trade

% trkeep = 20000;
% tskeep = 2000;
% [tri,trl,sim,slb,N,Nt,hoi,hol] = importimages(images, labels,tsimages,tslabels, trkeep, tskeep);
trkeep = numel(labels);
tskeep = numel(tslabels);
% trkeep = 20000;
% tskeep = 2000;
[tri,trl,sim,slb,N,Nt,hoi,hol] = importimages(images, labels,tsimages,tslabels, trkeep, tskeep);

%% Base case for small set 

% batchsize = N;
% p.batchsize = batchsize;
% % p.tri = tri;
% % p.trl = trl;
% p.hoi = hoi;
% p.hol = hol;
% p.tsi = [];
% p.tsl = [];
% p.reprate = round(N / batchsize);
% 

% x = p.tri;
% labs = p.trl;
% [w, out] = netreg(p);
% [classtrain, tre] = classifier(w, x, labs);
% [classtest, tse] = classifier(w, sim, slb);

%% a) Shuffle
clear p 

batchsize = 128;
p.batchsize = batchsize;
p.tri = tri;
p.trl = trl;
p.hoi = hoi;
p.hol = hol;
% p.tsi = sim;
% p.tsl = slb;
p.hodelmin = 0.0001;
p.homin = 0.03;
p.eta = 0.1;
p.shuffle = 1;
p.ann = 'hyp';
T = 256;
p.annpar = 1 / T;
% p.trmin = 0.01;
p.maxit = 2048;
p.esi = 8;
p.mom = 0;
p.l1 = 0;
p.l2 = 0.0005;
p.reprate = round(N / batchsize);
% p.trdelmin = 0.0001;
p.winit = W;

p = netregdefs(p);

%% Run Algorithm and Classify

[w, out] = netreg(p);
[classtrain, tre] = classifier(w, x, labs);
[classtest, tse] = classifier(w, sim, slb);

%%
% epochs = 1/p.reprate:1/p.reprate:length(out.trc)/p.reprate;
iters = 1:length(out.trc);

titlep = 'Shuffle';
filename = 'shuffle_f';
makeplots(iters,out,titlep,filename)

k=k+1;
testcomp(k).test = filename;
testcomp(k).numits = length(out.trc);
testcomp(k).accuracy_train = 1-min(tre);
testcomp(k).accuracy_test = 1-min(tse);

%% c) Use tanh sigmoid

clear W
weight_opts.layers = [256];
weight_opts.funs = {'tanh','softmax'};
weight_opts.distr = 'zeros';
W = initw(weight_opts,d,ncl);


%%
clear p 

batchsize = 128;
p.batchsize = batchsize;
p.tri = tri;
p.trl = trl;
p.hoi = hoi;
p.hol = hol;
% p.tsi = sim;
% p.tsl = slb;
p.hodelmin = 0.0001;
p.homin = 0.03;
p.eta = 0.1;
p.shuffle = 1;
p.ann = 'hyp';
T = 256;
p.annpar = 1 / T;
% p.trmin = 0.01;
p.maxit = 2048;
p.esi = 8;
p.mom = 0;
p.l1 = 0;
p.l2 = 0.0005;
p.reprate = round(N / batchsize);
% p.trdelmin = 0.0001;
p.winit = W;

p = netregdefs(p);
%% Run Algorithm and Classify

[w, out] = netreg(p);
[classtrain, tre] = classifier(w, x, labs);
[classtest, tse] = classifier(w, sim, slb);

iters = 1:length(out.trc);

% epochs = 1/p.reprate:1/p.reprate:length(out.trc)/p.reprate;
titlep = 'Using tanh as sigmoid';
filename = 'sig_tanh_f';
makeplots(iters,out,titlep,filename)

k=k+1;
testcomp(k).test = filename;
testcomp(k).numits = length(out.trc);
testcomp(k).accuracy_train = 1-min(tre);
testcomp(k).accuracy_test = 1-min(tse);

%% d) Random normal weight distrubiton with mean and std 1/sqrt(fan-in)
clear W
weight_opts.layers = [256];
weight_opts.funs = {'tanh','softmax'};
weight_opts.distr = 'randnorm';
W = initw(weight_opts,d,ncl);
%% 

clear p 

batchsize = 128;
p.batchsize = batchsize;
p.tri = tri;
p.trl = trl;
p.hoi = hoi;
p.hol = hol;
% p.tsi = sim;
% p.tsl = slb;
p.hodelmin = 0.0001;
p.homin = 0.03;
p.eta = 0.1;
p.shuffle = 1;
p.ann = 'hyp';
T = 256;
p.annpar = 1 / T;
% p.trmin = 0.01;
p.maxit = 2048;
p.esi = 8;
p.mom = 0;
p.l1 = 0;
p.l2 = 0.0005;
p.reprate = round(N / batchsize);
% p.trdelmin = 0.0001;
p.winit = W;

p = netregdefs(p);

%% Run Algorithm and Classify

[w, out] = netreg(p);
[classtrain, tre] = classifier(w, x, labs);
[classtest, tse] = classifier(w, sim, slb);

iters = 1:length(out.trc);
% epochs = 1/p.reprate:1/p.reprate:length(out.trc)/p.reprate;
titlep = 'Random normal weight initialization';
filename = 'rnweights_f';
makeplots(iters,out,titlep,filename)

k=k+1;
testcomp(k).test = filename;
testcomp(k).numits = length(out.trc);
testcomp(k).accuracy_train = 1-min(tre);
testcomp(k).accuracy_test = 1-min(tse);
%% e) use momentum

clear p 

batchsize = 128;
p.batchsize = batchsize;
p.tri = tri;
p.trl = trl;
p.hoi = hoi;
p.hol = hol;
% p.tsi = sim;
% p.tsl = slb;
p.hodelmin = 0.0001;
p.homin = 0.03;
p.eta = 0.1;
p.shuffle = 1;
p.ann = 'hyp';
T = 256;
p.annpar = 1 / T;
% p.trmin = 0.01;
p.maxit = 2048;
p.esi = 8;
p.mom = 0.9;
p.l1 = 0;
p.l2 = 0.0005;
p.reprate = round(N / batchsize);
% p.trdelmin = 0.0001;
p.winit = W;

p = netregdefs(p);

%% Run Algorithm and Classify

[w, out] = netreg(p);
[classtrain, tre] = classifier(w, x, labs);
[classtest, tse] = classifier(w, sim, slb);

iters = 1:length(out.trc);
% epochs = 1/p.reprate:1/p.reprate:length(out.trc)/p.reprate;
titlep = 'Including momentum';
filename = 'momentum_f';
makeplots(iters,out,titlep,filename)

k=k+1;
testcomp(k).test = filename;
testcomp(k).numits = length(out.trc);
testcomp(k).accuracy_train = 1-min(tre);
testcomp(k).accuracy_test = 1-min(tse);
%% 5) Network Topology



%% a) Double number of hidden units

clear W
weight_opts.layers = [512];
weight_opts.funs = {'tanh','softmax'};
weight_opts.distr = 'randnorm';
W = initw(weight_opts,d,ncl);
%%
clear p 

batchsize = 128;
p.batchsize = batchsize;
p.tri = tri;
p.trl = trl;
p.hoi = hoi;
p.hol = hol;
% p.tsi = sim;
% p.tsl = slb;
p.hodelmin = 0.0001;
p.homin = 0.03;
p.eta = 0.1;
p.shuffle = 1;
p.ann = 'hyp';
T = 256;
p.annpar = 1 / T;
% p.trmin = 0.01;
p.maxit = 2048;
p.esi = 8;
p.mom = 0.9;
p.l1 = 0;
p.l2 = 0.0005;
p.reprate = round(N / batchsize);
% p.trdelmin = 0.0001;
p.winit = W;

p = netregdefs(p);


%% Run Algorithm and Classify

[w, out] = netreg(p);
[classtrain, tre] = classifier(w, x, labs);
[classtest, tse] = classifier(w, sim, slb);
iters = 1:length(out.trc);

% epochs = 1/p.reprate:1/p.reprate:length(out.trc)/p.reprate;
titlep = 'Double hidden units';
filename = 'double_f';
makeplots(iters,out,titlep,filename)

k=k+1;
testcomp(k).test = filename;
testcomp(k).numits = length(out.trc);
testcomp(k).accuracy_train = 1-min(tre);
testcomp(k).accuracy_test = 1-min(tse);
%% a.2) Half number of hidden units

clear W
weight_opts.layers = [128];
weight_opts.funs = {'tanh','softmax'};
weight_opts.distr = 'randnorm';
W = initw(weight_opts,d,ncl);


%%

clear p 

batchsize = 128;
p.batchsize = batchsize;
p.tri = tri;
p.trl = trl;
p.hoi = hoi;
p.hol = hol;
% p.tsi = sim;
% p.tsl = slb;
p.hodelmin = 0.0001;
p.homin = 0.03;
p.eta = 0.1;
p.shuffle = 1;
p.ann = 'hyp';
T = 256;
p.annpar = 1 / T;
% p.trmin = 0.01;
p.maxit = 2048;
p.esi = 8;
p.mom = 0.9;
p.l1 = 0;
p.l2 = 0.0005;
p.reprate = round(N / batchsize);
% p.trdelmin = 0.0001;
p.winit = W;

p = netregdefs(p);
%% Run Algorithm and Classify

[w, out] = netreg(p);
[classtrain, tre] = classifier(w, x, labs);
[classtest, tse] = classifier(w, sim, slb);
iters = 1:length(out.trc);
% epochs = 1/p.reprate:1/p.reprate:length(out.trc)/p.reprate;
titlep = 'Half Hidden Units';
filename = 'half_f';
makeplots(iters,out,titlep,filename)

k=k+1;
testcomp(k).test = filename;
testcomp(k).numits = length(out.trc);
testcomp(k).accuracy_train = 1-min(tre);
testcomp(k).accuracy_test = 1-min(tse);
%% b) Add another hidden layer

% trkeep = 20000;
% tskeep = 2000;
% [tri,trl,sim,slb,N,Nt,hoi,hol] = importimages(images, labels,tsimages,tslabels, trkeep, tskeep);

%%
clear W
weight_opts.layers = [204,204];
weight_opts.funs = {'tanh','tanh','softmax'};
weight_opts.distr = 'randnorm';
W = initw(weight_opts,d,ncl);


%%
clear p 

batchsize = 128;
p.batchsize = batchsize;
p.tri = tri;
p.trl = trl;
p.hoi = hoi;
p.hol = hol;
p.tsi = sim;
p.tsl = slb;
p.hodelmin = 0.0001;
p.homin = 0.03;
p.eta = 0.1;
p.shuffle = 1;
p.ann = 'hyp';
T = 256;
p.annpar = 1 / T;
% p.trmin = 0.01;
p.maxit = 2048;
p.esi = 8;
p.mom = 0.9;
p.l1 = 0;
p.l2 = 0.0005;
p.reprate = round(N / batchsize);
% p.trdelmin = 0.0001;
p.winit = W;

p = netregdefs(p);
%% Run Algorithm and Classify

[w, out] = netreg(p);
[classtrain, tre] = classifier(w, x, labs);
[classtest, tse] = classifier(w, sim, slb);
iters = 1:length(out.trc);
% epochs = 1/p.reprate:1/p.reprate:length(out.trc)/p.reprate;
titlep = 'Add second hidden layer';
filename = 'twohidlayers_f';
makeplots(iters,out,titlep,filename)

k=k+1;
testcomp(k).test = filename;
testcomp(k).numits = length(out.trc);
testcomp(k).accuracy_train = 1-min(tre);
testcomp(k).accuracy_test = 1-min(tse);


save('testresults',testcomp);
% %% b.2 Change hidden layers size
% 
% weight_opts.layers = [300,100];
% weight_opts.funs = {'tanh','tanh','softmax'};
% weight_opts.distr = 'randnorm';
% W = initw(weight_opts,d,ncl);
% p.winit = W;
% 
% %% Run Algorithm and Classify
% [w, out] = netreg(p);
% % [classtrain, tre] = classifier(w, p.tri, labs);
% % [classtest, tse] = classifier(w, sim, slb);
% iters = 1:length(out.trc);
% 
% % epochs = 1/p.reprate:1/p.reprate:length(out.trc)/p.reprate;
% titlep = 'Change units of both hidden layer';
% filename = 'twohiddif';
% makeplots(iters,out,titlep,filename)
% 
% k=k+1;
% testcomp(k).test = filename;
% testcomp(k).numits = length(out.trc);
% testcomp(k).accuracy_train = 1-min(tre);
% testcomp(k).accuracy_test = 1-min(tse);