% Plots Standard Dev vs Mean velocity for 3 different subjects

close all
clear all

load SubjectData.mat


[K,I]=sort(Data(7).MeanVel);
L = Data(7).StdVel(I);

subplot(1,3,1)
plot(K/(2*pi*.1),L/(2*pi*.1),'o');
h = lsline;
p2 = polyfit(get(h,'xdata'),get(h,'ydata'),1);
xlabel('Mean Velocity (rev/s)')
ylabel('STD Vel (rev/s)')
title('G')
legend(['y = ' num2str(round(p2(1),2)) 'x + ' num2str(round(p2(2),2))])
set(gca, 'FontSize', 14, 'FontWeight', 'bold');

[K,I]=sort(Data(9).MeanVel);
L = Data(9).StdVel(I);

subplot(1,3,2)


plot(K/(2*pi*.1),L/(2*pi*.1),'o');
h = lsline;
p2 = polyfit(get(h,'xdata'),get(h,'ydata'),1);
xlabel('Mean Velocity (rev/s)')
ylabel('STD Vel (rev/s)')
title('I')
legend(['y = ' num2str(round(p2(1),2)) 'x + ' num2str(round(p2(2),2))])
set(gca, 'FontSize', 14, 'FontWeight', 'bold');


[K,I]=sort(Data(10).MeanVel);
L = Data(10).StdVel(I);
subplot(1,3,3)

plot(K/(2*pi*.1),L/(2*pi*.1),'o');
h = lsline;
p2 = polyfit(get(h,'xdata'),get(h,'ydata'),1);
xlabel('Mean Velocity (rev/s)')
ylabel('STD Vel (rev/s)')
title('J')
legend(['y = ' num2str(round(p2(1),2)) 'x + ' num2str(round(p2(2),2))])
set(gca, 'FontSize', 14, 'FontWeight', 'bold');
