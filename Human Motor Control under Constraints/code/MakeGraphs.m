load SubjectData.mat
%iterate through subject data and make plots and/or find mean and standard
%deviation for all trials

for  i=1:10
    for j = 1:length(Data(i).Experiment)
%     for j = 6:6      
        circular_grav(i,j)
        close all
    end
end
% Note, some trials have errors (file was not written properly or other, so
% those trials need to be skipped)