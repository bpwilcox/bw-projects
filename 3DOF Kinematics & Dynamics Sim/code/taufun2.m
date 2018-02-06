function tau = taufun2(bot,t,q,qd,D,C,G,M,Mp,L,R,m,mp,l,r,th,dth,qt,tref)


D = double(subs(D,[th m mp l r],[q(1:3) M Mp L R]));
C = double(subs(C,[th dth m mp l],[q(1:3) qd(1:3) M Mp L]));
G = double(subs(G,[th m mp l sym('g')],[q(1:3) M Mp L 9.81]));

tau_comp = D*[0 0 0].' + C*qd(1:3).' + G;

tau_comp = [tau_comp; 0];

if t>qt(length(qt),1)
    t=qt(length(qt),1);
end
q_des=interp1(tref,qt(:,1:4),t);

Kp = eye(4)*100;
tau = tau_comp + Kp*(q_des.'-q.') ;

tau = tau.';
end