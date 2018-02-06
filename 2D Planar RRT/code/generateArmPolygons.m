function P = generateArmPolygons(R,q,w)
P = cell(1, R.n);
linkT = eye(4);
T = zeros(4); T(end,:) = 1; T(2, [1 3]) = w/2; T(2, [2 4]) = -w/2;
for n = 1:R.n
    T(1,1:2) = -R.a(n);
    RA = [cos(q(n)) -sin(q(n)) 0 R.a(n)*cos(q(n));
        sin(q(n)) cos(q(n)) 0 R.a(n)*sin(q(n));
        0 0 1 0;
        0 0 0 1];
    linkT = linkT*RA;
    box = linkT*T;
    P{n} = box(1:2,:)';
       
end
end
