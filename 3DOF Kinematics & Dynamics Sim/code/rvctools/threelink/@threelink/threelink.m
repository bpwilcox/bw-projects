classdef threelink < SerialLink
 
	properties
	end
 
	methods
		function ro = threelink()
			objdir = which('threelink');
			idx = find(objdir == filesep,2,'last');
			objdir = objdir(1:idx(1));
			 
			tmp = load(fullfile(objdir,'@threelink','matthreelink.mat'));
			 
			ro = ro@SerialLink(tmp.sr);
			 
			 
		end
	end
	 
end
