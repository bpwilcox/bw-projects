%Plots ONLY Slow trial data vs Mean velocity

clear all

load SubjectData.mat


% Values determined from Subject Sheet 
S1 = [5 6];
S2 = [18 19 20 21];
S3 = [7 8];
S4 = [6 7];
S5 = [11 12];
S6 = [11 12];
S7 = [7 8 9 10];
S8 = [7 8];
S9 = [7 8 9 10];
S10 = [13 14 15 16];


MVel = [Data(1).MeanVel(S1)';Data(2).MeanVel(S2)';Data(3).MeanVel(S3)';Data(4).MeanVel(S4)';Data(5).MeanVel(S5)';Data(6).MeanVel(S6)';Data(7).MeanVel(S7)';Data(8).MeanVel(S8)';Data(9).MeanVel(S9)';Data(10).MeanVel(S10)'];
SVel = [Data(1).StdVel(S1)';Data(2).StdVel(S2)';Data(3).StdVel(S3)';Data(4).StdVel(S4)';Data(5).StdVel(S5)';Data(6).StdVel(S6)';Data(7).StdVel(S7)';Data(8).StdVel(S8)';Data(9).StdVel(S9)';Data(10).StdVel(S10)'];

% MVel = [Data(1).MeanVel';Data(2).MeanVel';Data(3).MeanVel';Data(4).MeanVel';Data(5).MeanVel';Data(6).MeanVel';Data(7).MeanVel';Data(8).MeanVel';Data(9).MeanVel';Data(10).MeanVel'];
% SVel = [Data(1).StdVel';Data(2).StdVel';Data(3).StdVel';Data(4).StdVel';Data(5).StdVel';Data(6).StdVel';Data(7).StdVel';Data(8).StdVel';Data(9).StdVel';Data(10).StdVel'];


%%%%%%%%%%%%%%%%%
Ratio = SVel./MVel; %CV

[K,I]=sort(MVel);
L = Ratio(I);
% Lslow =SVel(I);



a=find(K==1);
b=find(K==-1);
K(a)=[];
K(b)=[];
L(a)=[];
L(b)=[];


Lslow=Ratio;

% Saved for use in CVDirSpeed.m
save('slow.mat','Lslow')


% plot(K/(2*pi*.1),L/(2*pi*.1),'o');
plot(K/(2*pi*.1),L,'o');

xlabel('Mean Velocity (rev/s)')
ylabel('Ratio STD Vel/Mean Vel')
title('Velocity Fluctuations: Slow')
% legend(['y = ' num2str(round(p2(1),2)) 'x + ' num2str(round(p2(2),2))])
set(gca, 'FontSize', 14, 'FontWeight', 'bold');

hold on 
M = mean(K/(2*pi*.1));
ss = std(K/(2*pi*.1));
ha = area([mean(K/(2*pi*.1))-ss mean(K/(2*pi*.1))+ss], [0.7 0.7],'FaceAlpha',0.2);
axis([0.04 .1 0.2 0.7])

y1=get(gca,'ylim')


hold on
plot([mean(K/(2*pi*.1)) mean(K/(2*pi*.1))],y1)
text(mean(K/(2*pi*.1))-0.0005,0.6,'Mean','Rotation',90,'FontSize',12)
hold on
plot([0.075 0.075],y1)
text(0.075-0.0005,0.6,'Slow','Rotation',90,'FontSize',12)


% refline(0,mean(L/(2*pi*.1)))
refline(0,mean(L))

CVSlow = mean(L);
CVSlowS = std(L);