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

images = images(:, 1:20000);
labels = labels(1:20000);
sim = sim(:, 1:2000);
slb = slb(1:2000);


%% 4. Logistic Regression via Gradient Descent


%% 2's vs 3's

% Inputs for problem a 
dig = [2,3];
[Ntr,trdat,trlab] = class_log(dig,images,labels);
[Nts,tsdat,tslab] = class_log(dig,sim,slb);

% holdout = round(0.1*length(trdat));

% Develop a hold out set
hopct = 0.1;
hoind = round((1 - hopct) * Ntr);
hoi = trdat(:, hoind : end);
hol = trlab(hoind : end);
tri = trdat(:, 1 : (hoind - 1));
trl = trlab(1 : (hoind - 1));


%% Test parameters

% Set the data and parameters for the experiment
p.tri = tri;
p.trl = trl;
p.hoi = hoi;
p.hol = hol;
p.tsi = tsdat;
p.tsl = tslab;
p.eta = 0.1; % Initial learning rate
% p.trmin = 0.01;
% p.homin = 0.01;
p.maxit = 256;
p.trdelmin = 0.0005;
p.mom = 0.9;
p.l1 = 0;
p.l2 = 0.0005;
p.reprate=1;
p.ann ='hyp';
T = 128;
p.annpar = 1/T;

%% Logistic Regression
[w1, out1] = logreg(p);

%% Cost
epochs1 = 1/p.reprate:1/p.reprate:length(out1.trc)/p.reprate;

figure(1)

plot(epochs1,out1.trc)
hold on
plot(epochs1,out1.hoc)
plot(epochs1,out1.tsc)
xlabel('epochs')
ylabel('loss')
title('Loss for logistic regression (2s vs 3s)')
legend('training','hold-out','test','Location','Best')
% saveas(gcf,'Log2v3Loss','jpg')


%% Percent Correct classification

figure(2)

plot(epochs1,1-out1.tre)
hold on
plot(epochs1,1-out1.hoe)
plot(epochs1,1-out1.tse)
xlabel('epochs')
ylabel('percent correct')
title('Perceent Correct Classification (2s vs 3s)')
legend('training','hold-out','test','Location','Best')
% saveas(gcf,'Log2v3PE','jpg')

%% 5. Regularization

%% Input lambda tests
lam = 0.000:0.0005:0.007;
lam = [lam,0.02];

%% L1
finerr_l1=ones(length(lam),1);
wlen = ones(length(lam),1);
p.l2=0;
for i=1:length(lam)
    
    p.l1 = lam(i);
    
    [w, out_reg_l1] = netreg(p);
    
    finerr_l1(i) = out_reg_l1.tse(end);
    wlen(i) = norm(w);
    epochs = 1/p.reprate:1/p.reprate:length(out_reg_l1.trc)/p.reprate;
    
    if mod(i,2)==0
        figure(13)
        if i <=length(lam)/2
            
            subplot(2,length(lam)/4,i/2)
            imagesc(reshape(w(1:end, 1), 28, 28))
                       
        else
            
            subplot(2,length(lam)/4,i/2)
            imagesc(reshape(w(1:end, 1), 28, 28))
            
        end
        title(num2str(lam(i)))
    else
        
    end
    figure(7)
    hold on
    plot(epochs,1-out_reg_l1.tre)
    
    
end
figure(7)
xlabel('epochs')
ylabel('percent correct')
title('Perceent Correct for L1 Regularization (2s vs 3s)')
legend(num2str(lam'),'Location','Best')
saveas(gcf,'Log2v3L1Reg','jpg')

figure(6)
plot(log(lam),finerr_l1)
xlabel('log(\lambda)')
ylabel('percent error')

figure(11)
plot(lam,wlen)
xlabel('\lambda')
ylabel('length of weight vector')
title('Lenght of weight vector for each lamda')

figure(13)
saveas(gcf,'Log2v3L1WeightImages','jpg')
%% L2

finerr_l2=ones(length(lam),1);
wlen2 = ones(length(lam),1);
p.l1=0;

for i=1:length(lam)
    
    p.l2 = lam(i);
    [w, out_reg_l2] = logreg(p);
    
    finerr_l2(i) = out_reg_l2.tse(end);
    wlen2(i) = norm(w);
    epochs = 1/p.reprate:1/p.reprate:length(out_reg_l2.trc)/p.reprate;
    
    %     figure(8)
    %     subplot(1,length(lam),i)
    %     imagesc(reshape(w(1:end, 1), 28, 28))
    %     title(num2str(lam(i)))
    if mod(i,2)==0
        figure(8)
        if i <=length(lam)/2
            
            subplot(2,length(lam)/4,i/2)
            imagesc(reshape(w(1:end, 1), 28, 28))
            
        else
            
            subplot(2,length(lam)/4,i/2)
            imagesc(reshape(w(1:end, 1), 28, 28))
            
        end
        title(num2str(lam(i)))
    else
        
    end
    
    figure(9)
    hold on
    plot(epochs,1-out_reg_l2.tre)
    
    
end

xlabel('epochs')
ylabel('percent correct')
title('Perceent Correct for L2 Regularization (2s vs 3s)')
legend(num2str(lam'),'Location','Best')
saveas(gcf,'Log2v3L2Reg','jpg')

figure(6)
hold on
plot(log(lam),finerr_l2)
xlabel('log(\lambda)')
ylabel('percent error')
legend('L1','L2','Location','Best')
saveas(gcf,'Log2v3L1vL2Error','jpg')

figure(11)
hold on
plot(lam,wlen2)
xlabel('\lambda')
ylabel('length of weight vector')
title('Lenght of weight vector for each lamda')
legend('L1','L2','Location','Best')
saveas(gcf,'Log2v3L1vL2WeightLength','jpg')

figure(8)
saveas(gcf,'Log2v3L2WeightImages','jpg')
    
%% 2's vs 8's 

% Inputs for problem c

dig = [2,8];
[Ntr,trdat,trlab] = class_log(dig,images,labels);
[Nts,tsdat,tslab] = class_log(dig,sim,slb);

% Develop a hold out set
hopct = 0.1;
hoind = round((1 - hopct) * Ntr);
hoi = trdat(:, hoind : end);
hol = trlab(hoind : end);
tri = trdat(:, 1 : (hoind - 1));
trl = trlab(1 : (hoind - 1));


%% Test parameters

% Set the data and parameters for the experiment
p.tri = tri;
p.trl = trl;
p.hoi = hoi;
p.hol = hol;
p.tsi = tsdat;
p.tsl = tslab;
p.eta = 0.1; % Initial learning rate
% p.trmin = 0.01;
% p.homin = 0.01;
p.maxit = 256;
p.trdelmin = 0.0005;
p.mom = 0.9;
p.l1 = 0;
p.l2 = 0;
p.reprate=1;
p.ann ='hyp';
T = 128;
p.annpar = 1/T;


%% Logistic regression 
[w2, out2] = logreg_bw2(p);
epochs2 = 1/p.reprate:1/p.reprate:length(out2.trc)/p.reprate;
%% Cost


figure(3)

plot(epochs2,out2.trc)
hold on
plot(epochs2,out2.hoc)
plot(epochs2,out2.tsc)
xlabel('epochs')
ylabel('loss')
title('Loss for logistic regression (2s vs 8s)')
legend('training','hold-out','test','Location','Best')
saveas(gcf,'Log2v8Loss','jpg')

%% Percent Correct

figure(4)

plot(epochs2,1-out2.tre)
hold on
plot(epochs2,1-out2.hoe)
plot(epochs2,1-out2.tse)
xlabel('epochs')
ylabel('percent correct')
title('Perceent Correct Classification (2s vs 8s)')
legend('training','hold-out','test','Location','Best')
saveas(gcf,'Log2v8PE','jpg')


%% Weights as images

figure(5)
subplot(1,3,1)
imagesc(reshape(w1, 28, 28))
title('(2s vs 3s)')

subplot(1,3,2)
imagesc(reshape(w2, 28, 28))
title('(2s vs 8s)')

subplot(1,3,3)
wdiff=w2-w1;

imagesc(reshape(wdiff, 28, 28))
title('Difference')

saveas(gcf,'Log2v3v8WeightImages','jpg')


%% 6. Softmax Regression via Gradient Descent

% Inputs
dig = [0,1,2,3,4,5,6,7,8,9];
% dig = [0,1,2,3,4];
[Ntr,trdat,trlab] = class_log(dig,images,labels);
[Nts,tsdat,tslab] = class_log(dig,sim,slb);

% Develop a hold out set
hopct = 0.1;
hoind = round((1 - hopct) * Ntr);
hoi = trdat(:, hoind : end);
hol = trlab(hoind : end);
tri = trdat(:, 1 : (hoind - 1));
trl = trlab(1 : (hoind - 1));


%% Test parameters

% Set the data and parameters for the experiment
p.tri = tri;
p.trl = trl;
p.hoi = hoi;
p.hol = hol;
p.tsi = tsdat;
p.tsl = tslab;
p.eta = 0.1; % Initial learning rate
% p.trmin = 0.01;
% p.homin = 0.01;
p.maxit = 256;
p.trdelmin = 0.0005;
p.mom = 0.9;
p.reprate=1;
p.ann ='hyp';
T = 128;
p.annpar = 1/T;
[errl1,ind1]= min(finerr_l1);
[errl2,ind2]= min(finerr_l2);
if errl1 < errl2
    p.l1 = lam(ind1);
    p.l2= 0;
else
    p.l1 = 0;
    p.l2 = lam(ind2);
end


%% Softmax Regression
[wsoft, outs] = logreg(p);

%% Cost
epochss = 1/p.reprate:1/p.reprate:length(outs.trc)/p.reprate;

figure(15)

plot(epochss,outs.trc)
hold on
plot(epochss,outs.hoc)
plot(epochss,outs.tsc)
xlabel('epochs')
ylabel('loss')
title('Loss for Softmax Regression')
legend('training','hold-out','test','Location','Best')
saveas(gcf,'SoftLoss','jpg')


%% Percent Correct classification

figure(16)

plot(epochss,1-outs.tre)
hold on
plot(epochss,1-outs.hoe)
plot(epochss,1-outs.tse)
xlabel('epochs')
ylabel('percent correct')
title('Perceent Correct for Softmax Regression')
legend('training','hold-out','test','Location','Best')
saveas(gcf,'SoftPE','jpg')



