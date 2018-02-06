function [xk_pred, Pk ,K] = K_pred(Fk,Pk,Hk,Q_noise,xk_last,V,Rk)


xk_pred = Fk*[xk_last;V];



Pk = Fk*Pk*Fk+ Q_noise; 
S = Hk*Pk*Hk'+Rk;
K = Pk*Hk'*inv(S);

end