close all
clear all
%% Problem 4b)
 
N = 1000;
P1 = 0.5;
P2 = 1-P1;
% condition A
alpha_A  = 10;
var_A = 2;
mu_A1 = [alpha_A;0]; 
mu_A2 = -mu_A1;
Sig_A1 = [1 0;0 var_A];
Sig_A2 = Sig_A1;

% condition B
alpha_B = 2;
var_B = 10;
mu_B1 = [alpha_B;0]; 
mu_B2 = -mu_B1;
Sig_B1 = [1 0;0 var_B];
Sig_B2 = Sig_B1;


sample_A1 = mvnrnd(mu_A1,Sig_A1,N*P1);
sample_A2 = mvnrnd(mu_A2,Sig_A2,N*P2);
sample_A = [sample_A1;sample_A2]';
figure(1)
% scatter(sample_A1(:,1),sample_A1(:,2))
% hold on
% scatter(sample_A2(:,1),sample_A2(:,2))
scatter(sample_A(1,:),sample_A(2,:))
title('4b) condition A')

sample_B1 = mvnrnd(mu_B1,Sig_B1,N*P1);
sample_B2 = mvnrnd(mu_B2,Sig_B2,N*P2);
sample_B = [sample_B1;sample_B2]';
figure(2)
% scatter(sample_B1(:,1),sample_B1(:,2))
% hold on
% scatter(sample_B2(:,1),sample_B2(:,2))
scatter(sample_B(1,:),sample_B(2,:))
title('4b) condition B')
%% Problem 4c)
% drawArrow = @(x,y) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0 )  
drawArrow = @(x,y,varargin) quiver( 0,0,x(1),y(1),0  ,varargin{:} );

% mean-centering
% X_A = (eye(N)-1/N*ones(N))*sample_A';
% X_B = (eye(N)-1/N*ones(N))*sample_B';
C_A = myPCA(sample_A);
C_B = myPCA(sample_B);

% [Ua,Sa,Va] = svd(X_A);
% [Ub,Sb,Vb] = svd(X_B);

% P_A = Va';
C1_A = C_A(:,1);
C1_B = C_B(:,1);
z_A = C1_A'*(sample_A-mean(sample_A,2));
z_B = C1_B'*(sample_B-mean(sample_B,2));

% largeP_A = P_A(:,1);
% z_A = largeP_A'*X_A';
% pcA = [0,10*largeP_A(1,:);0,10*largeP_A(2,:)];

figure(3)
scatter(sample_A(1,:),sample_A(2,:))
hold on
k = 5;
drawArrow(k*C1_A(1),k*C1_A(2),'linewidth',2)
title('4c) condition A - principal component')
% P_B = Vb';
% largeP_B = P_B(:,1);
% z_B = largeP_B'*X_B';
% pcB = [0,10*largeP_B(1,:);0,10*largeP_B(2,:)];
figure(4)
scatter(sample_B(1,:),sample_B(2,:))
hold on 
k = 5;
drawArrow(k*C1_B(1),k*C1_B(2),'linewidth',2)
title('4c) condition B - principal component')

% plot(LdB(1,:),LdB(2,:))
% coeffA = pca(sample_A')
% coeffB = pca(sample_B');


%% Problem 4d)
w_A = (cov(sample_A1)+ cov(sample_A2))\(mean(sample_A1)'-mean(sample_A2)');
w_B = (cov(sample_B1)+ cov(sample_B2))\(mean(sample_B1)'-mean(sample_B2)');

% w_A = (Sig_A1 + Sig_A2)\(mu_A1-mu_A2);
% w_B = (Sig_B1 + Sig_B2)\(mu_B1-mu_B2);

figure(5)
hold on
scatter(sample_A(1,:),sample_A(2,:))
k = 1;
drawArrow(k*w_A(1),k*w_A(2),'linewidth',2)
title('4d) condition A - linear discriminant normal vector')
figure(6)
scatter(sample_B(1,:),sample_B(2,:))
hold on
k = 1;
drawArrow(k*w_B(1),k*w_B(2),'linewidth',2)
title('4d) condition B - linear discriminant normal vector')
