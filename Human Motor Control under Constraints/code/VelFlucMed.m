
% Plots ONLY Medium CV and Mean Velocity
load SubjectData.mat

M1 = [7 8];
M2 = [22 23 24 25];
M3 = [9 10];
M4 = [8 9];
M5 = [7 8];
M6 = [7 8];
M7 = [15 16 17 18];
M8 = [9 10];
M9 = [15 16 17 18];
M10 = [9 10 11 12];

MVel = [Data(1).MeanVel(M1)';Data(2).MeanVel(M2)';Data(3).MeanVel(M3)';Data(4).MeanVel(M4)';Data(5).MeanVel(M5)';Data(6).MeanVel(M6)';Data(7).MeanVel(M7)';Data(8).MeanVel(M8)';Data(9).MeanVel(M9)';Data(10).MeanVel(M10)'];
SVel = [Data(1).StdVel(M1)';Data(2).StdVel(M2)';Data(3).StdVel(M3)';Data(4).StdVel(M4)';Data(5).StdVel(M5)';Data(6).StdVel(M6)';Data(7).StdVel(M7)';Data(8).StdVel(M8)';Data(9).StdVel(M9)';Data(10).StdVel(M10)'];




Ratio = SVel./MVel;

[K,I]=sort(MVel);
L = Ratio(I);

a=find(K==1);
b=find(K==-1);
K(a)=[];
K(b)=[];
L(a)=[];
L(b)=[];

Lmed=Ratio;
save('med.mat','Lmed')

% K=K(1:25);
% L=L(1:25);
% subplot(1,3,1)
% plot(K/(2*pi*.1),L/(2*pi*.1),'o');
plot(K/(2*pi*.1),L,'o');
% h = lsline

% p2 = polyfit(get(h,'xdata'),get(h,'ydata'),1)
xlabel('Mean Velocity (rev/s)')
ylabel('Ratio STD Vel/Mean Vel')
title('Velocity Fluctuations: Med')
% legend(['y = ' num2str(round(p2(1),2)) 'x + ' num2str(round(p2(2),2))])
set(gca, 'FontSize', 14, 'FontWeight', 'bold');

hold on 
M = mean(K/(2*pi*.1));
ss = std(K/(2*pi*.1));
ha = area([mean(K/(2*pi*.1))-ss mean(K/(2*pi*.1))+ss], [0.4 0.4],'FaceAlpha',0.2);
axis([0.45 .65 0.05 0.25])

y1=get(gca,'ylim')


hold on
plot([mean(K/(2*pi*.1)) mean(K/(2*pi*.1))],y1)
text(mean(K/(2*pi*.1)),0.2,'Mean','Rotation',90,'FontSize',12)
hold on
plot([0.5 0.5],y1)
text(0.5,0.2,'Med','Rotation',90,'FontSize',12)


% refline(0,mean(L/(2*pi*.1)))
refline(0,mean(L))

CVMed = mean(L);
CVMedS = std(L);