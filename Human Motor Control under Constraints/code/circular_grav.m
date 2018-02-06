function [] = circular_grav(Sub,Exp);

% clear all;
% close all;
load SubjectData.mat %Loads in 'Data' structure for subjects
% X = -62;
% Y = 80;
% Sub = 6;
% Exp = 11;


[testt, testv, testvf] = EMG(Sub,Exp,Data);

% trigger = 136;



%Position of sync sensor
X = Data(Sub).SyncX;
Y = Data(Sub).SyncY;

%Determines clockwise or counterclockwise
Dir = Data(Sub).Direction(Exp);

trigger = atan2d(Y,X); %Angle of sync sensor
% Read in a file
% A = xlsread('F:\Documents\MIT\circular_motion2_data\9-29_grav.xlsx');

% First 4 subjects have different file structure so read in differently
if Sub < 5
filename = strcat('C:\Users\BPWilcox\Documents\Thesis Data\Subjects\',char(Data(Sub).Subject),'\Experiments\',char(Data(Sub).Experiment(Exp)),'.asc');
else
filename = strcat('C:\Users\BPWilcox\Documents\Thesis Data\Subjects\',char(Data(Sub).Subject),'\Experiments\',num2str(Data(Sub).Experiment(Exp)),'.asc');
end




A = importdata(filename);
% Actual Trajectory Angle
Th = atan2d(A(:,3),A(:,2));     % Col 3 is y-pos, Col 2 is x-pos

% Adjusting Angle to All-Positive (between 0 & 360)
for i = 1:length(Th)
    if Th(i)<0
        Th(i) = Th(i) + 360;
    end
    if Th(i)>360
        Th(i) = Th(i) - 360;
    end
end


% This is a pretty hacked and poor method to find the trigger angle (or
% closest data point to sync angle, but it worked (more or less). 
trigger = trigger*ones(length(Th),1);
FindSync = abs(Th-trigger);
B = find(FindSync<2);

[Min,M] = min(FindSync(1:B(1)+10));
N = find(testv(:,8)>0.4);
T =(A(:,1)-A(1,1))*.005;

Tr = T(M(1));
Te = testt(N(1));

tplus = (testt(end)-Te)*200;


% Trnew = T(M(1):M(1)+tplus);
% Trnew = Trnew - Trnew(1);
% Tenew = testt(N(1):end-2);
% Tenew = Tenew - Tenew(1);
% 
% Thnew = Th(M(1):M(1)+tplus);


%Shift data according to sync 
A = A(M(1):M(1)+tplus,:);
Th = Th(M(1):M(1)+tplus);

Muscle = testv(N(1):end,:);


% Expected Force Angles During Centripetal Acceleration
% Position vector points outwards, Centripetal Accel points inwards
Thex = Th + 180;

% Expected Force Angles During Tangential Acceleration
% Tangential Acceleration is tangential to position
Thex2 = Th + 90;

% time vector
T =(A(:,1)-A(1,1))*.005;    % 0.005 is the inverse of the sampling rate
dT = diff(T);               % This is used in derivatives below

% Actual Velocity
V = sqrt(A(:,4).^2 + A(:,5).^2);    % Magnitude 
Vx = A(:,4);                        % Col 4 is Vx, Col 5 is Vy
Vy = A(:,5);

% Filtered Velocity
[b,a] = butter(4,10/1000);  % Butterworth filter(polynominal degree, sampling window)
Vf = filter(b,a,V);         % Filtered velocities - magnitude, X, and Y
Vxf = filter(b,a,Vx);
Vyf = filter(b,a,Vy);

% Acceleration Approximations
dV = diff(Vf);              % Differentials used below
dVx = diff(Vxf);
dVy = diff(Vyf);
Am = dV./dT;                % Accelerations from differentials
Ax = dVx./dT;
Ay = dVy./dT;


% Actual Motor Force Angles
ThMF = atan2d(A(:,7),A(:,6));   % Col 7, 6 is Exerted Motor Force in y, x
for i = 1:length(ThMF)          % Ensure angles are between 0 and 360
    if ThMF(i)<0
        ThMF(i) = ThMF(i) + 360;
    end
    if ThMF(i)>360
        ThMF(i) = ThMF(i) - 360;
    end
end

% Actual Motor Force Magnitudes
MF = sqrt(A(:,6).^2 + A(:,7).^2);   % Motor Force Magnitude
MFn = MF.*cosd(ThMF-Th);            % MF Normal to circle
MFt = MF.*sind(ThMF-Th);            % MF Tangent to circle
MFx = A(:,6);            
MFy = A(:,7);

% Loops to distinguish each revolution
loops = 0;          % value initialized at 0
% Over the course of the trial, check how many times the motion passes
% from negative y to positive y (how many times it passes through 0 deg)
% The number of crossovers (loops) and the iteration values where they
% occur (cross) are saved
if Dir==1
    
for i = 1:length(A(:,2))-1
    if A(i,3)<0 && A(i+1,3)>0
        loops = loops+1;                % number of revolution crossovers
        cross(loops) = i;               % iteration of crossovers 
    end
end

elseif Dir==-1
    for i = 1:length(A(:,2))-1
    if A(i,3)>0 && A(i+1,3)<0
        loops = loops+1;                % number of revolution crossovers
        cross(loops) = i;               % iteration of crossovers 
    end
end
end


%%%%%%%% Process to produce mean & S.E. of trajectory %%%%%%%%

% number of points to interpolate
n1 = 10;                                 

% Create new position vectors cropping out initial and final sections
% Includes point before first crossover and a few after the last
% loopn = 4;             % number of revolutions (minus 1) to keep
loopn = loops-1;             % number of revolutions (minus 1) to keep

Xii1 = A((cross(1)):(cross(loopn)+5),2);
Yii1 = A((cross(1)):(cross(loopn)+5),3);
MFxii1 = A((cross(1)):(cross(loopn)+5),6);
MFyii1 = A((cross(1)):(cross(loopn)+5),7);
Vii1 = V((cross(1)):(cross(loopn)+5));
MFtii1 = MFt((cross(1)):(cross(loopn)+5));
MFnii1 = MFn((cross(1)):(cross(loopn)+5));

n1Muscleii1 = Muscle((cross(1)):(cross(loopn)+5),1);
n2Muscleii1 = Muscle((cross(1)):(cross(loopn)+5),2);
n3Muscleii1 = Muscle((cross(1)):(cross(loopn)+5),3);
n4Muscleii1 = Muscle((cross(1)):(cross(loopn)+5),4);
n5Muscleii1 = Muscle((cross(1)):(cross(loopn)+5),5);
n6Muscleii1 = Muscle((cross(1)):(cross(loopn)+5),6);
n7Muscleii1 = Muscle((cross(1)):(cross(loopn)+5),7);
n8Muscleii1 = Muscle((cross(1)):(cross(loopn)+5),8);


% Interpolate vectors to increase continuity
Xi1 = interp(Xii1,n1);
Yi1 = interp(Yii1,n1);
MFxi1 = interp(MFxii1,n1);
MFyi1 = interp(MFyii1,n1);
Vi1 = interp(Vii1,n1);
MFti1 = interp(MFtii1,n1);
MFni1 = interp(MFnii1,n1);

n1Musclei1 = interp(n1Muscleii1,n1);
n2Musclei1 = interp(n2Muscleii1,n1);
n3Musclei1 = interp(n3Muscleii1,n1);
n4Musclei1 = interp(n4Muscleii1,n1);
n5Musclei1 = interp(n5Muscleii1,n1);
n6Musclei1 = interp(n6Muscleii1,n1);
n7Musclei1 = interp(n7Muscleii1,n1);
n8Musclei1 = interp(n8Muscleii1,n1);


% Create Angles
% We can't interpolate angles from previously computed due to continuity
Thi1 = atan2d(Yi1,Xi1);             % position angles for interpolated
ThMFi1 = atan2d(MFyi1,MFxi1);       % motor force angles
Ri1 = real(sqrt(Yi1.^2 + Xi1.^2));  % radial values

% Adjust angles to start at 0, end at 360
for i = 1:length(Thi1)
    if Thi1(i)<0
        Thi1(i) = Thi1(i) + 360;
    end
    if Thi1(i)>360
        Thi1(i) = Thi1(i) - 360;
    end
    if ThMFi1(i)<0
        ThMFi1(i) = ThMFi1(i) + 360;
    end
    if ThMFi1(i)>360
        ThMFi1(i) = ThMFi1(i) - 360;
    end
    if Thi1(i)>170 && ThMFi1(i)<180         % I probably did this for
        ThMFi1(i) = ThMFi1(i) + 360;        % graph presentation
    end
end

% Floor Position Angles and Average Remaining Values for each Angle
% This is used so that there are only MF, V, etc values for angle integers
% aka the theta vector increases 0,1,2,3... 359
fThip1 = -1;        % initial reference value for loop (just below 0 deg)
j = 0;
for i = 1:length(Thi1)
    fThi1 = floor(Thi1(i));     % Floor the current position angle
    
    % If the current floored position angle is equal to the previous
    % reference value, add its corresponding values to the "reference sums"
    if fThi1 == fThip1                        
        ThMFir1(j) = ThMFir1(j) + ThMFi1(i);    % increase sums
        Rir1(j) = Rir1(j) + Ri1(i);
        Vir1(j) = Vir1(j) + Vi1(i);
        MFtir1(j) = MFtir1(j) + MFti1(i);
        MFnir1(j) = MFnir1(j) + MFni1(i);
        MFxir1(j) = MFxir1(j) + MFxi1(i);
        MFyir1(j) = MFyir1(j) + MFyi1(i);
        
        n1Muscleir1(j) = n1Muscleir1(j)+ n1Musclei1(i);
        n2Muscleir1(j) = n2Muscleir1(j)+ n2Musclei1(i);
        n3Muscleir1(j) = n3Muscleir1(j)+ n3Musclei1(i);
        n4Muscleir1(j) = n4Muscleir1(j)+ n4Musclei1(i);
        n5Muscleir1(j) = n5Muscleir1(j)+ n5Musclei1(i);
        n6Muscleir1(j) = n6Muscleir1(j)+ n6Musclei1(i);
        n7Muscleir1(j) = n7Muscleir1(j)+ n7Musclei1(i);
        n8Muscleir1(j) = n8Muscleir1(j)+ n8Musclei1(i);
        
        
        cr(j) = cr(j) + 1;                % increment divisor, the
                                          % number of elements in the sums
    
    % If the current floored position angle is not equal to the previous
    % reference value, that angle becomes the new reference value
    else                                    
        j = j+1;                    % new position in reference vectors
        Thir1(j) = fThi1;           % set the new reference angle
        ThMFir1(j) = ThMFi1(i);     % initiate "reference sums"
        Rir1(j) = Ri1(i);
        Vir1(j) = Vi1(i);
        MFtir1(j) = MFti1(i);
        MFnir1(j) = MFni1(i);
        MFxir1(j) = MFxi1(i);
        MFyir1(j) = MFyi1(i);
        
%         Muscleir1(j) = Musclei1(i);
        
        n1Muscleir1(j) =  n1Musclei1(i);
        n2Muscleir1(j) =  n2Musclei1(i);
        n3Muscleir1(j) =  n3Musclei1(i);
        n4Muscleir1(j) =  n4Musclei1(i);
        n5Muscleir1(j) =  n5Musclei1(i);
        n6Muscleir1(j) =  n6Musclei1(i);
        n7Muscleir1(j) =  n7Musclei1(i);
        n8Muscleir1(j) =  n8Musclei1(i);
        
        cr(j) = 1;                  % initiate "reference divisor"
    end
    
    fThip1 = fThi1;                 % current floored angle is the next
                                    % reference angle
end

% Averages = Sums / divisor
% For each reference sum, divide by number of elements that went into it
ThMFir1 = ThMFir1./cr;
Rir1 = Rir1./cr;
Vir1 = Vir1./cr;
MFtir1 = MFtir1./cr;
MFnir1 = MFnir1./cr;
MFxir1 = MFxir1./cr;
MFyir1 = MFyir1./cr;

n1Muscleir1 = n1Muscleir1./cr;
n2Muscleir1 = n2Muscleir1./cr;
n3Muscleir1 = n3Muscleir1./cr;
n4Muscleir1 = n4Muscleir1./cr;
n5Muscleir1 = n5Muscleir1./cr;
n6Muscleir1 = n6Muscleir1./cr;
n7Muscleir1 = n7Muscleir1./cr;
n8Muscleir1 = n8Muscleir1./cr;

% Loop to crop vectors again (removing values after last crossover and
% before the first crossover)
loopsr1 = 0;                              
done = 0;

if Dir ==1
for i = 1:length(Thir1)-1
    if Thir1(i)>350 && Thir1(i+1)<10
        loopsr1 = loopsr1+1;            % number of revolution crossovers
        crossr1(loopsr1) = i;           % iteration of crossovers 
    end
end

elseif Dir ==-1
    
for i = 1:length(Thir1)-1
    if Thir1(i)<10 && Thir1(i+1)>350
        loopsr1 = loopsr1+1;            % number of revolution crossovers
        crossr1(loopsr1) = i;           % iteration of crossovers 
    end
end

end

% for i = 1:length(Thir1)-1
%     if Thir1(i)<10 && Thir1(i+1)<350
%         loopsr1 = loopsr1+1;            % number of revolution crossovers
%         crossr1(loopsr1) = i;           % iteration of crossovers 
%     end
% end



% cropping
Rir1 = Rir1((crossr1(1)+1):crossr1(loopsr1));
Thir1 = Thir1((crossr1(1)+1):crossr1(loopsr1));
ThMFir1 = ThMFir1((crossr1(1)+1):crossr1(loopsr1));
Vir1 = Vir1((crossr1(1)+1):crossr1(loopsr1));
MFtir1 = MFtir1((crossr1(1)+1):crossr1(loopsr1));
MFnir1 = MFnir1((crossr1(1)+1):crossr1(loopsr1));
MFxir1 = MFxir1((crossr1(1)+1):crossr1(loopsr1));
MFyir1 = MFyir1((crossr1(1)+1):crossr1(loopsr1));

n1Muscleir1 = n1Muscleir1((crossr1(1)+1):crossr1(loopsr1));
n2Muscleir1 = n2Muscleir1((crossr1(1)+1):crossr1(loopsr1));
n3Muscleir1 = n3Muscleir1((crossr1(1)+1):crossr1(loopsr1));
n4Muscleir1 = n4Muscleir1((crossr1(1)+1):crossr1(loopsr1));
n5Muscleir1 = n5Muscleir1((crossr1(1)+1):crossr1(loopsr1));
n6Muscleir1 = n6Muscleir1((crossr1(1)+1):crossr1(loopsr1));
n7Muscleir1 = n7Muscleir1((crossr1(1)+1):crossr1(loopsr1));
n8Muscleir1 = n8Muscleir1((crossr1(1)+1):crossr1(loopsr1));

% Sort the angle vector by value and sort remaining vectors to match
[Thirs1,I1] = sort(Thir1);
for i = 1:length(Vir1)
     Rirs1(i) = Rir1(I1(i));
     Virs1(i) = Vir1(I1(i));
     MFtirs1(i) = MFtir1(I1(i));
     MFnirs1(i) = MFnir1(I1(i));
     MFxirs1(i) = MFxir1(I1(i));
     MFyirs1(i) = MFyir1(I1(i));
     ThMFirs1(i) = ThMFir1(I1(i));
     
     n1Muscleirs1(i) = n1Muscleir1(I1(i));
     n2Muscleirs1(i) = n2Muscleir1(I1(i));
     n3Muscleirs1(i) = n3Muscleir1(I1(i));
     n4Muscleirs1(i) = n4Muscleir1(I1(i));
     n5Muscleirs1(i) = n5Muscleir1(I1(i));
     n6Muscleirs1(i) = n6Muscleir1(I1(i));
     n7Muscleirs1(i) = n7Muscleir1(I1(i));
     n8Muscleirs1(i) = n8Muscleir1(I1(i));
end

% Mean and Standard Error
% For each angle, find the mean and std, for the amount of loops available
% Reduces vectors to 360 elements (one for each angle value)
k = floor(length(Virs1)/360);
for i = 1:k:length(Virs1)-k+1
    Rirm1((i+k-1)/k) = mean(Rirs1(i:i+k-1));
    Rire1((i+k-1)/k) = std(Rirs1(i:i+k-1));
    Virm1((i+k-1)/k) = mean(Virs1(i:i+k-1));
    Vire1((i+k-1)/k) = std(Virs1(i:i+k-1));
    MFtirm1((i+k-1)/k) = mean(MFtirs1(i:i+k-1));
    MFtire1((i+k-1)/k) = std(MFtirs1(i:i+k-1));
    MFnirm1((i+k-1)/k) = mean(MFnirs1(i:i+k-1));
    MFnire1((i+k-1)/k) = std(MFnirs1(i:i+k-1));
    MFxirm1((i+k-1)/k) = mean(MFxirs1(i:i+k-1));
    MFxire1((i+k-1)/k) = std(MFxirs1(i:i+k-1));
    MFyirm1((i+k-1)/k) = mean(MFyirs1(i:i+k-1));
    MFyire1((i+k-1)/k) = std(MFyirs1(i:i+k-1));
    ThMFirm1((i+k-1)/k) = mean(ThMFirs1(i:i+k-1));
    ThMFire1((i+k-1)/k) = std(ThMFirs1(i:i+k-1));
    
    n1Muscleirm1((i+k-1)/k) = mean(n1Muscleirs1(i:i+k-1));
    n2Muscleirm1((i+k-1)/k) = mean(n2Muscleirs1(i:i+k-1));
    n3Muscleirm1((i+k-1)/k) = mean(n3Muscleirs1(i:i+k-1));
    n4Muscleirm1((i+k-1)/k) = mean(n4Muscleirs1(i:i+k-1));
    n5Muscleirm1((i+k-1)/k) = mean(n5Muscleirs1(i:i+k-1));
    n6Muscleirm1((i+k-1)/k) = mean(n6Muscleirs1(i:i+k-1));
    n7Muscleirm1((i+k-1)/k) = mean(n7Muscleirs1(i:i+k-1));
    n8Muscleirm1((i+k-1)/k) = mean(n8Muscleirs1(i:i+k-1));
    
    
    n1Muscleire1((i+k-1)/k) = std(n1Muscleirs1(i:i+k-1));
    n2Muscleire1((i+k-1)/k) = std(n2Muscleirs1(i:i+k-1));
    n3Muscleire1((i+k-1)/k) = std(n3Muscleirs1(i:i+k-1));
    n4Muscleire1((i+k-1)/k) = std(n4Muscleirs1(i:i+k-1));
    n5Muscleire1((i+k-1)/k) = std(n5Muscleirs1(i:i+k-1));
    n6Muscleire1((i+k-1)/k) = std(n6Muscleirs1(i:i+k-1));
    n7Muscleire1((i+k-1)/k) = std(n7Muscleirs1(i:i+k-1));
    n8Muscleire1((i+k-1)/k) = std(n8Muscleirs1(i:i+k-1));
end

nMuscle = [n1Muscleirm1',n2Muscleirm1',n3Muscleirm1',n4Muscleirm1',n5Muscleirm1',n6Muscleirm1',n7Muscleirm1',n8Muscleirm1'];

angs = 0:1:359;
% Polar to Cartesian Coordinates
Xirm1 = Rirm1.*cosd(angs);              % Mean
Yirm1 = Rirm1.*sind(angs);
Xire1a = (Rirm1+Rire1).*cosd(angs);     % standard deviation above mean
Yire1a = (Rirm1+Rire1).*sind(angs);
Xire1b = (Rirm1-Rire1).*cosd(angs);     % standard deviation below mean
Yire1b = (Rirm1-Rire1).*sind(angs);
angs = angs./360;


% Mean and STD based on velocity vs time data Based on already averaged velocities

% meanvel = mean(Virm1); 
% % stdvel = std(Virm1-meanvel);
% stdvel = std(Virm1);
% Data(Sub).MeanVel(Exp)= meanvel;
% Data(Sub).StdVel(Exp) = stdvel;


% Mean and STD based on velocity vs time data 
meanvel = mean(V(end-9001:end)); 
% stdvel = std(Virm1-meanvel);
stdvel = std(V(end-9001:end));
Data(Sub).MeanVel(Exp)= meanvel; %add to subject data structure for further analysis later
Data(Sub).StdVel(Exp) = stdvel;



save 'SubjectData.mat' Data


% Lots of plots below for velocity, force, etc.

%%%%%%%%   Figures   %%%%%%%%

% amp = .78;
% figure(1)
% 
% figure(1)
% plot(Th,V,'.')
% ylabel('Velocity (m/s)')
% xlabel('Angle (deg)')
% title('Tangential Velocity')
% 
% name = strcat(num2str(Sub),'_',num2str(Exp),'_','RawVelAng');
% 
% savefig(name)
% saveas(gcf,name,'bmp')
% 
% % figure(1)
% % plot(Th,Muscle(:,8))
% % ylabel('EMG (m/s)')
% % xlabel('Angle (deg)')
% % title('Tangential Velocity')
% 
figure(2)
plot(angs,Virm1,'LineWidth',3)
hold on
plot(angs,Virm1 + Vire1,'r--')
plot(angs,Virm1 - Vire1,'r--')
refline(0,mean(Virm1))
hold off
ylim([0 1.1*max(Virm1)])
ylabel('Velocity (m/s)')
xlabel('Crank Position (rev)')
title('Tangential Velocity')
set(gca, 'FontSize', 14, 'FontWeight', 'bold');
% 
% name = strcat(num2str(Sub),'_',num2str(Exp),'_','AvgVelRev');
% 
% savefig(name)
% saveas(gcf,name,'bmp')
% 
% figure(3)
% plot(T,V)
% ylabel('Velocity (m/s)')
% xlabel('Time (s)')
% title('Tangential Velocity vs time')
% 
% name = strcat(num2str(Sub),'_',num2str(Exp),'_','RawVelTime');
% 
% savefig(name)
% saveas(gcf,name,'bmp')
% % 
% % figure(3)
% % plot(T,Th)
% 
% figure(4)
% plot(angs,MFnirm1,'LineWidth',3)
% hold on
% plot(angs,MFnirm1 + MFnire1,'r--')
% plot(angs,MFnirm1 - MFnire1,'r--')
% refline(0,mean(MFnirm1))
% hold off
% ylabel('Force(N)')
% xlabel('Crank Position (rev)')
% title('Normal Force')
% set(gca, 'FontSize', 14, 'FontWeight', 'bold');
% 
% name = strcat(num2str(Sub),'_',num2str(Exp),'_','AvgNForceRev');
% 
% savefig(name)
% saveas(gcf,name,'bmp')


% figure(4)
% theta = angs.*360;
% theta_radians = deg2rad(theta);
% 
% polar(theta_radians,MFnirm1)

% plot(theta_radians,MFnirm1,'LineWidth',3)
% hold on
% plot(theta_radians,MFnirm1 + MFnire1,'r--')
% plot(theta_radians,MFnirm1 - MFnire1,'r--')
% refline(0,mean(MFnirm1))
% hold off
% ylabel('Force(N)')
% xlabel('Crank Position (rev)')
% title('Normal Force')
% set(gca, 'FontSize', 14, 'FontWeight', 'bold');
% 
% % name = strcat(num2str(Sub),'_',num2str(Exp),'_','AvgNForceRev');
% name ='PolarNForceRev';
% % 
% savefig(name)
% saveas(gcf,name,'bmp')

% % figure(4)
% % plot(Th,ThMF,'.')
% % hold on
% % plot(Th,Thex,'r.')
% % plot(Th,Thex2,'r.')
% % hold off
% 
% % figure(5)
% % plot(Th./360,Thex,'g-','LineWidth',2)
% % hold on
% % %plot(angs,ThMFirm1 + ThMFire1)
% % %plot(angs,ThMFirm1 - ThMFire1)
% % plot(Th./360,Thex2,'r-','LineWidth',4)
% % plot(Th./360,Th,'c-','LineWidth',2)
% % plot(angs,ThMFirm1,'-','LineWidth',3)
% % hold off
% % ylabel('Force Direction (deg)')
% % xlabel('Crank Position (rev)')
% % legend('Inwards Radial Direction','Tangential Direction','Outwards Radial Direction','Actual')
% % title('Direction of Force vs. Position')
% % 
% % figure(6)
% % plot(Th,MFy,'b.')
% % hold on
% % plot(Th,MFx,'r.')
% % hold off
% 
% % figure(7)
% % %plot(angs,MFxirm1,'b-','LineWidth',2)
% % hold on
% % plot(angs,MFyirm1,'r-','LineWidth',2)
% % plot(angs,MFyirm1-.78,'k-','LineWidth',2)
% % plot(angs,zeros(length(angs)),'g--','LineWidth',2)
% % %plot(angs,.97*cosd(angs.*360),'c-')
% % hold off
% % xlabel('Crank Position (rev)')
% % ylabel('Force (N)')
% % title('Force: Y Direction')
% % legend('Motor Force','Gravity Adj Motor Force','Zero')
% % 
% % figure(8)
% % plot(Th,MFn,'.')
% 
% % figure(9)
% % plot(angs,MFtirm1-mean(MFtirm1),'LineWidth',2)
% % hold on
% % plot(angs,amp*sind(angs.*360+90),'r-','LineWidth',3)
% % xlabel('Crank Position (rev)')
% % ylabel('Force (N)')
% % title('Mean-Adjusted Force Profile')
% % legend('Motor Force Deviation from Mean','0.78*cos(position)')
% % hold off
% % 
% % figure(10)
% % plot(Th,MFt,'.')
% % hold on
% % plot(Th,amp*sind(Th+90),'r.')
% % hold off
% % 
% % figure(11)
% % plot(angs,MFtirm1-mean(MFtirm1)-amp*sind(angs.*360+90),'LineWidth',2)
% % hold on
% % plot(angs,zeros(length(angs)),'r-','LineWidth',3)
% % hold off
% % ylim([-1.5 1.5])
% % xlabel('Crank Position (rev)')
% % ylabel('Force (N)')
% % title('Compensated Mean-Adj Force Profile')
% % legend('Motor Force Dev from Mean, Adjusted','Constant Force')
% 
% 
% 
% figure(12)
% plot(angs,MFnirm1-mean(MFnirm1),'LineWidth',2)
% hold on
% plot(angs,amp*sind(angs.*360),'r-','LineWidth',3)
% xlabel('Crank Position (rev)')
% ylabel('Force (N)')
% title('Mean-Adjusted Force Profile')
% legend('Motor Force Deviation from Mean','0.78*sin(position)')
% hold off
% 
% name = strcat(num2str(Sub),'_',num2str(Exp),'_','MeanAdjForceRev');
% 
% savefig(name)
% saveas(gcf,name,'bmp')
% % 
% figure(13)
% plot(angs,MFnirm1-mean(MFnirm1)-amp*sind(angs.*360),'LineWidth',2)
% hold on
% plot(angs,zeros(length(angs)),'r-','LineWidth',3)
% hold off
% % ylim([-2 1.5])
% xlabel('Crank Position (rev)')
% ylabel('Force (N)')
% title('Compensated Mean-Adj Force Profile')
% legend('Motor Force Dev from Mean, Adjusted','Constant Force')
% 
% name = strcat(num2str(Sub),'_',num2str(Exp),'_','CompMeanForceRev');
% 
% 
% savefig(name)
% saveas(gcf,name,'bmp')
% 
% 
% figure(14)
% titles =  cell(1,8);
% titles(1)=cellstr('Brachioradialis');
% titles(2)=cellstr('Trapezius');
% titles(3)=cellstr('Biceps');
% titles(4)=cellstr('Triceps');
% titles(5)=cellstr('Anterior Deltoid');
% titles(6)=cellstr('Posterior Deltoid');
% titles(7)=cellstr('Pectoralis Major');
% titles(8)=cellstr('Sync');
% for j = 1:8                     % for the desired channels
% 
%     subplot(4,2,j)
%     plot(angs,nMuscle(:,j))
%     hold on
%     xlabel('Crank Position (rev)')
%     ylabel('Emg/Emg_{max}')
%     title(titles(j))
%     hold off  
% end
% name = strcat(num2str(Sub),'_',num2str(Exp),'_','AvgEmgRev');
% 
% savefig(name)
% saveas(gcf,name,'bmp')


% sum(abs(MFtirm1-mean(MFtirm1)*ones(1,length(MFtirm1))-amp*sind(angs+90)))
end
