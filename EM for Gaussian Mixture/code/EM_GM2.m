% clear all
% close all
%% Load Training Data

load('TrainingSamplesDCT_8_new.mat')
ZigZagPattern = dlmread('Zig-Zag Pattern.txt')+1;
ZZ = ZigZagPattern(:);

C = TrainsampleDCT_FG;
G = TrainsampleDCT_BG;

Prior_C = length(C)/(length(G)+length(C));
Prior_G = 1-Prior_C;


%% Import Test Image
Image = imread('cheetah.bmp');
Image = im2double(Image);
Truth = imread('cheetah_mask.bmp');
Truth = im2double(Truth);
k = 7;
Pad_Image = padarray(Image,[k k],'replicate');
% Pad_Image = padarray(Image,[7 7],'circular');
A = zeros(size(Pad_Image,1)-7,size(Pad_Image,2)-7);

%% Hyperparameters
% ERROR = [];
mix = [1,2,4,8,16,32];
for q = 4:length(mix)
    
    c = mix(q);
    dim = 64;
    NC = length(C);
    NG = length(G);
    th = 0.00001;
    
    
    %% Initialization
    
    % alpha - mixture weights
    alpha_C = rand(c,1);
    alpha_C = alpha_C/sum(alpha_C);
    alpha_G = rand(c,1);
    alpha_G = alpha_G/sum(alpha_G);
    % mu - mean
    mu_C = rand(c,dim);
    mu_G = rand(c,dim);
    % covar - covariances
    var_C = zeros(c,dim,dim);
    var_G = zeros(c,dim,dim);
    for i = 1:c
        var_C(i,:,:) = diag(normrnd(10,2,[1,dim]));
        var_G(i,:,:) = diag(normrnd(10,2,[1,dim]));
    end
    
    %% Training - EM for Gaussian Mixture (Foreground - Cheetah)
    
    e = 100;
    L_C_last = 100;
    i = 0;
    
    while(e > th)
        % E-Step
        H_C = zeros(NC,c);
        for j = 1:c
            Var_C = squeeze(var_C(j,:,:));
            H_C(:,j) = mvnpdf(C, mu_C(j,:),Var_C)*alpha_C(j);
        end
        H_C = H_C./sum(H_C,2);
        
        % M-step
        alpha_C = sum(H_C)/NC;
        for j = 1:c
            mu_C(j,:) = sum(H_C(:,j).*C)/sum(H_C(:,j));
            d = C-mu_C(j,:);
            var_C(j,:,:) = diag(sum(H_C(:,j).*(d.*d))/sum(H_C(:,j)));
        end
        
        % Calculate Likelihood
        L_C = 0;
        for j = 1:c
            Var_C = squeeze(var_C(j,:,:));
            B_C = H_C(:,j).*log(mvnpdf(C, mu_C(j,:),Var_C)*alpha_C(j));
            L_C = L_C+ sum(B_C);
        end
        e = abs(L_C-L_C_last);
        L_C_last = L_C;
        
        i = i+1;
        
    end
    
    %% Training - EM for Gaussian Mixture (Background - Grass)
    
    e = 100;
    L_G_last = 100;
    i = 0;
    
    while(e > th)
        % E-Step
        H_G = zeros(NG,c);
        for j = 1:c
            Var_G = squeeze(var_G(j,:,:));
            H_G(:,j) = mvnpdf(G, mu_G(j,:),Var_G)*alpha_G(j);
        end
        H_G = H_G./sum(H_G,2);
        
        % M-step
        alpha_G = sum(H_G)/NG;
        for j = 1:c
            mu_G(j,:) = sum(H_G(:,j).*G)/sum(H_G(:,j));
            d = G-mu_G(j,:);
            var_G(j,:,:) = diag(sum(H_G(:,j).*(d.*d))/sum(H_G(:,j)));
        end
        
        % Calculate Likelihood
        L_G = 0;
        for j = 1:c
            Var_G = squeeze(var_G(j,:,:));
            B_G = H_G(:,j).*log(mvnpdf(G, mu_G(j,:),Var_G)*alpha_G(j));
            L_G = L_G+ sum(B_G);
        end
        e = abs(L_G-L_G_last);
        L_G_last = L_G;
        
        i = i+1;
        
    end
    
    
    %% Testing
    dims = [1,2,4,8,16,24,32,40,48,56,64];
    
    for m = 1:length(dims)
        pdim = dims(m);
        D = zeros(pdim,64);
        z = full(ind2vec(1:pdim));
        D(vec2ind(z),vec2ind(z)) = z;
        
        for i = 1:size(Pad_Image,1)-7
            
            for j = 1:size(Pad_Image,2)-7
                % 8x8 Block
                Block = Pad_Image(i:i+7,j:j+7);
                % Compute DCT
                Block = dct2(Block);
                % Zig Zag
                BlockZig(ZigZagPattern) = Block;
                
                %             X = BlockZig';
                X = D*BlockZig';
                
                cc = 0;
                gg = 0;
                for k = 1:c
                    Var_C = squeeze(var_C(k,:,:));
                    Var_G = squeeze(var_G(k,:,:));
                    
                    U_C = D*mu_C(k,:)';
                    U_G = D*mu_G(k,:)';
                    E_C = D*Var_C*D';
                    E_G = D*Var_G*D';
                    cc = cc + mvnpdf(X,U_C,E_C)*alpha_C(k)*Prior_C;
                    gg = gg + mvnpdf(X,U_G,E_G)*alpha_G(k)*Prior_G;
                    
                end
                [~,A(i,j)] = max([gg,cc]);
                
            end
        end
        m
        %% PoE
        
        A = double(A)-1;
        A2 = A(1:end-7,1:end-7);
        %             figure(1)
        %             imagesc(A2)
        %             colormap(gray(255))
        Error(m) = 1-sum(sum(A2==Truth))/(255*270);
        
        
    end
    
    q
    ERROR = [ERROR;Error];
end
%% Plots
figure(1)
plot(dims,ERROR,'LineWidth',1)
legend('C = 1','C = 2','C = 4','C = 8','C = 16','C = 32','Location','best');
xlabel('dim')
ylabel('PoE')
title('PoE vs Dim')
savefig('6b');
T = toc




