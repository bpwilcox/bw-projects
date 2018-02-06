function plotrobot2(Q,xd,T,im,map)

Parameters2;

l = l1+Q(3);

Origin =[0 0];
Link1 = [l*cos(Q(1)) l*sin(Q(1))];
Link2 =[l*cos(Q(1))+l2*cos(Q(1)+Q(2));l*sin(Q(1))+l2*sin(Q(1)+Q(2))];
Joint = [l1*cos(Q(1)) l1*sin(Q(1))];

figure(1)
plot([Origin(1) Link1(1)],[Origin(2) Link1(2)],'b','LineWidth',4)
hold on
plot([Link1(1) Link2(1)],[Link1(2) Link2(2)],'b','LineWidth',4)

plot(Origin(1),Origin(2),'ro','MarkerFaceColor','r')
plot(Joint(1),Joint(2),'ro','MarkerFaceColor','r')
plot(xd(1),xd(2),'+')
plot(Link1(1),Link1(2),'ro','MarkerFaceColor','r')
plot(Link2(1),Link2(2),'ro','MarkerFaceColor','r')

title(strcat('Time: ',num2str(T)))


whitebg([1 1 1]);

axis([-0.5 1 -0.5 1])
daspect([1 1 1])

% f=getframe;
% im(:,:,1,T/0.01) = rgb2ind(f.cdata,map,'nodither');
drawnow limitrate
end