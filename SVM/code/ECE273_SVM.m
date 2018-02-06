%This script is for the the class project in ECE 273: Convex Optimization  
% This script runs both a hard-margin SVM, soft-margin SVM, and a
% soft-margin SVM with Kernel trick
% The CVX toolbox is utilized for all optimization procedures in the SVM

close all
clear all
%% Generate Test Data

% Linearly Seperable data for hard margin
n = 100;
C1 = randn(n/2,2)+[1,2];
C2 = randn(n/2,2)+[5,4];
Y1 = ones(n/2,1);
Y2 = -1*ones(n/2,1);

x_h = [C1;C2];
y_h =[Y1;Y2];
% save('data_hard2.mat','x_h','y_h');

% Non-separable data for soft margin

% n = 100;
C1 = randn(n/2,2)+[randn(1)*3,randn(1)*3];
C2 = randn(n/2,2)+[randn(1)*3,randn(1)*3];
Y1 = ones(n/2,1);
Y2 = -1*ones(n/2,1);

r = randi(n,10,1);
x_s = [C1;C2];
y_s =[Y1;Y2];
y_s(r) = -1*y_s(r);

% save('data_soft2.mat','x_s','y_s');

% Non-linearly Separable data for kernel
C1 = randn(n/2,2)*0.5+[1,1];
rad = randn(1)*5;
theta = linspace(0,2*pi,n/2);
C2x = rad*sin(theta)+randn(1,n/2)*0.5;
C2y = rad*cos(theta)+randn(1,n/2)*0.5;
C2 = [C2x',C2y'];

Y1 = ones(n/2,1);
Y2 = -1*ones(n/2,1);

x_k = [C1;C2];
y_k =[Y1;Y2];
r = randi(n,3,1);
y_k(r) = -1*y_k(r);

% save('data_kernel2.mat','x_k','y_k');


%% SVM Algorithm 1) Hard-Margin
k_lin = @(a,b) a*b'; % linear kernel

%create kernel matrix
K_h = zeros(n,n);
for i = 1:n
    for j = 1:n
        K_h(i,j) = k_lin(x_h(i,:),x_h(j,:));
    end
end

% optimize dual objective
cvx_begin quiet
    variable lam_h(n)
    minimize(0.5*(lam_h.*y_h)'*K_h*(lam_h.*y_h)-sum(lam_h))
    subject to 
        lam_h >= 0;
        y_h'*lam_h == 0;
cvx_end

% find support vector poiints
tol = 1E-3;
sup = find(lam_h > tol);
w = sum((lam_h.*y_h).*x_h); %normal vector of hyperplane

% find intercept
b_h = 0;
for i = 1:length(sup)    
    b_h = b_h+y_h(sup(i))-w*x_h(sup(i),:)';   
end
b_h = b_h/length(sup);

%prepare plot for separating hyperplane and margins
m_pos = b_h+1;
m_neg = b_h-1;

x1 =[min(x_h(:,1)),max(x_h(:,1))];
x2 = (-w(1)*x1-b_h)/w(2);
xpos = (-w(1)*x1-m_pos)/w(2);
xneg = (-w(1)*x1-m_neg)/w(2);

% Plot
figure
PosL = x_h(y_h==1,:);
NegL = x_h(y_h==-1,:);
plot(PosL(:,1),PosL(:,2),'r.','MarkerSize',20)
hold on
plot(NegL(:,1),NegL(:,2),'g.','MarkerSize',20)
plot(x_h(sup,1),x_h(sup,2),'k+')
plot(x1,x2,'b')
plot(x1,xpos,'--b')
plot(x1,xneg,'--b')
axis([min(x_h(:,1)) max(x_h(:,1)) min(x_h(:,2)) max(x_h(:,2))])
%% SVM Algorithm 2) Soft-Margin

K_s = zeros(n,n);
for i = 1:n
    for j = 1:n
        K_s(i,j) = k_lin(x_s(i,:),x_s(j,:));
    end
end
C = 100;
cvx_begin quiet
    variable lam_s(n)
    minimize(0.5*(lam_s.*y_s)'*K_s*(lam_s.*y_s)-sum(lam_s))
    subject to
        lam_s >= 0
        lam_s <= C
        y_s'*lam_s == 0;
cvx_end

tol = 1E-3;
sup_m = find(lam_s > tol & lam_s < (C-tol));
sup = find(lam_s > tol);
w = sum((lam_s.*y_s).*x_s);

b = 0;
for i = 1:length(sup_m)
    b = b+y_s(sup_m(i))-w*x_s(sup_m(i),:)';
end
b = b/length(sup_m);


m_pos = b+1;
m_neg = b-1;

x1 =[min(x_s(:,1)),max(x_s(:,1))];
x2 = (-w(1)*x1-b)/w(2);
xpos = (-w(1)*x1-m_pos)/w(2);
xneg = (-w(1)*x1-m_neg)/w(2);

figure
PosL = x_s(y_s==1,:);
NegL = x_s(y_s==-1,:);

plot(PosL(:,1),PosL(:,2),'r.','MarkerSize',20)
hold on
plot(NegL(:,1),NegL(:,2),'g.','MarkerSize',20)
plot(x_s(sup_m,1),x_s(sup_m,2),'k+')
plot(x1,x2,'b')
plot(x1,xpos,'--b')
plot(x1,xneg,'--b')
axis([min(x_s(:,1)) max(x_s(:,1)) min(x_s(:,2)) max(x_s(:,2))])


%% SVM Algorithm 3) Soft-Margin with Kernel Trick
% k_rbf = @(a,b) exp(-0.5*(a-b)*(a-b)');
k_rbf = @(a,b) (a*b'+1)^3;

K_k = zeros(n,n);
for i = 1:n
    for j = 1:n
        K_k(i,j) = k_rbf(x_k(i,:),x_k(j,:));
    end
end
C = 10;
cvx_begin quiet
    variable lam_k(n)
    minimize(0.5*(lam_k.*y_k)'*K_k*(lam_k.*y_k)-sum(lam_k))
    subject to 
        0 <= lam_k <= C;
        lam_k >= 0
        y_k'*lam_k == 0;
cvx_end



tol = 1E-3;
sup = find(lam_k > tol);
sup_m = find(lam_k > tol & lam_k < (C-tol));

b_k = 0;
for i = 1:length(sup_m)
    p=0;
    for j =1:length(sup)
        p = p + lam_k(sup(j))*y_k(sup(j))*k_rbf(x_k(sup(j),:),x_k(sup_m(i),:)); 
    end
    b_k = b_k+y_k(sup_m(i))-p;
end
b_k = b_k/length(sup_m);

figure
PosL = x_k(y_k==1,:);
NegL = x_k(y_k==-1,:);
plot(PosL(:,1),PosL(:,2),'r.','MarkerSize',20)
hold on
plot(NegL(:,1),NegL(:,2),'g.','MarkerSize',20)
plot(x_k(sup_m,1),x_k(sup_m,2),'k+')
%% Plot with contours 
x1plot = linspace(min(x_k(:,1)), max(x_k(:,1)), 100)';
x2plot = linspace(min(x_k(:,2)), max(x_k(:,2)), 100)';
[X1, X2] = meshgrid(x1plot, x2plot);

for i = 1:size(X1, 2)
    for j =1:size(X2,2)
        this_X = [X1(i, j), X2(i, j)];
        f = 0;
            for k =1:length(sup)
                f = f+lam_k(sup(k))*y_k(sup(k))*k_rbf(x_k(sup(k),:),this_X);                             
            end
        f= f+b_k;        
        decision(i,j) = f;
    end
end
% % % Plot the SVM boundary
hold on
contour(X1, X2, decision, [0 0],'Color', 'b', 'ShowText', 'on');
axis([min(x_k(:,1)) max(x_k(:,1)) min(x_k(:,2)) max(x_k(:,2))])
% contour(X1, X2, decision,'Color', 'b', 'ShowText', 'on');

hold off;




