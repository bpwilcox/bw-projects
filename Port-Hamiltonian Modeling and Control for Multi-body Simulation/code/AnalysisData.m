subject = 1;
i=14;
    
trial =i;
filename = strcat(num2str(subject),'-Trial',num2str(trial),'.xlsx');
data = xlsread(filename);

%data([1:N],4);
[maxDeflection, N] = max(data([1:5000],4))
%[maxDeflection, N] = max(data(:,4))

timemax = data(N,1)

[maxPressure, J] = max(data([1:5000],3))
%[maxPressure, J] = max(data(:,3))
timemaxP = data(J,1)

[pks,locs] = findpeaks(data([1:5000],4),'MINPEAKHEIGHT',-10);
%[pks,locs] = findpeaks(data(:,4),'MINPEAKHEIGHT',2);

[x1,K] = max(pks);
%x1 = x1*pi/180;
posx1 = locs(K);
x2 = pks(K+1);
posx2 = locs(K+1);

period = data(posx2,1) - data(posx1,1)

m=1.5; 
L=0.3;
I=1/3*m*L^2;
y = (x1-x2)/abs(x2) +1 
dampfreq = (2*pi)/(data(posx2,1) - data(posx1,1))
delta = log(y)
dampingratio = (delta/(2*pi))/(sqrt(1+(delta/(2*pi))^2))
natfreq = dampfreq/sqrt(1 - dampingratio^2)
k = I*natfreq^2
c = 2*I*dampingratio*natfreq
