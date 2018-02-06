%%simulation
function F=cranksim(Q)
close all


xc = 0.2;
yc = 0.4;
r0=0.1;
theta = 0:0.01:2*pi;
x = xc+r0*cos(theta);
y = yc+r0*sin(theta);

for i = 1:length(Q)
A = Q(i,1:2);
Parameters;

Origin =[0 0];
Link1 =[l1*cos(A(1)) l1*sin(A(1))];
Link2 =[l2*cos(A(2)) l2*sin(A(2))];
Link3 = [l2*cos(A(2))+l1*cos(A(1)) l2*sin(A(2))+l1*sin(A(1))];
Link4 = [l1*cos(A(1))-(lend-l2)*cos(A(2)) l1*sin(A(1))-(lend-l2)*sin(A(2))];


plot(x,y)

plot(Origin(1),Origin(2),'ro')
hold on
plot(x,y)
plot(Link1(1),Link1(2),'ro')
plot(Link2(1),Link2(2),'ro')
plot(Link3(1),Link3(2),'ro')
plot(Link4(1),Link4(2),'ro')


plot([Origin(1) Link1(1)],[Origin(2) Link1(2)],'b')
plot([Origin(1) Link2(1)],[Origin(2) Link2(2)],'b')

plot([Link2(1) Link3(1)],[Link2(2) Link3(2)],'b')
plot([Link3(1) Link4(1)],[Link3(2) Link4(2)],'b')

% set(gcf,'Visible', 'off'); 
% axis equal
axis([-0.5 0.6 -0.5 0.7])
daspect([1 1 1])
F(i)=getframe;
clf
% close all

% hold on
% plot(Link2,'bo')
% hold on
% plot(Link3,'bo')
% hold on
% plot(Link4,'bo')

end
myVideo = VideoWriter('myfile.avi');
uncompressedVideo = VideoWriter('myfile.avi', 'Uncompressed AVI');
myVideo.FrameRate = 100;  % Default 30
% myVideo.Quality = 75;    % Default 75
open(myVideo);
writeVideo(myVideo, F);
close(myVideo);

end