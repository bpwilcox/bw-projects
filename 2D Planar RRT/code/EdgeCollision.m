function [c, qnew]= EdgeCollision(dq,qnear,qrand,R,w,obs)

if dq > norm(qrand-qnear)
    c = 1;
    qnew = qnear;   
else
    t = 0:dq:norm(qrand-qnear);
    t = [t norm(qrand-qnear)];

    for i = 1:length(t)
        
        qnew = qnear + t(i)*(qrand-qnear)/norm(qrand-qnear);
        
        if sign((qnew(2)-pi)*(qnear(2)-pi))== -1 || sign((qnew(2)-pi)*(qnear(2)-pi))== 0
            c = 0;
        else
            P = generateArmPolygons(R, qnew, w);
            c = gjk2Darray(P,obs);
        end
        if c ==0
            qnew = qnear + t(i-1)*(qrand-qnear)/norm(qrand-qnear);
            return
        end
        
    end
    
end