function plotrobot(A,xd,T)

Parameters;

Origin =[0 0];
Link1 =[l1*cos(A(1)) l1*sin(A(1))];
Link2 =[l2*cos(A(2)) l2*sin(A(2))];
Link3 = [l2*cos(A(2))+l1*cos(A(1)) l2*sin(A(2))+l1*sin(A(1))];
Link4 = [l1*cos(A(1))-(lend-l2)*cos(A(2)) l1*sin(A(1))-(lend-l2)*sin(A(2))];

% figure(1)
% P1 = subplot(1,2,1);
plot(Origin(1),Origin(2),'ro')
hold on

plot(xd(1),xd(2),'+')
% plot(x,y)
plot(Link1(1),Link1(2),'ro')
plot(Link2(1),Link2(2),'ro')
plot(Link3(1),Link3(2),'ro')
plot(Link4(1),Link4(2),'ro')


plot([Origin(1) Link1(1)],[Origin(2) Link1(2)],'b')
plot([Origin(1) Link2(1)],[Origin(2) Link2(2)],'b')

plot([Link2(1) Link3(1)],[Link2(2) Link3(2)],'b')
plot([Link3(1) Link4(1)],[Link3(2) Link4(2)],'b')
title(strcat('Time: ',num2str(T)))
% text(-0.1,0.6,strcat('Updates:  ',num2str(count)))
axis([-0.5 0.6 -0.5 0.7])
daspect([1 1 1])


drawnow

% P2 = subplot(1,2,2);

% plot3(A(1),A(2),J(1,1),'.-')
% axis([0 2*pi 0 2*pi -1.5 1.5])
% hold on
% 
% drawnow
end