function tau = taufun(bot,t,q,qd,D,C,G,M,Mp,L,R,m,mp,l,r,th,dth)

D = double(subs(D,[th m mp l r],[q(1:3) M Mp L R]));
C = double(subs(C,[th dth m mp l],[q(1:3) qd(1:3) M Mp L]));
G = double(subs(G,[th m mp l sym('g')],[q(1:3) M Mp L 9.81]));



tau = D*[0 0 0].' + C*qd(1:3).' + G;
if length(q) > 3
tau = [tau; 0];
end
tau = tau.';

end