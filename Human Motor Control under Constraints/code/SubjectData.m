% This script is used to initialize the data structure for the subject data


clear all
Subjects = {'A','B','C','D','E','F','G', 'H','I','J'}';
% X and Y Position of syncronization tool that was calibrated and recorded for each subject
Xpos = {-62,-77.82,-77.9,-78.68,-69.47,-67.348,-78.95,-70.304,-75.2,-75.79}';
Ypos = {80,62.25,62.6,61.53,71.8,73.823,61.133,70.959,65.735,65.041}';

% Data = struct('Subject',Subjects);]

%for subjects A-D
%faster way includes grabbing file names (maybe later)

A = {'A_1_CCW','A_1_CW','A_2_CCW','A_2_CW','A_3_Slow_CCW', 'A_3_Slow_CW','A_3_Med_CCW','A_3_Med_CW'...
   ,'A_3_Fast_CCW','A_3_Fast_CW'}';

B = {'B_1_CCW_1','B_1_CCW_2','B_1_CW_1','B_1_CW_2','B_1_CW_3','B_2_CCW_1','B_2_CCW_2','B_2_CCW_3'...
    ,'B_2_CW_1','B_2_CW_2','B_2_CW_3','B_3_CCW_1','B_3_CCW_2','B_3_CCW_3','B_3_CW_1','B_3_CW_2','B_3_CW_3'...
    ,'B_4_Slow_CCW_1','B_4_Slow_CCW_2','B_4_Slow_CW_1','B_4_Slow_CW_2','B_4_Med_CCW_1','B_4_Med_CCW_2','B_4_Med_CW_1','B_4_Med_CW_2'...
   ,'B_4_Fast_CCW_2','B_4_Fast_CW_1','B_4_Fast_CW_2'}';

C = {'C_1_CCW','C_1_CW','C_2_CCW','C_2_CW','C_3_CCW','C_3_CW','C_4_Slow_CCW','C_4_Slow_CW','C_4_Med_CCW','C_4_Med_CW'...
   ,'C_4_Fast_CCW','C_4_Fast_CW'}';

D = {'D_1_CCW','D_2_CCW','D_2_CW','D_3_CCW','D_3_CW','D_4_Slow_CCW','D_4_Slow_CW','D_4_Med_CCW','D_4_Med_CW'...
   ,'D_4_Fast_CCW','D_4_Fast_CW'}';




%for subjects E-J

E = 1:12;
E=E';
Ec=num2cell(E);
F = 1:12;
F=F';
Fc=num2cell(F);
G = 1:18;
G=G';
Gc=num2cell(G);
H = 1:12;
H=H';
Hc=num2cell(H);
I = 1:18;
I=I';
Ic=num2cell(I);
J = 1:20;
J=J';
Jc=num2cell(J);

for i = 1:12
    
file = {strcat('e',num2str(E(i)))};
EmgE(i)=file;
file = {strcat('f',num2str(F(i)))};
EmgF(i)=file;
file = {strcat('h',num2str(H(i)))};
EmgH(i)=file;

end
for i = 1:18
    
file = {strcat('g',num2str(G(i)))};
EmgG(i)=file;
file = {strcat('i',num2str(I(i)))};
EmgI(i)=file;

end

for i = 1:20
    
file = {strcat('j',num2str(J(i)))};
EmgJ(i)=file;

end
EmgE=EmgE';
EmgF=EmgF';
EmgG=EmgG';
EmgH=EmgH';
EmgI=EmgI';
EmgJ=EmgJ';

Files = {A;B;C;D;E;F;G;H;I;J};
EMG = {A;B;C;D;EmgE;EmgF;EmgG;EmgH;EmgI;EmgJ};


%Direction
% 1 is for CCW, -1 is for CW
Ad = [1,-1,1,-1,1,-1,1,-1,1,-1];
Bd = [1,1,-1,-1,-1,1,1,1,-1,-1,-1,1,1,1,-1,-1,-1,1,1,-1,-1,1,1,-1,-1,1,-1,-1];
Cd = [1,-1,1,-1,1,-1,1,-1,1,-1,1,-1];
Dd = [1,1,-1,1,-1,1,-1,1,-1,1,-1];
Ed = [1,-1,1,-1,1,-1,-1,1,1,-1,1,-1];
Fd = [1,-1,-1,1,-1,1,1,-1,-1,1,1,-1];
Gd = [1,-1,-1,1,-1,1,-1,-1,1,1,1,1,-1,-1,1,1,-1,-1];
Hd = [1,-1,1,-1,-1,1,1,-1,-1,1,1,-1];
Id = [1,-1,-1,1,-1,1,-1,-1,1,1,1,1,-1,-1,1,1,-1,-1];
Jd = [1,-1,1,-1,1,1,-1,-1,1,1,-1,-1,-1,-1,1,1,-1,-1,1,1];

Direction = {Ad;Bd;Cd;Dd;Ed;Fd;Gd;Hd;Id;Jd};




Data = struct('Subject',Subjects, 'SyncX', Xpos,'SyncY',Ypos,'Experiment',Files,'EMG',EMG,'Direction',Direction,'MeanVel',Direction,'StdVel',Direction);

save 'SubjectData.mat' Data