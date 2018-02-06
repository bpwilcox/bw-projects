function J = trueJacob2(Q)


dyi1 = 0.001;
Q(1) = Q(1) +dyi1;
Xi1 = forwardkin_2(Q);
Q(1) = Q(1)-dyi1;
dxi1 = Xi1 - forwardkin_2(Q);

dyi2= 0.001;
Q(2) = Q(2)+dyi2;
Xi2 = forwardkin_2(Q);
Q(2) = Q(2)-dyi2;
dxi2 = Xi2-forwardkin_2(Q);

if length(Q)==2
    J = [dxi1/dyi1, dxi2/dyi2];
    
elseif length(Q)==3
    dyi3= 0.001;
    Q(3) = Q(3)+dyi3;
    Xi3 = forwardkin_2(Q);
    Q(3) = Q(3)-dyi3;
    dxi3 = Xi3-forwardkin_2(Q);
    
    J = [dxi1/dyi1, dxi2/dyi2, dxi3/dyi3];
    
end

end