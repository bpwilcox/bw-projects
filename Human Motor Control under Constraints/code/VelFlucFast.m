%Velocity Fluctations Fast
load SubjectData.mat

F1 = [9 10];
F2 = [26 27 28];
F3 = [11 12];
F4 = [10 11];
F5 = [9 10];
F6 = [9 10];
F7 = [11 12 13 14];
F8 = [11 12];
F9 = [11 12 13 14];
F10 = [17 18 19 20];


MVel = [Data(1).MeanVel(F1)';Data(2).MeanVel(F2)';Data(3).MeanVel(F3)';Data(4).MeanVel(F4)';Data(5).MeanVel(F5)';Data(6).MeanVel(F6)';Data(7).MeanVel(F7)';Data(8).MeanVel(F8)';Data(9).MeanVel(F9)';Data(10).MeanVel(F10)'];
SVel = [Data(1).StdVel(F1)';Data(2).StdVel(F2)';Data(3).StdVel(F3)';Data(4).StdVel(F4)';Data(5).StdVel(F5)';Data(6).StdVel(F6)';Data(7).StdVel(F7)';Data(8).StdVel(F8)';Data(9).StdVel(F9)';Data(10).StdVel(F10)'];




Ratio = SVel./MVel;

[K,I]=sort(MVel);
L = Ratio(I);

a=find(K==1);
b=find(K==-1);
K(a)=[];
K(b)=[];
L(a)=[];
L(b)=[];

Lfast=Ratio;
save('fast.mat','Lfast')

% K=K(1:25);
% L=L(1:25);
% subplot(1,3,1)
% plot(K/(2*pi*.1),L/(2*pi*.1),'o');
plot(K/(2*pi*.1),L,'o');
% h = lsline

% p2 = polyfit(get(h,'xdata'),get(h,'ydata'),1)
xlabel('Mean Velocity (rev/s)')
ylabel('Ratio STD Vel/Mean Vel')
title('Velocity Fluctuations: Fast')
% legend(['y = ' num2str(round(p2(1),2)) 'x + ' num2str(round(p2(2),2))])
set(gca, 'FontSize', 14, 'FontWeight', 'bold');

hold on 
M = mean(K/(2*pi*.1));
ss = std(K/(2*pi*.1));
ha = area([mean(K/(2*pi*.1))-ss mean(K/(2*pi*.1))+ss], [0.4 0.4],'FaceAlpha',0.2);
axis([1.7 2.1 0.04 0.12])

y1=get(gca,'ylim')


hold on
plot([mean(K/(2*pi*.1)) mean(K/(2*pi*.1))],y1)
text(mean(K/(2*pi*.1)),0.1,'Mean','Rotation',90,'FontSize',12)
hold on
plot([2 2],y1)
text(2,0.1,'Fast','Rotation',90,'FontSize',12)


% refline(0,mean(L/(2*pi*.1)))
refline(0,mean(L))


CVFast = mean(L);
CVFastS = std(L);
