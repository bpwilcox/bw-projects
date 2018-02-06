function J = jacob2(Q)
Parameters2;
% J = [-l1*sin(Q(1)) (lend-l2)*sin(Q(2));l1*cos(Q(1)) -(lend-l2)*cos(Q(2))];
J = [-(l1+Q(3))*sin(Q(1))-l2*sin(Q(1)+Q(2)), -l2*sin(Q(1)+Q(2)), cos(Q(1));(l1+Q(3))*cos(Q(1))+l2*cos(Q(1)+Q(2)), l2*cos(Q(1)+Q(2)), sin(Q(1))];
% J = [-(l1+Q(3))*sin(Q(1)), -l2*sin(Q(2)), cos(Q(1));(l1+Q(3))*cos(Q(1)), l2*cos(Q(2)), sin(Q(1))];
end