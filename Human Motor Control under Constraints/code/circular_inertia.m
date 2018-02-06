% clear all;
% EMG;
% X = -62;
% Y = 80;
% 
% trigger = atan2d(Y,X);
% 
% trigger = 135;

trial = 10;
offset = 1;
filename ='C:\Users\BPWilcox\Documents\Thesis Data\Thesis Matlab\t10-28-500.xlsx';
if trial == 1
    A = xlsread(filename);
    titl = 'Front, Fast';
    int = 0.1;
    shift = 1;
elseif trial == 2
    A = xlsread(filename);
    titl = 'Left, Fast';
    int = 0.1;
    shift = 2;
elseif trial == 3
    A = xlsread(filename);
    titl = 'Right, Fast';
    int = 0.1;
    shift = 3;
elseif trial == 4
    A = xlsread(filename);
    titl = 'Front, Medium';
    int = 0.1;
    shift = 1;
elseif trial == 5
    A = xlsread(filename);
    titl = 'Left, Medium';
    int = 0.1;
    shift = 2;
elseif trial == 6
    A = xlsread(filename);
    titl = 'Right, Medium';
    int = 0.1;
    shift = 3;
elseif trial == 7
    A = xlsread(filename);
    titl = 'Front, Slow';
    int = 0.1;
    shift = 1;
elseif trial == 8
    A = xlsread(filename);
    titl = 'Left, Slow';
    int = 0.1;
    shift = 2;
elseif trial == 9
    A = xlsread(filename);
    titl = 'Right, Slow';
    int = 0.1;
    shift = 3;
elseif trial == 10
    A = xlsread(filename);
    titl = 'Front, Slowest';
    int = 0.1;
    shift = 1;
elseif trial == 11
    A = xlsread(filename);
    titl = 'Left, Slowest';
    int = 0.1;
    shift = 2;
elseif trial == 12
    A = xlsread(filename);
    titl = 'Right, Slowest';
    int = 0.1;
    shift = 3;
end


% Data points for nominal circle
x = [-.1:0.001:.1];
y = real(sqrt(.01-x.^2));

% Actual Trajectory in Polar Coordinates
Th = atan2d(A(:,3),A(:,2));
R = (A(:,3).^2 + A(:,2).^2).^0.5;
% Angle measurements start at 0 deg, 3 o'clock
for i = 1:length(Th)
    if shift == 2
        Th(i) = Th(i) + 90;
    end
    if shift == 3
        Th(i) = Th(i) - 90;
    end
    if Th(i)<0
        Th(i) = Th(i) + 360;
    end
    if Th(i)>360
        Th(i) = Th(i) - 360;
    end
end
% trigger = trigger*ones(length(Th),1);
% M = find(abs((Th-trigger))<0.6);
% 
% 
% N = find(testv(:,8)>0.7);
% % [pks,locs] = findpeaks(testv(:,8), 'MinPeakHeight',0.9);
% 
% X=A(:,2);
% Y=A(:,3);
% 
% 
% 
% % time vector
% T =(A(:,1)-A(1,1))*.005;
% 
% Tr = T(M(1));
% Te = testt(N(1));
% 
% tplus = (testt(end)-Te)*200;
% Trnew = T(M(1):M(1)+tplus);
% Trnew = Trnew - Trnew(1);
% Tenew = testt(N(1):end-2);
% Tenew = Tenew - Tenew(1);
% 
% Thnew = Th(M(1):M(1)+tplus);
% Xsh = X(M(1):M(1)+tplus);
% Ysh = Y(M(1):M(1)+tplus);
% 
% 
% Xint = interp1(Trnew,Xsh,Tenew);
% Yint = interp1(Trnew,Ysh,Tenew);
% 
% % Thq = atan2d(Yint,Xint);
% 
% Thq = interp1(Trnew,Thnew,Tenew);
% 
% remove = find(diff(Thq) < -10);
% Thq(remove)=[];
% 
% % Muscle =testv(:,4);
% % Muscle = tesMuscle(N(1):end-2);
% % Muscle = testvf(N(1):end-2,:);
% Muscle = testv(N(1):end-2,:);
% 
% 
% 
% 
% 
% 
% Rev = Thq./360;

% Thq = Thq(1:80000);
% Muscle = Muscle(1:80000,:);


% 
% [pks, locs] = findpeaks(Thq, 'MINPEAKHEIGHT',355);
% [pks2, locs2] = findpeaks(-Thq);


% dir=1;
% 
% if dir == 1
%     for k = 1:length(locs2)
%         
%         if k<length(locs2)
%             Rev(locs2(k):locs2(k+1)-1) =Rev(locs2(k):locs2(k+1)-1)+k;
%         else
%             Rev(locs2(k):end) =Rev(locs2(k):end)+k;
%         end
%         
%     end
%     
% else
% %     Rev = Thq./360;
%     for k = 1:length(locs)
%         
%         if k<length(locs)
%             Rev(locs(k):locs(k+1)-1) =Rev(locs(k):locs(k+1)-1)+k;
%         else
%             Rev(locs(k):end) =Rev(locs(k):end)+k;
%         end
%         
%     end
% end
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
%     Muscle(remove,j)=[];
%     subplot(4,2,j)
%     plot(Thq,Muscle(:,j))
%     hold on
%     xlabel('Angle (deg)')
%     ylabel('Emg/Emg_{max}')
%     title(titles(j))
%     hold off  
% end
% 
% 
% % vq = interp1(x,v,xq)
% 
% 
% A = A(M(1):M(1)+tplus,:);
% 


% vertical line vector, for markers 
vline = -200:200;

% Actual Velocity
V = sqrt(A(:,4).^2 + A(:,5).^2);

% Motor Force
ThMF = atan2d(A(:,7),A(:,6));
for i = 1:length(ThMF)
    if shift == 2
        ThMF(i) = ThMF(i) + 90;
    end
    if shift == 3
        ThMF(i) = ThMF(i) - 90;
    end
    if ThMF(i)<0
        ThMF(i) = ThMF(i) + 360;
    end
    if ThMF(i)>360
        ThMF(i) = ThMF(i) - 360;
    end
end
MF = sqrt(A(:,6).^2 + A(:,7).^2);
MFn = MF.*cosd(ThMF);
MFt = MF.*sind(ThMF);

% Force Transducers
ThFT = atan2d(A(:,9),A(:,8));
for i = 1:length(ThFT)
    if shift == 2
        ThFT(i) = ThFT(i) + 90;
    end
    if shift == 3
        ThFT(i) = ThFT(i) - 90;
    end
    if ThFT(i)<0
        ThFT(i) = ThFT(i) + 360;
    end
    if ThFT(i)>360
        ThFT(i) = ThFT(i) - 360;
    end
end
FT = sqrt(A(:,9).^2 + A(:,8).^2);
FTn = FT.*cosd(ThFT);
FTt = FT.*sind(ThFT);

% Loops to distinguish each revolution
loops = 0;                                                             
for i = 1:length(A(:,2))-1
    if shift==1 && A(i,3)<0 && A(i+1,3)>0
        loops = loops+1;                % number of revolution crossovers
        cross(loops) = i;               % iteration of crossovers 
    end
    if shift==2 && A(i,2)<0 && A(i+1,2)>0
        loops = loops+1;                % number of revolution crossovers
        cross(loops) = i;               % iteration of crossovers 
    end
    if shift==3 && A(i,2)>0 && A(i+1,2)<0
        loops = loops+1;                % number of revolution crossovers
        cross(loops) = i;               % iteration of crossovers 
    end
end


% ------------------------------------------------------------------------

% Process to produce mean & S.E. of trajectory
n1 = 10;                                 % number of points to interpolate
% Create new position vectors cropping out initial and final points
Xii1 = A((cross(2)):(cross(16)+5),2);
Yii1 = A((cross(2)):(cross(16)+5),3);
% Interpolate vectors to increase continuity
Xi1 = interp(Xii1,n1);
Yi1 = interp(Yii1,n1);
% Translate Cartesian to Polar
Thi1 = atan2d(Yi1,Xi1);
Ri1 = real(sqrt(Yi1.^2 + Xi1.^2));
% Adjust angles to start at 0, end at 360
for i = 1:length(Thi1)
    if shift == 2
        Thi1(i) = Thi1(i) + 90;
    end
    if shift == 3
        Thi1(i) = Thi1(i) - 90;
    end
    if Thi1(i)<0
        Thi1(i) = Thi1(i) + 360;
    end
    if Thi1(i)>360
        Thi1(i) = Thi1(i) - 360;
    end
end

% Position Vectors Before Motor Stop
fThip1 = -1;
j = 0;
for i = 1:length(Thi1)
    fThi1 = floor(Thi1(i));
    if fThi1 == fThip1                        % Same reference value
        Rir1(j) = Rir1(j) + Ri1(i);            % increase sum
        crir1(j) = crir1(j) + 1;              % increment divisor
        
    else                                    % New reference value
        j = j+1;                            % new position in vector
        Thir1(j) = fThi1;                     % initiate reference value
        Rir1(j) = Ri1(i);                     % initiate sum
        crir1(j) = 1;                        % initiate divisor
    end
    fThip1 = fThi1;
end
Rir1 = Rir1./crir1;

% Loop to crop vector again
loopsr1 = 0;                              
done = 0;     
crossr1=[];
for i = 1:length(Thir1)-1
    if Thir1(i)>350 && Thir1(i+1)<10
        loopsr1 = loopsr1+1;                % number of revolution crossovers
        crossr1(loopsr1) = i;               % iteration of crossovers 
    end
end
Thir1 = Thir1((crossr1(1)+1):crossr1(loopsr1));
Rir1 = Rir1((crossr1(1)+1):crossr1(loopsr1));
% Sort by angle
[Thirs1,I1] = sort(Thir1);
for i = 1:length(Rir1)
     Rirs1(i) = Rir1(I1(i));
end
% Mean and Standard Error
k = floor(length(Rirs1)/360);
for i = 1:k:length(Rirs1)-k+1
    Rirm1((i+k-1)/k) = mean(Rirs1(i:i+k-1));
    Rire1((i+k-1)/k) = std(Rirs1(i:i+k-1))/sqrt(k);
end


% % Trajectory Plot
% figure(1)
% e = plot(A(:,2),A(:,3),'k-');
% hold on
% f = plot(x,y,'r--');
% plot(x,-y,'r--')
% hold off
% xlabel('X-position (m)')
% ylabel('Y-position (m)')
% title([titl,':Hand Trajectory'])
% legend([e,f],'Actual','Nominal')
% set(gcf,'color','w');
% 
% % Polar to Cartesian Coordinates
% Xirm1 = Rirm1.*cosd(Thir1(1:360));
% Yirm1 = Rirm1.*sind(Thir1(1:360));
% Xire1a = (Rirm1+Rire1).*cosd(Thir1(1:360));
% Yire1a = (Rirm1+Rire1).*sind(Thir1(1:360));
% Xire1b = (Rirm1-Rire1).*cosd(Thir1(1:360));
% Yire1b = (Rirm1-Rire1).*sind(Thir1(1:360));
% 
% Trajectory Plot, Mean + S.E.
figure(2)
f1 = plot(Xirm1,Yirm1,'k-');
hold on
f2 = plot(Xire1a,Yire1a,'c-');
f3 = plot(Xire1b,Yire1b,'c-');
f7 = plot(x,y,'r--');
f8 = plot(x,-y,'r--');
hold off
set(gcf,'color','w');
ylabel('Y-position (m)')
xlabel('X-position (m)')
title([titl,': Hand Trajectory (Mean, S.E.)'])
legend([f1,f2,f7],'With Constrainst, Mean','With Constraint, S.E.','Nominal')

% % Radius vs. Angle
% figure(3)
% f1 = plot(Th./360,R,'k.');
% hold on
% f2 = plot([0 0.5 1],[.1 .1 .1],'r--');
% hold off
% legend([f1,f2],'Actual','Nominal')
% ylim([0 round(max(R)*1.2,2)])
% xlabel('Angle (rev)')
% ylabel('Radial Distance (m)')
% title([titl,': Radius v. Angle'])
% set(gcf,'color','w');
% 
% % Radius vs. Angle, Mean + S.E.
% figure(4)
% f1 = plot(Thir1(1:360)./360,Rirm1,'k-');
% hold on
% f2 = plot(Thir1(1:360)./360,Rirm1+Rire1,'c-');
% f3 = plot(Thir1(1:360)./360,Rirm1-Rire1,'c-');
% f7 = plot([0 0.5 1],[.1 .1 .1],'r--');
% hold off
% set(gcf,'color','w');
% ylim([0 round(max(Rirm1)*1.2,2)])
% ylabel('Radial Distance (m)')
% xlabel('Angle (Rev)')
% title([titl,': Radius v. Angle (Mean, S.E.)'])
% legend([f1,f2,f7],'With Constrainst, Mean','With Constraint, S.E.','Nominal Radius')
% 
% % Plot of Radius vs. Time, with markers
% figure(5)
% e = plot(T,R,'k-');
% ylabel('Radial Distance (m)')
% hold on
% for i = 1:loops
%     g = plot(T(cross(i))*ones(length(vline),1),vline,'r-');
% end
% f2 = plot([0 max(T)/2 max(T)],[.1 .1 .1],'c--');
% hold off
% set(gcf,'color','w');
% ylim([0 max(R)*1.2])
% xlim([0 max(T)])
% xlabel('Time (s)')
% title([titl,': Radial Position v. Time'])
% legend([e, f2, g],'Radial Position','Nominal','Cycle Start')
% 
% 
% % ------------------------------------------------------------------------
% 
% % Process to produce mean & S.E. of velocity
% % Create new velocity vectors cropping out initial and final points
% Vii1 = V((cross(2)):(cross(16)+5));
% % Interpolate vectors to increase continuity
% Vi1 = interp(Vii1,n1);
% 
% % Position Vectors Before Motor Stop
% fThip1 = -1;
% j = 0;
% for i = 1:length(Thi1)
%     fThi1 = floor(Thi1(i));
%     if fThi1 == fThip1                        % Same reference value
%         Vir1(j) = Vir1(j) + Vi1(i);            % increase sum
%         cvir1(j) = cvir1(j) + 1;              % increment divisor
%         
%     else                                    % New reference value
%         j = j+1;                            % new position in vector
%         Vir1(j) = Vi1(i);                     % initiate sum
%         cvir1(j) = 1;                        % initiate divisor
%     end
%     fThip1 = fThi1;
% end
% Vir1 = Vir1./cvir1;
% 
% % Loop to crop vector again
% Vir1 = Vir1((crossr1(1)+1):crossr1(loopsr1));
% % Sort by angle
% for i = 1:length(Vir1)
%      Virs1(i) = Vir1(I1(i));
% end
% % Mean and Standard Error
% k = floor(length(Virs1)/360);
% for i = 1:k:length(Virs1)-k+1
%     Virm1((i+k-1)/k) = mean(Virs1(i:i+k-1));
%     Vire1((i+k-1)/k) = std(Virs1(i:i+k-1));%/sqrt(k);
% end
% 
% 
% % Plot of Hand Speed vs. Position
% figure(6)
% [ax,L1,L2] = plotyy(Th./360,V,Th./360,V);
% set(ax(1),'YLim',[0 ceil(max(V)*120)/100])
% set(ax(2),'YLim',[0 ceil(max(V)*120)/100])
% set(ax(1),'YTick',[0:int:round(max(V)*1.2,1)])
% set(ax(2),'YTick',[0:int:round(max(V)*1.2,1)])
% set(L1,'linestyle','none','marker','.','color','k')
% set(L2,'linestyle','none','marker','.','color','k')
% set(ax,'YColor','black')
% raxt = get(ax(2), 'YTick');
% raxrev = round(raxt/0.2/pi,2);
% set(ax(1),'YTick',raxt,'YTickLabel',raxrev);
% xlabel('Crank Position (rev)')
% ylabel(ax(1),'Velocity (rev/s)')
% ylabel(ax(2),'Velocity (m/s)')
% title([titl,': Hand Speed v. Position'])
% set(gcf,'color','w');
% 
% figure(7)
% [ax,L1,L2] = plotyy(Thir1(1:360)./360,Virm1,Thir1(1:360)./360,Virm1);
% set(ax(1),'YLim',[0 ceil(max(Virm1+Vire1)*120)/100])
% set(ax(2),'YLim',[0 ceil(max(Virm1+Vire1)*120)/100])
% set(ax(1),'YTick',[0:int:round(max(Virm1+Vire1)*1.2,1)])
% set(ax(2),'YTick',[0:int:round(max(Virm1+Vire1)*1.2,1)])
% set(L1,'linestyle','-','color','k','LineWidth',3)
% set(L2,'linestyle','-','color','k','LineWidth',3)
% set(ax,'YColor','black')
% raxt = get(ax(2), 'YTick');
% raxrev = round(raxt/0.2/pi,2);
% set(ax(1),'YTick',raxt,'YTickLabel',raxrev);
% xlabel('Crank Position (rev)')
% ylabel(ax(1),'Velocity (rev/s)')
% ylabel(ax(2),'Velocity (m/s)')
% hold on
% Xphil=[Thir1(1:360)./360,fliplr(Thir1(1:360)./360)];
% Yphil=[Virm1-Vire1,fliplr(Virm1+Vire1)];
% std_filled = fill(Xphil,Yphil,[1.000000 0.750000 0.800000],'FaceAlpha',0.6);
% set(std_filled,'EdgeColor','none');
% %mphil = plot(Thir1(1:360)./360,Virm1,'--','Color', [1 0 0], 'Linewidth', 3.5);
% %f2 = plot(Thir1(1:360)./360,Virm1+Vire1,'r-');
% %f3 = plot(Thir1(1:360)./360,Virm1-Vire1,'r-');
% %f4 = plot(Th((cross(2)+1):(cross(3)))./360,V((cross(2)+1):(cross(3))),'b-','Linewidth', 3);
% hold off
% title([titl,': Hand Speed v. Position (Mean, S.D.)'])
% legend([L1,std_filled],'With Constrainst, Mean','With Constraint, S.D.')
% set(gcf,'color','w');
% set(gca, 'FontSize', 12, 'FontWeight', 'bold');
% set(ax(2), 'FontSize', 12, 'FontWeight', 'bold');
% 
% % Plot of Hand Speed vs. Time, with markers
% figure(8)
% clear ax L1 L2;
% [ax,L1,L2] = plotyy(T,V,T,V);
% set(ax(1),'YLim',[0 ceil(max(V)*120)/100])
% set(ax(2),'YLim',[0 ceil(max(V)*120)/100])
% set(ax(1),'XLim',[0 max(T)])
% set(ax(2),'XLim',[0 max(T)])
% set(ax(1),'YTick',[0:int:round(max(V)*1.2,1)])
% set(ax(2),'YTick',[0:int:round(max(V)*1.2,1)])
% set(L1,'linestyle','-','Color','k')
% set(L2,'linestyle','-','Color','k')
% set(ax,'YColor','black')
% raxt = get(ax(2), 'YTick');
% raxrev = round(raxt/0.2/pi,2);
% set(ax(1),'YTick',raxt,'YTickLabel',raxrev);
% ylabel(ax(1),'Velocity (rev/s)')
% ylabel(ax(2),'Velocity (m/s)')
% hold on
% set(gcf,'color','w');
% for i = 1:loops
%     g = plot(T(cross(i))*ones(length(vline),1),vline,'r-');
% end
% hold off
% xlabel('Time (s)')
% title([titl,': Hand Speed v. Time'])
% legend([L1,g],'velocity','start of cycle')
% 
% 
% % ------------------------------------------------------------------------
% 
% % Process to produce mean & S.E. of Tangential Hand Force
% % Create new velocity vectors cropping out initial and final points
% Tii1 = FTt(cross(2):(cross(16)+5));
% % Interpolate vectors to increase continuity
% Ti1 = interp(Tii1,n1);
% 
% % Position Vectors Before Motor Stop
% fThip1 = -1;
% j = 0;
% for i = 1:length(Thi1)
%     fThi1 = floor(Thi1(i));
%     if fThi1 == fThip1                        % Same reference value
%         Tir1(j) = Tir1(j) + Ti1(i);            % increase sum
%         ctir1(j) = ctir1(j) + 1;              % increment divisor
%         
%     else                                    % New reference value
%         j = j+1;                            % new position in vector
%         Tir1(j) = Ti1(i);                     % initiate sum
%         ctir1(j) = 1;                        % initiate divisor
%     end
%     fThip1 = fThi1;
% end
% Tir1 = Tir1./ctir1;
% 
% % Loop to crop vector again
% Tir1 = Tir1((crossr1(1)+1):crossr1(loopsr1));
% % Sort by angle
% for i = 1:length(Tir1)
%      Tirs1(i) = Tir1(I1(i));
% end
% % Mean and Standard Error
% k = floor(length(Tirs1)/360);
% for i = 1:k:length(Tirs1)-k+1
%     Tirm1((i+k-1)/k) = mean(Tirs1(i:i+k-1));
%     Tire1((i+k-1)/k) = std(Tirs1(i:i+k-1))/sqrt(k);
% end
% 
% 
% % Plot of Tangential Hand Force vs. Position
% figure(9)
% plot(Th./360,FTt,'k.');
% ylim([round(min(FTt)*1.2,1) round(max(FTt)*1.2,1)])
% xlabel('Crank Position (rev)')
% ylabel('Force (N)')
% title([titl,': Tangential Hand Force v. Position'])
% set(gcf,'color','w');
% 
% figure(10)
% f1 = plot(Thir1(1:360)./360,Tirm1,'k-');
% ylim([round(min(Tirm1)*1.2,1) round(max(Tirm1)*1.2,1)])
% xlabel('Crank Position (rev)')
% ylabel('Force (N)')
% hold on
% f2 = plot(Thir1(1:360)./360,Tirm1+Tire1,'r-');
% f3 = plot(Thir1(1:360)./360,Tirm1-Tire1,'r-');
% hold off
% title([titl,': Tangential Hand Force v. Position (Mean, S.E.)'])
% set(gcf,'color','w');
% legend([f1,f2],'With Constrainst, Mean','With Constraint, S.E.')
% 
% % Plot of Hand Speed vs. Time, with markers
% figure(11)
% f1 = plot(T,FTt,'k-');
% ylim([round(min(FTt)*1.2,1) round(max(FTt)*1.2,1)])
% xlim([0 max(T)])
% ylabel('Force (N)')
% hold on
% set(gcf,'color','w');
% for i = 1:loops
%     f3 = plot(T(cross(i))*ones(length(vline),1),vline,'r-');
% end
% hold off
% xlabel('Time (s)')
% title([titl,': Tangential Hand Force v. Time'])
% legend([f1,f3],'force','start of cycle')
% 
% 
% % ------------------------------------------------------------------------
% 
% % Process to produce mean & S.E. of Normal Hand Force
% % Create new velocity vectors cropping out initial and final points
% Nii1 = FTn((cross(2)):(cross(16)+5));
% % Interpolate vectors to increase continuity
% Ni1 = interp(Nii1,n1);
% 
% % Position Vectors Before Motor Stop
% fThip1 = -1;
% j = 0;
% for i = 1:length(Thi1)
%     fThi1 = floor(Thi1(i));
%     if fThi1 == fThip1                        % Same reference value
%         Nir1(j) = Nir1(j) + Ni1(i);            % increase sum
%         cnir1(j) = cnir1(j) + 1;              % increment divisor
%         
%     else                                    % New reference value
%         j = j+1;                            % new position in vector
%         Nir1(j) = Ni1(i);                     % initiate sum
%         cnir1(j) = 1;                        % initiate divisor
%     end
%     fThip1 = fThi1;
% end
% Nir1 = Nir1./cnir1;
% 
% 
% % Loop to crop vector again
% Nir1 = Nir1((crossr1(1)+1):crossr1(loopsr1));
% % Sort by angle
% for i = 1:length(Nir1)
%      Nirs1(i) = Nir1(I1(i));
% end
% % Mean and Standard Error
% k = floor(length(Nirs1)/360);
% for i = 1:k:length(Nirs1)-k+1
%     Nirm1((i+k-1)/k) = mean(Nirs1(i:i+k-1));
%     Nire1((i+k-1)/k) = std(Nirs1(i:i+k-1))/sqrt(k);
% end
% 
% 
% % Plot of Normal Hand Force vs. Position
% figure(12)
% plot(Th./360,FTn,'k.');
% ylim([round(min(FTn)*1.2,1) round(max(FTn)*1.2,1)])
% xlabel('Crank Position (rev)')
% ylabel('Force (N)')
% title([titl,': Normal Hand Force v. Position'])
% set(gcf,'color','w');
% 
% figure(13)
% f1 = plot(Thir1(1:360)./360,Nirm1,'k-');
% %ylim([0 round(max(Nirm1)*1.2)])
% ylim([round(min(Nirm1-Nire1)*1.2) round(max(Nirm1)*1.2)])
% xlabel('Crank Position (rev)')
% ylabel('Force (N)')
% hold on
% f2 = plot(Thir1(1:360)./360,Nirm1+Nire1,'r-');
% f3 = plot(Thir1(1:360)./360,Nirm1-Nire1,'r-');
% hold off
% title([titl,': Normal Hand Force v. Position (Mean, S.E.)'])
% set(gcf,'color','w');
% legend([f1,f2],'With Constrainst, Mean','With Constraint, S.E.')
% 
% % Plot of Normal Hand Force vs. Time, with markers
% figure(14)
% f1 = plot(T,FTn,'k-');
% ylim([round(min(FTn)*1.2,1) round(max(FTn)*1.2,1)])
% xlim([0 max(T)])
% ylabel('Force (N)')
% hold on
% set(gcf,'color','w');
% for i = 1:loops
%     f3 = plot(T(cross(i))*ones(length(vline),1),vline,'r-');
% end
% hold off
% xlabel('Time (s)')
% title([titl,': Normal Hand Force v. Time'])
% legend([f1,f3],'force','start of cycle')
% 
% 
% % ------------------------------------------------------------------------
% 
% % Process to produce mean & S.E. of (Normal) Motor Force
% % Create new velocity vectors cropping out initial and final points
% Mii1 = MFn((cross(2)):(cross(16)+5));
% % Interpolate vectors to increase continuity
% Mi1 = interp(Mii1,n1);
% 
% % Position Vectors Before Motor Stop
% fThip1 = -1;
% j = 0;
% for i = 1:length(Thi1)
%     fThi1 = floor(Thi1(i));
%     if fThi1 == fThip1                        % Same reference value
%         Mir1(j) = Mir1(j) + Mi1(i);            % increase sum
%         cmir1(j) = cmir1(j) + 1;              % increment divisor
%         
%     else                                    % New reference value
%         j = j+1;                            % new position in vector
%         Mir1(j) = Mi1(i);                     % initiate sum
%         cmir1(j) = 1;                        % initiate divisor
%     end
%     fThip1 = fThi1;
% end
% Mir1 = Mir1./cmir1;
% 
% % Loop to crop vector again
% Mir1 = Mir1((crossr1(1)+1):crossr1(loopsr1));
% % Sort by angle
% for i = 1:length(Mir1)
%      Mirs1(i) = Mir1(I1(i));
% end
% % Mean and Standard Error
% k = floor(length(Mirs1)/360);
% for i = 1:k:length(Mirs1)-k+1
%     Mirm1((i+k-1)/k) = mean(Mirs1(i:i+k-1));
%     Mire1((i+k-1)/k) = std(Mirs1(i:i+k-1))/sqrt(k);
% end
% 
% 
% % Plot of Normal Hand Force vs. Position
% figure(15)
% plot(Th(1:cross(loops))./360,MFn(1:cross(loops)),'k.');
% ylim([round(min(MFn)*1.2,1) round(max(MFn)*1.2,1)])
% xlabel('Crank Position (rev)')
% ylabel('Force (N)')
% title([titl,': Motor Force v. Position'])
% set(gcf,'color','w');
% 
% figure(16)
% f1 = plot(Thir1(1:360)./360,Mirm1,'k-');
% ylim([round(min(Mirm1)*1.2,1) 0])
% xlabel('Crank Position (rev)')
% ylabel('Force (N)')
% hold on
% f2 = plot(Thir1(1:360)./360,Mirm1+Mire1,'r-');
% f3 = plot(Thir1(1:360)./360,Mirm1-Mire1,'r-');
% hold off
% title([titl,': Motor Force v. Position (Mean, S.E.)'])
% set(gcf,'color','w');
% legend([f1,f2],'With Constraint, Mean','With Constraint, S.E.')
% 
% 
% % Plot of Normal Hand Force vs. Time, with markers
% figure(17)
% f1 = plot(T,MFn,'k-');
% ylim([round(min(MFn)*1.2,1) round(max(MFn)*1.2,1)])
% xlim([0 max(T)])
% ylabel('Force (N)')
% hold on
% set(gcf,'color','w');
% for i = 1:loops
%     f3 = plot(T(cross(i))*ones(length(vline),1),vline,'r-');
% end
% hold off
% xlabel('Time (s)')
% title([titl,': Motor Force v. Time'])
% legend([f1,f3],'force','start of cycle')

