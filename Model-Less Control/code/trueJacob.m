function J = trueJacob(Q)

dyi1 = 0.001;
Q(1) = Q(1) +dyi1;
Xi1 = forwardkin(Q);
Q(1) = Q(1)-dyi1;
dxi1 = Xi1 - forwardkin(Q);

dyi2= 0.001;
Q(2) = Q(2)+dyi2;
Xi2 = forwardkin(Q);
Q(2) = Q(2)-dyi2;
dxi2 = Xi2-forwardkin(Q);

J = [dxi1/dyi1, dxi2/dyi2];

end