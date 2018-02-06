function Jinv_new = calcinvJ(Jinv,dQ,dX)

% Method 1
% Jinv_new = Jinv + (dQ-Jinv*dX)*dX'/norm(dX)^2;  

% Method 2
Jinv_new = Jinv+((dQ-Jinv*dX)/(dQ'*Jinv*dX))*dQ'*Jinv;
end
