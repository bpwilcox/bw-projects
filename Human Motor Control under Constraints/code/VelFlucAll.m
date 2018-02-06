%Plots Standard Deviation vs Mean Velocity for all Subjects (and all trials) on one graph

close all
clear all

%velocity fluctuations of all speeds
load SubjectData.mat
MVel = [Data(1).MeanVel';Data(2).MeanVel';Data(3).MeanVel';Data(4).MeanVel';Data(5).MeanVel';Data(6).MeanVel';Data(7).MeanVel';Data(8).MeanVel';Data(9).MeanVel';Data(10).MeanVel'];
SVel = [Data(1).StdVel';Data(2).StdVel';Data(3).StdVel';Data(4).StdVel';Data(5).StdVel';Data(6).StdVel';Data(7).StdVel';Data(8).StdVel';Data(9).StdVel';Data(10).StdVel'];



%%%%%%%%%%%%%%%%%%
Ratio = SVel./MVel; % CV


[K,I]=sort(MVel);
% L = Ratio(I);

L = SVel(I);

%take out bad data points
a=find(K==1);
b=find(K==-1);
K(a)=[];
K(b)=[];
L(a)=[];
L(b)=[];

plot(K/(2*pi*.1),L/(2*pi*.1),'o');
h = lsline;
p2 = polyfit(get(h,'xdata'),get(h,'ydata'),1);


% Find R^2 value

x= K/(2*pi*.1);
y =L/(2*pi*.1);
p3 = polyfit(x,y,1);
% x= get(h,'xdata');
% y = get(h,'ydata');
yfit = polyval(p3,x);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal;



xlabel('Mean Velocity (rev/s)')
% ylabel('Coefficient of Variation')
ylabel('Standard Deviation (rev/s)')
title('Velocity Fluctuations - All Subjects (both CW and CCW)')

% legend(['y = ' num2str(round(p2(1),2)) 'x + ' num2str(round(p2(2),2))],'Location','east')
legend(['y = ' num2str(round(p2(1),2)) 'x + ' num2str(round(p2(2),2))],['R^2 = ' num2str(round(rsq,2))],'Location','east')
set(gca, 'FontSize', 14, 'FontWeight', 'bold');
y1=get(gca,'ylim')

hold on

plot([0.075 0.075],y1)
text(0.075+0.01,0.3,'Slow','Rotation',90,'FontSize',12)
hold on
plot([0.5 .5],y1)
text(0.5+0.01,0.3,'Med','Rotation',90,'FontSize',12)
hold on
plot([2 2],y1)
text(2+0.01,.3,'Fast','Rotation',90,'FontSize',12)


hold on 

% Values for mean slow, med, and fast and std were calculated offline
M1 = 0.0728; 
ss1 = 0.0099;
ha1 = area([M1-ss1 M1+ss1], [1.2 1.2],'FaceAlpha',0.2);
hold on 
M2 = 0.5219;
ss2 = 0.0293;
ha2 = area([M2-ss2 M2+ss2], [1.2 1.2],'FaceAlpha',0.2);
hold on 
M3 = 1.9149;
ss3 = 0.0691;
ha3 = area([M3-ss3 M3+ss3], [1.2 1.2],'FaceAlpha',0.2);
% axis([0 2.5 0 0.8])
axis([0 2.5 0 0.4])