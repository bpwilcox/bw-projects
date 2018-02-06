%%% CW vs CCW

close all
clear all

%Slow velocity fluctuations or all speeds
load SubjectData.mat

CW1 = [2 4 6 8 10];
% CW2 = [3 4 5 9 10 11 15 16 17 20 21 24 25 27 28];
% CW2 = [3 4 9 10 11 15 16 17 20 21 24 25 27 28];
CW2 = [3 4 9 10 11 15 16 17 20 21 24 25 28];
CW3 = [2 4 6 8 10 12];
CW4 = [3 5 7 9 11];
CW5 = [2 4 6 7 10 12];
CW6 = [2 3 5 8 9 12];
CW7 = [2 3 5 7 8 13 14 17 18];
% CW8 = [2 4 5 8 9 12];
CW8 = [2 4 5 12];
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
% CCW8 = [1 3 6 7 10 11];
CCW8 = [1 3 6 11];
CCW9 = [1 4 6 9 10 11 12 15 16];
CCW10 = [1 3 5 6 9 10 15 16 19 20];

MVelCCW = [Data(1).MeanVel(CCW1)';Data(2).MeanVel(CCW2)';Data(3).MeanVel(CCW3)';Data(4).MeanVel(CCW4)';Data(5).MeanVel(CCW5)';Data(6).MeanVel(CCW6)';Data(7).MeanVel(CCW7)';Data(8).MeanVel(CCW8)';Data(9).MeanVel(CCW9)';Data(10).MeanVel(CCW10)'];
SVelCCW = [Data(1).StdVel(CCW1)';Data(2).StdVel(CCW2)';Data(3).StdVel(CCW3)';Data(4).StdVel(CCW4)';Data(5).StdVel(CCW5)';Data(6).StdVel(CCW6)';Data(7).StdVel(CCW7)';Data(8).StdVel(CCW8)';Data(9).StdVel(CCW9)';Data(10).StdVel(CCW10)'];




Ratio = SVel./MVel;
K=MVel;
L = Ratio;


a=find(K==1);
b=find(K==-1);
K(a)=[];
K(b)=[];
L(a)=[];
L(b)=[];

load('slow.mat')
load('med.mat')
load('fast.mat')

% Separate out Clockwise trials

Ns=[];
for (i=1:length(Lslow))
Ns =[Ns find(L==Lslow(i))];
end
LSlowCW = L(Ns);
KSlowCW = K(Ns);

Nm=[];
for (i=1:length(Lmed))
Nm =[Nm find(L==Lmed(i))];
end

LMedCW = L(Nm);
KMedCW = K(Nm);

Nf=[];
for (i=1:length(Lfast))
Nf =[Nf find(L==Lfast(i))];
end

LFastCW = L(Nf);
KFastCW = K(Nf);





%Separate CCW trials

RatioCCW = SVelCCW./MVelCCW;



KCCW = MVelCCW;
LCCW = RatioCCW;

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
KSlowCCW = KCCW(Ms);

Mm=[];
for (j=1:length(Lmed))
Mm =[Mm find(LCCW==Lmed(j))];
end

LMedCCW = LCCW(Mm);
KMedCCW = KCCW(Mm);

Mf=[];
for (j=1:length(Lfast))
Mf =[Mf find(LCCW==Lfast(j))];
end

LFastCCW = LCCW(Mf);
KFastCCW = KCCW(Mf);

LCCW=LFastCCW;
KCCW=KFastCCW;



% Combine CCW and CW trials for graphing

Ktot = [KSlowCW; KSlowCCW; KMedCW; KMedCCW; KFastCW; KFastCCW];
Ltot = [LSlowCW; LSlowCCW; LMedCW; LMedCCW; LFastCW; LFastCCW];

KtotCW = [KSlowCW; KMedCW; KFastCW];
LtotCW = [LSlowCW; LMedCW; LFastCW];


KtotCCW = [KSlowCCW; KMedCCW; KFastCCW];
LtotCCW = [LSlowCCW; LMedCCW; LFastCCW];


[KsortTot,Itot] = sort(Ktot);
LsortTot = Ltot(Itot);


plot(KsortTot/(2*pi*.1),LsortTot,'bo');
hTot = lsline
p2Tot = polyfit(get(hTot,'xdata'),get(hTot,'ydata'),1);
xlabel('Mean Velocity (rev/s)')
ylabel('Coefficient of Variation')

% Determine R^2

x= KsortTot/(2*pi*.1);
y =LsortTot/(2*pi*.1);
p3 = polyfit(x,y,1);
yfit = polyval(p3,x);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal;


title('Velocity Fluctuations - All Subjects (both CW and CCW)')

% legend(['y = ' num2str(round(p2(1),2)) 'x + ' num2str(round(p2(2),2))],'Location','east')
legend(['y = ' num2str(round(p2Tot(1),2)) 'x + ' num2str(round(p2Tot(2),2))],['R^2 = ' num2str(round(rsq,2))],'Location','east')


hold on 
plot(KtotCW/(2*pi*.1),LtotCW,'bo');
hold on
plot(KtotCCW/(2*pi*.1),LtotCCW,'ro');





set(gca, 'FontSize', 12, 'FontWeight', 'bold');

axis([0 2.5 0 0.8])



y1=get(gca,'ylim');



hold on
plot([0.075 0.075],y1)
text(0.075+0.01,0.5,'Slow','Rotation',90,'FontSize',12)
hold on
plot([0.5 .5],y1)
text(0.5+0.01,0.5,'Med','Rotation',90,'FontSize',12)
hold on
plot([2 2],y1)
text(2+0.01,.5,'Fast','Rotation',90,'FontSize',12)


hold on 
M1 = 0.0728;
ss1 = 0.0099;
ha1 = area([M1-ss1 M1+ss1], [1.2 1.2],'FaceAlpha',0.2);
hold on 
M2 = 0.5219;
ss2 = 0.0293;
ha2 = area([M2-ss2 M2+ss2], [1.2 1.2],'FaceAlpha',0.2);
hold on 
M3 = 1.9149;
ss3 = 0.0691;
ha3 = area([M3-ss3 M3+ss3], [1.2 1.2],'FaceAlpha',0.2);


%%%%%%%%%%%%%%%%%%%%%%
% Statistical Calculations for ttest and two-way ANOVA



% CVSlowCW = mean(LSlowCW); 
% CVSlowCWS = std(LSlowCW);
% CVSlowCCW = mean(LSlowCCW);
% CVSlowCCWS = std(LSlowCCW);
% CVSlow = mean([LSlowCW ;LSlowCCW]);
% CVSlowS = std([LSlowCW ;LSlowCCW]);
% 
% CVMedCW = mean(LMedCW);
% CVMedCWS = std(LMedCW);
% CVMedCCW = mean(LMedCCW);
% CVMedCCWS = std(LMedCCW);
% CVMed = mean([LMedCW ;LMedCCW]);
% CVMedS = std([LMedCW ;LMedCCW]);
% 
% 
% CVFastCW = mean(LFastCW);
% CVFastCWS = std(LFastCW);
% CVFastCCW = mean(LFastCCW);
% CVFastCCWS = std(LFastCCW);
% CVFast = mean([LFastCW ;LFastCCW]);
% CVFastS = std([LFastCW ;LFastCCW]);
% 
% CVDirMean=ones(2,3);
% CVDirStd=ones(2,3);
% CVMean = ones(1,3);
% CVStd = ones(1,3);
% 
% 
% CVDirMean(1,1) = CVSlowCW;
% CVDirMean(1,2) = CVMedCW;
% CVDirMean(1,3) = CVFastCW;
% 
% CVDirMean(2,1) = CVSlowCCW;
% CVDirMean(2,2) = CVMedCCW;
% CVDirMean(2,3) = CVFastCCW;
% 
% 
% CVDirStd(1,1) = CVSlowCWS;
% CVDirStd(1,2) = CVMedCWS;
% CVDirStd(1,3) = CVFastCWS;
% 
% CVDirStd(2,1) = CVSlowCCWS;
% CVDirStd(2,2) = CVMedCCWS;
% CVDirStd(2,3) = CVFastCCWS;
% 
% %%%%%%%%%%%%%%%%%%%%
% 
% CVMean(1,1) = CVSlow;
% CVMean(1,2) = CVMed;
% CVMean(1,3) = CVFast;
% 
% CVStd(1,1) = CVSlowS;
% CVStd(1,2) = CVMedS;
% CVStd(1,3) = CVFastS;
% 
% A = [LSlowCW(1:13);LSlowCCW(1:13)];
% B = [LMedCW(1:13);LMedCCW(1:13)];
% C = [LFastCW(1:13);LFastCCW(1:13)];
% 
% CVTest = [A,B,C];
% % Two-Way Anova Test
% p = anova2(CVTest,13)
% 
% 
% % [hs, ps] = ttest2(LSlowCW,LSlowCCW)
% % [hm, pm] = ttest2(LMedCW,LMedCCW)
% % [hf, pf] = ttest2(LFastCW,LFastCCW)
% 
% 
% % LSlowCW = sort(LSlowCW);
% % LMedCW = sort(LMedCW);
% % LFastCW = sort(LFastCW);
% % 
% % LSlowCCW = sort(LSlowCCW);
% % LMedCCW = sort(LMedCCW);
% % LFastCCW = sort(LFastCCW);
% 
% [hs2, ps2] = ttest(LSlowCW,LSlowCCW)
% [hm2, pm2] = ttest(LMedCW,LMedCCW)
% [hf2, pf2] = ttest(LFastCW,LFastCCW)
% 
% 
% 
% 

% % t-Tests
% % hsvm = ttest2(A,B)
% [hsvm,psvm]= ttest(A,B)
% 
% % hsvf = ttest2(A,C)
% [hsvf,psvf]= ttest(A,C)
% 
% % hmvf = ttest2(B,C)
% [hmvf,pmvf]= ttest(B,C)
% 
% 

% % Summary graph
% figure
% bar([1 2 3], CVMean,'FaceAlpha',0.3)
% hold on
% errorbar(CVMean,CVStd,'color','k','linestyle','none')
% % errorbar(CVMean,[1 1 1],'color','k','linestyle','none')
% set(gca,'XTickLabel',{'Slow', 'Medium', 'Fast'})
% xlabel('Display Speed')
% ylabel('Coefficient of Variation (CV)')
% 
% set(gca, 'FontSize', 14, 'FontWeight', 'bold');
% 
% % 
% A2 = [KSlowCW(1:13);KSlowCCW(1:13)]/(2*pi*0.1);
% B2 = [KMedCW(1:13);KMedCCW(1:13)]/(2*pi*0.1);
% C2 = [KFastCW(1:13);KFastCCW(1:13)]/(2*pi*0.1);
% % 
% % 
% % [hs,ps] = ttest(A2/(2*pi*0.1),0.075*ones(length(A2),1))
% % [hm,pm] = ttest(B2/(2*pi*0.1),0.5*ones(length(B2),1))
% % [hf,pf] = ttest(C2/(2*pi*0.1),2*ones(length(C2),1))
% 
% 
% 
% 
% %%%
% %How accurate are people?
% % 
% Slow = 0.075*ones(length(A2),1);
% Med = 0.5*ones(length(B2),1);
% Fast = 2*ones(length(C2),1);
% % 
% % % PESlow =100*((A2 - Slow)/0.075);
% % % PEMed = 100*((B2 - Med)/0.5);
% % % PEFast = 100*((C2 - Fast)/2);
% % 
% PESlow =100*abs((A2 - Slow)/0.075);
% PEMed = 100*abs((B2 - Med)/0.5);
% PEFast = 100*abs((C2 - Fast)/2);
% % 
% % 
% mPESlow = mean(PESlow)
% mPEMed = mean(PEMed)
% mPEFast = mean(PEFast)
% 
% % 
% % 
% % % [hsm,psm]= ttest2(PESlow,PEMed)
% % % 
% % % % hsvf = ttest2(A,C)
% % % [hsf,psf]= ttest2(PESlow,PEFast)
% % % 
% % % % hmvf = ttest2(B,C)
% % % [hmf,pmf]= ttest2(PEMed,PEFast)
% % 
% % 
% figure
% plot(A2/(2*pi*0.1),PESlow,'ro')
% hold on
% plot(B2/(2*pi*0.1),PEMed,'bo')
% hold on
% plot(C2,PEFast,'go')
% % 
% % 
