function X = forwardkin_2(Q)
Parameters2;
% X = [l1*cos(Q(1))-(lend-l2)*cos(Q(2));l1*sin(Q(1))-(lend-l2)*sin(Q(2))];
X = [(l1+Q(3))*cos(Q(1))+l2*cos(Q(1)+Q(2));(l1+Q(3))*sin(Q(1))+l2*sin(Q(1)+Q(2))];
% X = [(l1+Q(3))*cos(Q(1))+l2*cos(Q(2));(l1+Q(3))*sin(Q(1))+l2*sin(Q(2))];
end