function Jopt = calcJ(J,dQ,dX)

% Method 1
Jopt = J+(dX-J*dQ)*dQ'/norm(dQ)^2;

% Jinv_opt = pinv(Jopt)

end