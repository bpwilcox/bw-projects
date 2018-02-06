function C = myPCA(X)
% N = length(X);
N = size(X,2);
Z = (eye(N)-1/N*ones(N))*X';
% Z = X-mean(X,2);
[U,S,V] = svd(Z);
C = V;
end