close all
clear all
%% Problem 5a

X = [];
for i = 0:5
    images = dir(strcat('trainset\subset',num2str(i),'\*.jpg'));
    for j = 1:40
        Temp = imread(strcat('trainset\subset',num2str(i),'\',images(j).name));
        X = [X, Temp(:)];
    end
end
X = double(X);
C = myPCA(X);
C16 = C(:,1:16);

figure(3)
for k = 1:16
    A = reshape(C16(:,k),50,50);
    subplot(4,4,k)   
    imshow(A,'DisplayRange',[])
end
suptitle('5a) 16 principal components of largest variance')
%% Problem 5b
k = 5;
m = [];
% E = [];
E = cell(1,6);
for i = 0:k
    Xb = [];
    images = dir(strcat('trainset\subset',num2str(i),'\*.jpg'));
    for j = 1:40
        Temp = imread(strcat('trainset\subset',num2str(i),'\',images(j).name));
        Xb = [Xb, Temp(:)];
    end
    Xb = double(Xb); 
    m = [m mean(Xb,2)];
%     E = [E cov(X')];
    E{i+1} = cov(Xb');
end

w = [];
gamma = 1;
for i = 1:6
    for j = 1:6
    if i ==j
        continue
    elseif i > j
            continue
    else
        temp = (E{i}+E{j}+gamma*eye(2500))\(m(:,i)-m(:,j)); 
        w = [w temp];
    end
        
    
    end
end
figure(4)
for p = 1:15
    B = reshape(w(:,p),50,50);
    subplot(4,4,p)   
    imshow(B,'DisplayRange',[])
end
suptitle('5b) 15 linear discriminants')

%% Problem 5c
C15 = C(:,1:15)';
z = C15*(X-mean(X,2));

mc = [];
Ec = cell(1,6);
for i = 1:6
    temp = z(:,40*(i-1)+1:40*i);
    mc = [mc mean(temp,2)];
    Ec{i} = cov(temp');
end

Y = [];
for i = 6:11
    images = dir(strcat('testset\subset',num2str(i),'\*.jpg'));
    for j = 1:10
        Temp = imread(strcat('testset\subset',num2str(i),'\',images(j).name));
        Y = [Y, Temp(:)];
    end
end

Y = double(Y);
Y = Y - mean(X,2);

z_y = C15*Y;
for k = 1:6
y(:,k) = mvnpdf(z_y',mc(:,k)',Ec{k});
end

[M,I] = max(y,[],2);
t = ones(10,1);
True = [t;2*t;3*t;4*t;5*t;6*t];
correct = I==True;
acc = sum(correct)/length(correct);
PoE_c = 1-acc

%% Problem 5d

z = w'*X;

md = [];
Ed = cell(1,6);
for i = 1:6
    temp = z(:,40*(i-1)+1:40*i);
    md = [md mean(temp,2)];
%     E = [E cov(X')];
    Ed{i} = cov(temp');
end

Y = [];
for i = 6:11
    images = dir(strcat('testset\subset',num2str(i),'\*.jpg'));
    for j = 1:10
        Temp = imread(strcat('testset\subset',num2str(i),'\',images(j).name));
        Y = [Y, Temp(:)];
    end
end
Y = double(Y);

z_yd = w'*Y;

for k = 1:6
    for j = 1:60
        yd(j,k) = (z_yd(:,j)-md(:,k))'/(Ed{k})*(z_yd(:,j)-md(:,k))+log(det(Ed{k}));
    end
end

[~,Id] = min(yd,[],2);
t = ones(10,1);
True = [t;2*t;3*t;4*t;5*t;6*t];
correctd = Id==True;
accd = sum(correctd)/length(correctd);
PoE_d = 1-accd

%% Problem 5e

% Apply PCA
C30 = C(:,1:30)';
z = C30*(X-mean(X,2));
Y = [];
for i = 6:11
    images = dir(strcat('testset\subset',num2str(i),'\*.jpg'));
    for j = 1:10
        Temp = imread(strcat('testset\subset',num2str(i),'\',images(j).name));
        Y = [Y, Temp(:)];
    end
end
Y = double(Y);
z_y = C30*(Y-mean(Y,2));

% Solve for linear discriminant
m = [];
E = cell(1,6);
for i = 1:6
    temp = z(:,40*(i-1)+1:40*i);
    m = [m mean(temp,2)];
    E{i} = cov(temp');
end

w = [];
gamma = 0;
for i = 1:6
    for j = 1:6
        if i ==j
            continue
        elseif i > j
            continue
        else
            temp = (E{i}+E{j}+gamma*eye(30))\(m(:,i)-m(:,j));
            w = [w temp];
        end        
    end
end

% apply LDA
ze = w'*z;
me = [];
Ee = cell(1,6);
for i = 1:6
    temp = ze(:,40*(i-1)+1:40*i);
    me = [me mean(temp,2)];
    Ee{i} = cov(temp');
end

z_ye = w'*z_y;

for k = 1:6
    for j = 1:60
        ye(j,k) = (z_ye(:,j)-me(:,k))'/(Ee{k})*(z_ye(:,j)-me(:,k))+log(det(Ee{k}));
    end
end

[~,Ie] = min(ye,[],2);
t = ones(10,1);
True = [t;2*t;3*t;4*t;5*t;6*t];
correcte = Ie==True;
acce = sum(correcte)/length(correcte);
PoE_e = 1-acce
