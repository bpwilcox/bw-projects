function [xk_opt Pk] = K_update(xk_pred,K,x_meas,V,Hk,Pk)

Pk = Pk-K*Hk'*Pk;
xk_opt = xk_pred + K*([x_meas;V] - Hk*xk_pred);

end