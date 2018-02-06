%%% Plots CW and CCW Velocity fluctuations on separate graphs

close all
clear all

%Slow velocity fluctuations or all speeds
load SubjectData.mat

CW1 = [2 4 6 8 10];
CW2 = [3 4 5 9 10 11 15 16 17 20 21 24 25 27 28];
CW3 = [2 4 6 8 10 12];
CW4 = [3 5 7 9 11];
CW5 = [2 4 6 7 10 12];
CW6 = [2 3 5 8 9 12];
CW7 = [2 3 5 7 8 13 14 17 18];
CW8 = [2 4 5 8 9 12];
CW9 = [2 3 5 7 8 13 14 17 18];
CW10 = [2 4 7 8 11 12 13 14 17 18];

%Slow velocity fluctuations or all speeds
load SubjectData.mat
MVel = [Data(1).MeanVel(CW1)';Data(2).MeanVel(CW2)';Data(3).MeanVel(CW3)';Data(4).MeanVel(CW4)';Data(5).MeanVel(CW5)';Data(6).MeanVel(CW6)';Data(7).MeanVel(CW7)';Data(8).MeanVel(CW8)';Data(9).MeanVel(CW9)';Data(10).MeanVel(CW10)'];
SVel = [Data(1).StdVel(CW1)';Data(2).StdVel(CW2)';Data(3).StdVel(CW3)';Data(4).StdVel(CW4)';Data(5).StdVel(CW5)';Data(6).StdVel(CW6)';Data(7).StdVel(CW7)';Data(8).StdVel(CW8)';Data(9).StdVel(CW9)';Data(10).StdVel(CW10)'];


CCW1 = [1 3 5 7 9];
CCW2 = [1 2 6 7 8 12 13 14 18 19 22 23 26];
CCW3 = [1 3 5 7 9 11];
CCW4 = [1 2 4 6 8 10];
CCW5 = [1 3 5 8 9 11];
CCW6 = [1 4 6 7 10 11];
CCW7 = [1 4 6 9 10 11 12 15 16];
CCW8 = [1 3 6 7 10 11];
CCW9 = [1 4 6 9 10 11 12 15 16];
CCW10 = [1 3 5 6 9 10 15 16 19 20];

MVelCCW = [Data(1).MeanVel(CCW1)';Data(2).MeanVel(CCW2)';Data(3).MeanVel(CCW3)';Data(4).MeanVel(CCW4)';Data(5).MeanVel(CCW5)';Data(6).MeanVel(CCW6)';Data(7).MeanVel(CCW7)';Data(8).MeanVel(CCW8)';Data(9).MeanVel(CCW9)';Data(10).MeanVel(CCW10)'];
SVelCCW = [Data(1).StdVel(CCW1)';Data(2).StdVel(CCW2)';Data(3).StdVel(CCW3)';Data(4).StdVel(CCW4)';Data(5).StdVel(CCW5)';Data(6).StdVel(CCW6)';Data(7).StdVel(CCW7)';Data(8).StdVel(CCW8)';Data(9).StdVel(CCW9)';Data(10).StdVel(CCW10)'];



subplot(1,2,1)
Ratio = SVel./MVel;

[K,I]=sort(MVel);
L = Ratio(I);
% L = SVel(I);

a=find(K==1);
b=find(K==-1);
K(a)=[];
K(b)=[];
L(a)=[];
L(b)=[];

load('slow.mat')
load('med.mat')
load('fast.mat')

Ns=[];
for (i=1:length(Lslow))
Ns =[Ns find(L==Lslow(i))];
end
LSlowCW = L(Ns);

Nm=[];
for (i=1:length(Lmed))
Nm =[Nm find(L==Lmed(i))];
end

LMedCW = L(Nm);

Nf=[];
for (i=1:length(Lfast))
Nf =[Nf find(L==Lfast(i))];
end

LFastCW = L(Nf);

% subplot(1,3,1)
% plot(K/(2*pi*.1),L/(2*pi*.1),'ro');
plot(K/(2*pi*.1),L,'ro');
h = lsline
p2 = polyfit(get(h,'xdata'),get(h,'ydata'),1)
xlabel('Mean Velocity (rev/s)')
ylabel('Ratio STD Vel/Mean Vel')
title('CW')
legend(['y = ' num2str(round(p2(1),2)) 'x + ' num2str(round(p2(2),2))],'Location','east')
set(gca, 'FontSize', 14, 'FontWeight', 'bold');
axis([0 2.5 0 0.8])
y1=get(gca,'ylim')



hold on
plot([0.075 0.075],y1)
text(0.075+0.01,0.5,'Slow','Rotation',90,'FontSize',12)
hold on
plot([0.5 .5],y1)
text(0.5+0.01,0.5,'Med','Rotation',90,'FontSize',12)
hold on
plot([2 2],y1)
text(2+0.01,.5,'Fast','Rotation',90,'FontSize',12)


subplot(1,2,2)
RatioCCW = SVelCCW./MVelCCW;

[KCCW,ICCW]=sort(MVelCCW);
LCCW = RatioCCW(ICCW);
% LCCW = SVelCCW(ICCW);

aCCW=find(KCCW==1);
bCCW=find(KCCW==-1);
KCCW(aCCW)=[];
KCCW(bCCW)=[];
LCCW(aCCW)=[];
LCCW(bCCW)=[];

Ms=[];
for (j=1:length(Lslow))
Ms =[Ms find(LCCW==Lslow(j))];
end

LSlowCCW = LCCW(Ms);

Mm=[];
for (j=1:length(Lmed))
Mm =[Mm find(LCCW==Lmed(j))];
end

LMedCCW = LCCW(Mm);

Mf=[];
for (j=1:length(Lfast))
Mf =[Mf find(LCCW==Lfast(j))];
end

LFastCCW = LCCW(Mf);



% subplot(1,3,1)
% plot(KCCW/(2*pi*.1),LCCW/(2*pi*.1),'bo');
plot(KCCW/(2*pi*.1),LCCW,'bo');
hCCW = lsline
p2CCW = polyfit(get(hCCW,'xdata'),get(hCCW,'ydata'),1)
xlabel('Mean Velocity (rev/s)')
ylabel('Ratio STD Vel/Mean Vel')
title('CCW')
legend(['y = ' num2str(round(p2CCW(1),2)) 'x + ' num2str(round(p2CCW(2),2))],'Location','east')
set(gca, 'FontSize', 14, 'FontWeight', 'bold');
axis([0 2.5 0 0.8])

y1=get(gca,'ylim')



hold on
plot([0.075 0.075],y1)
text(0.075+0.01,0.5,'Slow','Rotation',90,'FontSize',12)
hold on
plot([0.5 .5],y1)
text(0.5+0.01,0.5,'Med','Rotation',90,'FontSize',12)
hold on
plot([2 2],y1)
text(2+0.01,.5,'Fast','Rotation',90,'FontSize',12)


