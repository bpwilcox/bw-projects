function [containsOrigin, simplex, d] = containsOriginCheck(simplex)
    a = simplex(end,:);
    ao = -a;
    if size(simplex,1) == 3
        b = simplex(2,:);
        c = simplex(1,:);
        ab = b - a;
        ac = c - a;
        
        d = [-ab(2), ab(1)];
        if d*c' > 0, d = -d; end
        if d*ao'>0
            simplex(1,:) = [];
            containsOrigin = false;
            return;
        end
        
        d = [-ac(2), ac(1)];
        if d*b' > 0, d = -d; end
        if d*ao'>0
            simplex(2,:) = [];
            containsOrigin = false;
            return;
        end
        
        containsOrigin = true;
        return;
    else
        b = simplex(1,:);
        ab = b - a;
        d = [-ab(2), ab(1)];
        if d*ao' < 0, d = -d; end
        containsOrigin = false;
        return;
    end
end