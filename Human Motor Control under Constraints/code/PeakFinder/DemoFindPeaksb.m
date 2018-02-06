% A simple self-contained demonstration of the findpeaksb function (line 54)
% applied to noisy synthetic data set consisting of a random number of narrow 
% peaks.  Each time you run this, a different set of peaks is generated.
% Calls the fundpeaks function, which must be in the Matlab path.
% See http://terpconnect.umd.edu/~toh/spectrum/Smoothing.html and 
% http://terpconnect.umd.edu/~toh/spectrum/PeakFindingandMeasurement.htm
% Tom O'Haver (toh@umd.edu). Version 3 February 2013
% You can change the signal characteristics in lines 9-16
format short g
format compact
increment=5;
x=[1:increment:8000];

% For each simulated peak, compute the amplitude, position, and width
pos=[200:200:7800];   % Positions of the peaks (Change if desired)
amp=round(5.*randn(1,length(pos)));  % Amplitudes of the peaks  (Change if desired)
wid=50.*ones(size(pos));   % Widths of the peaks (Change if desired)
Noise=.1; % Amount of random noise added to the signal. (Change if desired) 

% A = matrix containing one of the unit-amplidude peak in each of its rows
A = zeros(length(pos),length(x));
ActualPeaks=[0 0 0 0 0 0];
p=1;
for k=1:length(pos)
  if amp(k)>.1,  % Keep only those peaks above a certain amplitude
      % Create a series of peaks of different x-positions
      A(k,:)=exp(-((x-pos(k))./(0.6005615.*wid(k))).^2); % Gaussian peaks
      % A(k,:)=ones(size(x))./(1+((x-pos(k))./(0.5.*wid(k))).^2);  % Lorentzian peaks
      % Assembles actual parameters into ActualPeaks matrix: each row = 1
      % peak; columns are Peak #, Position, Height, Width, Area
      ActualPeaks(p,:) = [p pos(k) amp(k) wid(k) 1.0646.*amp(k)*wid(k) 0]; 
      p=p+1;
  end; 
end 
z=amp*A;  % Multiplies each row by the corresponding amplitude and adds them up
y=z+Noise.*randn(size(z));  % Adds constant random noise
% y=z+Noise.*sqrtnoise(z);  % Adds signal-dependent random noise
% y=y+5.*gaussian(x,0,4000); % Optionally adds a broad background signal
y=y+2*gaussian(x,0,8000); % Optionally adds a broad background signal
% demodata=[x' y']; % Assembles x and y vectors into data matrix

figure(1);plot(x,y,'r')  % Graph the signal in red
title('findpeaksb demo. Detected peaks are numbered. Peak table is printed in Command Window')

% Initial values of variable parameters
WidthPoints=mean(wid)/increment; % Average number of points in half-width of peaks
SlopeThreshold=.00012; % Formula for estimating value of SlopeThreshold
AmpThreshold=.5;
SmoothWidth=20;  % SmoothWidth should be roughly equal the peak width (in points)
FitWidth=11; % FitWidth should be roughly equal to the peak widths (in points)
windowspan=220;
peakshape=1;
autozero=1;
% Lavel the x-axis with the parameter values
xlabel(['SlopeThresh. = ' num2str(SlopeThreshold) '    AmpThresh. = ' num2str(AmpThreshold) '    SmoothWidth = ' num2str(SmoothWidth) '    FitWidth = ' num2str(FitWidth) ])

% Find the peaks
tic;
Measuredpeaks=findpeaksb(x,y,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth,3,windowspan,peakshape,0,autozero);
ElapsedTime=toc;
PeaksPerSecond=length(Measuredpeaks)/ElapsedTime;

% Display results
disp('-------------------findpeaksb.m demo--------------------')
disp(['SlopeThreshold = ' num2str(SlopeThreshold) ] )
disp(['AmpThreshold = ' num2str(AmpThreshold) ] )
disp(['SmoothWidth = ' num2str(SmoothWidth) ] )
disp(['FitWidth = ' num2str(FitWidth) ] )
disp(['windowspan = ' num2str(windowspan) ] )
disp(['peakshape = ' num2str(peakshape) ] )
disp(['autozero = ' num2str(autozero) ] )
disp(['Speed = ' num2str(round(PeaksPerSecond)) ' Peaks Per Second' ] )
disp('         Peak #     Position      Height      Width       Area       Fitting error')
Measuredpeaks  % Display table of peaks
% calculate top of peaks including background for peak number labeling
clear peaky
for peak=1:length(Measuredpeaks),peaky(peak)=y(val2ind(x,Measuredpeaks(peak,2)));end
% Number the peaks found on the graph
figure(1);text(Measuredpeaks(:, 2),peaky',num2str(Measuredpeaks(:,1)))

if length(ActualPeaks)==length(Measuredpeaks),
    PercentErrors=100.*(ActualPeaks(:,1:5)-Measuredpeaks(:,1:5))./ActualPeaks(:,1:5);
    PercentErrors(1:5,1)=Measuredpeaks(1:5,1)
    AverageAbsolutePercentErrors=mean(abs(100.*(ActualPeaks(:,1:5)-Measuredpeaks(:,1:5))./ActualPeaks(:,1:5)))
end

function [index,closestval]=val2ind(x,val)
% Returns the index and the value of the element of vector x that is closest to val
% If more than one element is equally close, returns vectors of indicies and values
% Tom O'Haver (toh@umd.edu) October 2006
% Examples: If x=[1 2 4 3 5 9 6 4 5 3 1], then val2ind(x,6)=7 and val2ind(x,5.1)=[5 9]
% [indices values]=val2ind(x,3.3) returns indices = [4 10] and values = [3 3]
dif=abs(x-val);
index=find((dif-min(dif))==0);
closestval=x(index);