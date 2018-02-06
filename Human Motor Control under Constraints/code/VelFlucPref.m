%VelFluc Pref


clear all
PN = [1 2];

P = [3 4];

PV = [5 6];

load SubjectData.mat

% MVelN = [Data(1).MeanVel([])';Data(2).MeanVel([1 3])';Data(3).MeanVel(PN)';Data(4).MeanVel(1)';Data(5).MeanVel(PN)';Data(6).MeanVel(PN)';Data(7).MeanVel(PN)';Data(8).MeanVel(PN)';Data(9).MeanVel(PN)';Data(10).MeanVel(PN)'];
% SVelN = [Data(1).StdVel([])';Data(2).StdVel([1 3])';Data(3).StdVel(PN)';Data(4).StdVel(1)';Data(5).StdVel(PN)';Data(6).StdVel(PN)';Data(7).StdVel(PN)';Data(8).StdVel(PN)';Data(9).StdVel(PN)';Data(10).StdVel(PN)'];
% 
% 
% MVel = [Data(1).MeanVel([])';Data(2).MeanVel([7 11])';Data(3).MeanVel(P)';Data(4).MeanVel([2 3])';Data(5).MeanVel(P)';Data(6).MeanVel(P)';Data(7).MeanVel(P)';Data(8).MeanVel(P)';Data(9).MeanVel(P)';Data(10).MeanVel(P)'];
% SVel = [Data(1).StdVel([])';Data(2).StdVel([7 11])';Data(3).StdVel(P)';Data(4).StdVel([2 3])';Data(5).StdVel(P)';Data(6).StdVel(P)';Data(7).StdVel(P)';Data(8).StdVel(P)';Data(9).StdVel(P)';Data(10).StdVel(P)'];
% 
% MVelV = [Data(1).MeanVel([])';Data(2).MeanVel([13 16])';Data(3).MeanVel(PV)';Data(4).MeanVel([4 5])';Data(5).MeanVel(PV)';Data(6).MeanVel(PV)';Data(7).MeanVel(PV)';Data(8).MeanVel(PV)';Data(9).MeanVel(PV)';Data(10).MeanVel([6 8])'];
% SVelV = [Data(1).StdVel([])';Data(2).StdVel([13 16])';Data(3).StdVel(PV)';Data(4).StdVel([4 5])';Data(5).StdVel(PV)';Data(6).StdVel(PV)';Data(7).StdVel(PV)';Data(8).StdVel(PV)';Data(9).StdVel(PV)';Data(10).StdVel([6 8])'];


% I had to take out some trials in order to match up appropriately CW and
% CCW trials. Some files were missing or uneven

% No Visual Preferred
MVelN = [Data(1).MeanVel([])';Data(2).MeanVel([1 3])';Data(3).MeanVel(PN)';Data(4).MeanVel(1)';Data(5).MeanVel(PN)';Data(6).MeanVel(PN)';Data(7).MeanVel(PN)';Data(8).MeanVel(PN)';Data(9).MeanVel(PN)';Data(10).MeanVel(PN)'];
SVelN = [Data(1).StdVel([])';Data(2).StdVel([1 3])';Data(3).StdVel(PN)';Data(4).StdVel(1)';Data(5).StdVel(PN)';Data(6).StdVel(PN)';Data(7).StdVel(PN)';Data(8).StdVel(PN)';Data(9).StdVel(PN)';Data(10).StdVel(PN)'];

% No Visual Preferred Constant
MVel = [Data(1).MeanVel([])';Data(2).MeanVel([7 11])';Data(3).MeanVel(P)';Data(4).MeanVel([2 3])';Data(5).MeanVel(P)';Data(6).MeanVel(P)';Data(7).MeanVel(P)';Data(8).MeanVel(P)';Data(9).MeanVel(P)';Data(10).MeanVel(P)'];
SVel = [Data(1).StdVel([])';Data(2).StdVel([7 11])';Data(3).StdVel(P)';Data(4).StdVel([2 3])';Data(5).StdVel(P)';Data(6).StdVel(P)';Data(7).StdVel(P)';Data(8).StdVel(P)';Data(9).StdVel(P)';Data(10).StdVel(P)'];

% Visual Preferred Constant
MVelV = [Data(1).MeanVel([])';Data(2).MeanVel([13 16])';Data(3).MeanVel(PV)';Data(4).MeanVel([4 5])';Data(5).MeanVel(PV)';Data(6).MeanVel(PV)';Data(7).MeanVel(PV)';Data(8).MeanVel(PV)';Data(9).MeanVel(PV)';Data(10).MeanVel([6 8])'];
SVelV = [Data(1).StdVel([])';Data(2).StdVel([13 16])';Data(3).StdVel(PV)';Data(4).StdVel([4 5])';Data(5).StdVel(PV)';Data(6).StdVel(PV)';Data(7).StdVel(PV)';Data(8).StdVel(PV)';Data(9).StdVel(PV)';Data(10).StdVel([6 8])'];


 
Sub1 = [2 2 3 3 4 5 5 6 6 7 7 8 8 9 9 10 10];
Sub2 = [2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10];
Sub3 = [2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10];
% % 
plot(Sub1,SVelN./MVelN,'bs','MarkerSize',10)
hold on 
plot(Sub2,SVel./MVel,'gd','MarkerSize',10)
hold on 
plot(Sub3,SVelV./MVelV,'ro','MarkerSize',10)
legend('Preferred','Preferred constant','Preferred Visual')
xlabel('Subject Number')
ylabel('Coefficient of Variation')
title('Preferred Speed')
axis([1 11 0 0.5])


% T-tests for preffered trials
% Currently there is an error because there is a missing data point for
% Subject D, no visual preffered CW, 'D_1_CW'. This is because the EMG file
% was not written proprely and the circulargrav code couldn't run. This
% could be fixed. For now (as I did), can make vectors same length.

% [hn2c, pn2c] = ttest(SVelN./MVelN,SVel./MVel)
% [hn, pm2] = ttest(SVelN./MVelN,SVelV./MVelV)
% [hf2, pf2] = ttest(SVel./MVel,SVelV./MVelV)



