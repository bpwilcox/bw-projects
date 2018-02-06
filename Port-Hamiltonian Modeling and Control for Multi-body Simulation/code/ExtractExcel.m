
subject = 1;
for i=1:14
    
trial =i;
filename = strcat(num2str(subject),'-Trial',num2str(trial),'.xlsx');
data = xlsread(filename);


figure(1)
subplot(2,2,1)
plot(data(:,1),data(:,2))
xlabel('Time (s)')
ylabel('EMG(elbow)')

subplot (2,2,2)
plot (data(:,1),data(:,3))
xlabel('Time (s)')
ylabel('Pressure')

subplot(2,2,3)
plot (data(:,1), data(:,4))
xlabel('Time (s)')
ylabel('Angle')


subplot(2,2,4)
plot (data(:,1), data(:,5))
xlabel('Time (s)')
ylabel('EMG(forearm)')

saveas(figure(1), strcat(num2str(subject),'-Trial',num2str(trial),'.fig'));
end

subject = 2;
for i=1:20
    
trial =i;
filename = strcat(num2str(subject),'-Trial',num2str(trial),'.xlsx');
data = xlsread(filename);


figure(1)
subplot(2,2,1)
plot(data(:,1),data(:,2))
xlabel('Time (s)')
ylabel('EMG(elbow)')

subplot (2,2,2)
plot (data(:,1),data(:,3))
xlabel('Time (s)')
ylabel('Pressure')

subplot(2,2,3)
plot (data(:,1), data(:,4))
xlabel('Time (s)')
ylabel('Angle')


subplot(2,2,4)
plot (data(:,1), data(:,5))
xlabel('Time (s)')
ylabel('EMG(forearm)')

saveas(figure(1), strcat(num2str(subject),'-Trial',num2str(trial),'.fig'));
end
%savefig(strcat(num2str(subject),'-Trial',num2str(trial),'.fig'));
