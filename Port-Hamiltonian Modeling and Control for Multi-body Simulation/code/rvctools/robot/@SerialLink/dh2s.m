function s = dh2s(robot)
    
    s = '';
    varcount = 1;
    
    for j=1:robot.n
        L = robot.links(j);
        
        if L.isrevolute()
            s = append(s, 'Rz(q%d)', j);
            if L.d ~= 0
                s = append(s, 'Tz(L%d)', varcount);
                varcount = varcount+1;
            end
        else
            if L.theta ~= 0
                s = append(s, 'Rz(%d)', round(L.alpha*180/pi));
            end
            s = append(s, 'Tz(q%d)', j);
            
        end
        
        if L.a ~= 0
            s = append(s, 'Tx(L%d)', varcount);
            varcount = varcount+1;
            
        end
        if L.alpha ~= 0
            s = append(s, 'Rx(%d)', round(L.alpha*180/pi));
        end
    end
end


function s = append(s, fmt, j)
    s = strcat(s, sprintf(fmt, j));
end
