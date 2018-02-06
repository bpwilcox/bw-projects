function [testt, testv, testvf] = EMG(Sub,Exp,Data);

% clear all;
% clc;


% SECTION 1 -- DETERMINING MAX VALUES (FOR NORMALIZATION)

% Butterworth filters, might not be used
[b,a] = butter(4,10/1000);
[b2,a2] = butter(4,20/1000);


% Excel file (saved as .csv) with EMG data -- maximum signals trial
% filename = 'C:\Users\BPWilcox\Documents\Thesis Data\Subjects\A\EMG\A_3_Fast_CCW.xlsx';
filename = strcat('C:\Users\BPWilcox\Documents\Thesis Data\Subjects\',char(Data(Sub).Subject),'\EMG\',char(Data(Sub).EMG(Exp)),'.emg');
% filename = 'C:\Users\BPWilcox\Documents\Thesis Data\Data\Subject A\EMG\A_3_Slow_CCW.csv';

% figure(4)
% file = csvread(filename);
% file = xlsread(filename);
[header,file]= loademg3(filename);
file=file';

col = 0:length(file)-1;
col = col*1e-3;
col=col';
file = [col file];

%file = csvread('F:\Documents\MIT\2_183J\Final Project\Lucille 5-2\lucillemax.csv');
maxt = file(:,1);                   % Time Vector
maxv = file(:,2:9);                 % EMG Data vectors (8 channels)

% Zero-Centered Values -> Positive Rectified Values
maxv = abs(maxv);

% Clear to save RAM
clear file;
clear maxt;

% Divide the Data vectors into windows, then compute and store
% the RMS ("average") value within each window
n3 = 5;                             % Window Size
for j = 1:8                         % for each channel
    % moving window averages
    for i = 1:n3:length(maxv(:,j))-n3+1
        % Store the condensed Data Vectors as nmaxv
        nmaxv(1+(i-1)/n3,j) = rms(maxv(i:i+n3-1,j));
    end
end

% Replace full vectors with condensed vectors
maxv = nmaxv;

% Sort the Data Vectors by magnitude
maxv = sort(maxv,1,'descend');
% maxv(1:10,:);
% Save the maximum value for each channel as maxvv
maxvv = maxv(1,:);

% Clear to save RAM
% clear maxv;
% clear nmaxv;

%%

% Selector of trial number
f = 3;

% file = csvread(filename);
% file = xlsread(filename);
[header,file]= loademg3(filename);
file=file';

col = 0:length(file)-1;
col = col*1e-3;
col=col';
file = [col file];

% Loading of trials
% if f == 1
%     % Excel file, as .csv, with trial data
%     file = csvread(filename);
%     pstart = 30.45;                 % Action #1 Time (for sync)
%     entrain = 60.1;                 % Action #2 Time (for sync)
%     pend = 88.5;                    % Action #3 Time (for sync)
%     tend = 140;                     % Approximate Time Delay Factor
% elseif f == 2
%     file = csvread(filename);
%     pstart = 30.45;
%     entrain = 51;
%     pend = 86.5;
%     tend = 140;
% elseif f == 3
%     file = csvread(filename);
%     pstart = 32.85;
%     entrain = 73.6;
%     pend = 95.4;
%     tend = 140;
% elseif f == 4
%     file = csvread(filename);
%     pstart = 32.5;
%     entrain = 64.7;
%     pend = 87;
%     tend = 140;
% else
% end
    
%file = csvread('F:\Documents\MIT\2_183J\Final Project\Lucille 5-2\lucilleplantartf1.csv');

% Separating data into arrays
testt = file(:,1);                  % Time vector
testv = file(:,2:9);                % Data vectors
clear file;                         % Save RAM

% Computation of time delay
%delay = tend - testt(length(testt));
delay = 0;

% Plot the frequency spectrum of the data, used for troubleshooting
% freq = fft(testv(:,8));
% f = 1000*linspace(0,1,length(freq));
% figure(3)
% plot(f,abs(freq))

% Data vectors should be zero-centered, but just in case
for j = 1:8
    testv(:,j) = testv(:,j) - mean(testv(:,j));
end

% Normalize each Data vector with its respective max value (from Part 1)
for i = 1:length(testt)
    for j = 1:8                                 % for each vector
        testv(i,j) = abs(testv(i,j))/maxvv(j);  % normalization
        if testv(i,j) > 1                       % allowable max is 1
            testv(i,j) = 0;                     % get rid of error value
        end
    end
end

% Divide the Data vectors into windows, then compute and store
% the RMS ("average") value within each window
% n3 = 5;         % window size
n3 = 5;         % window size
for j = 1:8                     % for each channel
    % moving window RMS
    for i = 1:n3:length(testv(:,j))-n3+1
        % Store the condensed Data Vectors as ntestv
        ntestv(1+(i-1)/n3,j) = rms(testv(i:i+n3-1,j));
        % Reduce time vector to match data vectors
        ntestt(1+(i-1)/n3) = testt(i);
    end
end

% Replace old vectors with new ones
testv = ntestv;
testt = ntestt;
% 
% % Clear for RAM
% clear ntestv;
% clear ntestt;

%% PART 3 -- Individual Pulses Function
% Most simple program: plots the data vs. time, single filter

n = 0;                          % moving window span
n2 = 100;                       % moving window interval
y = 0:.1:1;                     % for vertical lines

fc = 5;

fs =500;
[b,a] = butter(4,fc/fs);         % Butterworth filter values

% a =1;
% b = [1/100 1/100 1/100 1/100];


% title('Filtered EMG Data for Peroneus Longus, Loaded (Top) vs. Unloaded (Bottom) Leg')
titles =  cell(1,8);
titles(1)=cellstr('Brachioradialis');
titles(2)=cellstr('Trapezius');
titles(3)=cellstr('Biceps');
titles(4)=cellstr('Triceps');
titles(5)=cellstr('Anterior Deltoid');
titles(6)=cellstr('Posterior Deltoid');
titles(7)=cellstr('Pectoralis Major');
titles(8)=cellstr('Sync');
% titles = ['Brachioradialis';'Trapezius';'Biceps';'Triceps'; 'Anterior Deltoid';'Posterior Deltoid';'Pectoralis Major';'Sync'];
% titles = cellstr(titles);
for j = 1:8                     % for the desired channels
    % create filtered vectors
%     testvf(:,j) = filter(b,a,testv(:,j));
    testvf(:,j) = filtfilt(b,a,testv(:,j));
%     testvf(:,j) = filter(b,a,testv(:,j));
%     % plot individual pulses
%     subplot(4,2,j)
%     plot(testt,testv(:,j))
% %     plot(testt,testvf(:,j))
%     hold on
%     % Don't remember exact details of the red vertical lines
%     % But they were markers denoting when actuator pulsed
% %     plot(pstart-delay-(n*n3/1000)*ones(length(y)),y,'r')
% %     plot(entrain-delay-(n*n3/1000)*ones(length(y)),y,'r')
% %     plot(1.268 +entrain-delay-(n*n3/1000)*ones(length(y)),y,'r')
% %     plot(2*1.268 +entrain-delay-(n*n3/1000)*ones(length(y)),y,'r')
% %     plot(3*1.268 +entrain-delay-(n*n3/1000)*ones(length(y)),y,'r')
% %     plot(4*1.268 +entrain-delay-(n*n3/1000)*ones(length(y)),y,'r')    
% %     plot(5*1.268 +entrain-delay-(n*n3/1000)*ones(length(y)),y,'r')
% %     plot(6*1.268 +entrain-delay-(n*n3/1000)*ones(length(y)),y,'r')
% %     plot(7*1.268 +entrain-delay-(n*n3/1000)*ones(length(y)),y,'r')
% %     plot(8*1.268 +entrain-delay-(n*n3/1000)*ones(length(y)),y,'r')
% %     plot(pend-delay-(n*n3/1000)*ones(length(y)),y,'r')
% %     ylim([0 max(testvf(:,j))])
% %     xlim([65 85])
%     xlabel('Time (s)')
%     ylabel('Emg/Emg_{max}')
%     title(titles(j))
%     hold off  
end
% clear testvf;

end
%% Part 4 -- Integral of Individual Pulses
% 
% n = 1*1000/n3;                          % moving window span
% n2 = 0.1*1000/n3;                       % moving window interval
% int = zeros((length(testv(:,j))-n)/n2,8);
% intf = zeros((length(testv(:,j))-n)/n2,8);
% intf2 = zeros((length(testv(:,j))-n)/n2,8);
% testz = zeros((length(testv(:,j))-n)/n2);
% [b,a] = butter(4,.5/10);
% [b2,a2] = butter(4,.1/10);
% y = 0:.1:1;                   % for vertical lines
% 
% idx = reshape(1:8,2,4)';
% idx=idx(:);
% for j = 1:8                     % for each sensor dataset
%     % moving window integral, at intervals
%     for i = 1:n2:length(testv(:,j))-n
%         int(1+(i-1)/n2,j) = trapz(testv(i:i+n-1,j))/n;
%         testz(1+(i-1)/n2) = testt(i);
%     end   
% end
% 
% for j = 1:8
%     intf(:,j) = filter(b,a,int(:,j)-int(1,j))+int(1,j);
%     intf2(:,j) = filter(b2,a2,int(:,j)-int(1,j))+int(1,j);
% end
% 
% for j = 1:8
%     figure(1)
%     subplot(4,2,idx(j))
%     plot(testz,intf(:,j))
%     hold on
%     plot(testz-8,intf2(:,j),'g-')
%     plot(pstart-delay-(1/1000)*ones(length(y)),y,'r')
%     plot(entrain-delay-(1/1000)*ones(length(y)),y,'r')
%     plot(pend-delay-(1/1000)*ones(length(y)),y,'r')
%     ylim([min(intf(:,j)) max(intf(:,j))])
%     xlim([0 testz(length(testz))])
%     set(gcf,'color','w');
%     ylabel('Emg/Emg_{max}')
%     if j == 4 || j == 8
%         xlabel('Time (s)')
%     end
%     hold off 
% end
% %print -dpdf -r300 intr_tf1
% % clear int;
% % clear intf;
% % clear testz;
% 
% %% Part 5 -- Examination of Variability
% 
% n = 10*1000/n3;                       % moving window span
% n2 = .1*1000/n3;                       % moving window interval
% varv = zeros((length(testv(:,1))-n)/n2,8);
% testz = zeros((length(testv(:,1))-n)/n2);
% y = 0:.001:1;                   % for vertical lines
% [b,a] = butter(4,.5/10);
% 
% idx = reshape(1:8,2,4)';        % used to make a 4x2 set of plots
% idx=idx(:);
% for j = 1:8                     % for each sensor dataset
%     % moving window integral, at intervals
%     for i = 1:n2:length(testv(:,j))-n
%         testz(1+(i-1)/n2) = testt(i);
%         varv(1+(i-1)/n2,j) = var(testv(i:i+n-1,j))/max(testv(i:i+n-1,j));
%     end
%     varvf(:,j) = filter(b,a,varv(:,j)-varv(1,j))+varv(1,j);
%     
%     figure(3)
%     subplot(4,2,idx(j))
%     plot(testz,varvf(:,j))
%     hold on
%     plot(pstart-delay-(1/1000)*ones(length(y)),y,'r')
%     plot(entrain-delay-(1/1000)*ones(length(y)),y,'r')
%     plot(pend-delay-(1/1000)*ones(length(y)),y,'r')
%     ylim([0 max(varvf(:,j))])
%     hold off
% end
% 
% % Clear for RAM
% clear varv;
% clear varvf;
% clear testz;


% filt2 = filter(b2,a2,testv(:,1));






% figure(1)
% scrollplot(testt,testv(:,1),15)
% 
% figure(2)
% scrollplot(testt,filt2,15)
% 
% freq = fft(testvf(:,7));
% f = 1000*linspace(0,1,length(freq));
% figure(4)
% plot(f,abs(freq))