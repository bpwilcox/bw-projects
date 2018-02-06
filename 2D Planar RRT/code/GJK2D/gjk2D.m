function incollision = gjk2D(A, B)
% if any(min(A)>max(B)) || any(min(B)>max(A))
%     incollision = false;
% else
    d = [0 1];
    simplex = getSupport(A, B, d);
    d = -d;
    while 1
        simplex = cat(1, simplex, getSupport(A, B, d));
        
        if simplex(end,:)*d' <= 0
            incollision = false;
            return;
        end
        [containsOrigin, simplex, d] = containsOriginCheck(simplex);
        if containsOrigin
            incollision = true;
            return;
        end
    end
% end
end