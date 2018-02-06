function XYZPOS = get3dtarget(itf, signalname, residual, index1, index2)
% GET3DTARGET - returns nx4 array containing X,Y,Z trajectory data and
% residual.
% 
%   USAGE:  XYZPOS = get3dtarget(itf, signalname, residual*, index1*, index2*) 
%           * = not a necessary input
%   INPUTS:
%   itf        = variable name used for COM object
%   signalname = string name of desired marker
%   residual   = Return matrix with point residual in column 4.  
%                0 or no 3rd argument = false (returns nx3 with XYZ data only)
%                1 = true (returns nx4 with XYZ and residuals) 
%   index1     = start frame index, all frames if not used as an argument
%   index2     = end frame index, all frames if not used as an argument
%   OUTPUTS:
%   XYZPOS     = nx3/4 matrix with n frames and X, Y, Z, and/or residual as columns
   
%   C3D directory contains C3DServer activation and wrapper Matlab functions.
%   This function written by:
%   Matthew R. Walker, MSc. <matthewwalker_1@hotmail.com>
%   Michael J. Rainbow, BS. <Michael_Rainbow@brown.edu>
%   Motion Analysis Lab, Shriners Hospitals for Children, Erie, PA, USA
%   Questions and/or comments are most welcome.  
%   Last Updated: April 21, 2006
%   Created in: MATLAB Version 7.0.1.24704 (R14) Service Pack 1
%               O/S: MS Windows XP Version 5.1 (Build 2600: Service Pack 2)
%   
%   Please retain the author names, and give acknowledgement where necessary.  
%   DISCLAIMER: The use of these functions is at your own risk.  
%   The authors do not assume any responsibility related to the use 
%   of this code, and do not guarantee its correctness. 
     

if nargin == 2, 
    residual = 0;
    index1 = itf.GetVideoFrame(0); % frame start
    index2 = itf.GetVideoFrame(1); % frame end
elseif nargin == 3, 
    index1 = itf.GetVideoFrame(0); 
    index2 = itf.GetVideoFrame(1);
elseif nargin == 1,
    disp('Error: wrong number of inputs.');
    help getanalogchannel;
    return
end
 nIndex = itf.GetParameterIndex('POINT', 'LABELS');
 nItems = itf.GetParameterLength(nIndex);
 signalname = upper(signalname);
 signal_index = -1;
 found = 0;
 
fprintf('Extracting marker: %s', signalname);
 
for i = 1 : nItems,

    target_name = itf.GetParameterValue(nIndex, i-1);
    newstring = target_name(1:min(findstr(target_name, ' '))-1);
    newstring=target_name;
    if strmatch(newstring, [], 'exact'),
        newstring = target_name;
    end

%     disp(['findstr(', upper(newstring), ', ', signalname, ...
%         ') = ', num2str(findstr(upper(newstring), signalname))])

    if strmatch(upper(newstring), signalname, 'exact') == 1,
%     if findstr(upper(newstring), upper(signalname)) > 0,
        signal_index = i-1;
        found = 1;
    end  
end

if found == 0,
    error('Marker label %s not found in c3d file...\n', upper(signalname));
end

if signal_index ~= -1,
    XYZPOS(:,1) = itf.GetPointDataEx(signal_index,0,index1,index2,'1');
    XYZPOS(:,2) = itf.GetPointDataEx(signal_index,1,index1,index2,'1');
    XYZPOS(:,3) = itf.GetPointDataEx(signal_index,2,index1,index2,'1');
    RESIDS(:,1) = itf.GetPointResidualEx(signal_index,index1,index2);
end

 XYZPOS = cell2mat(XYZPOS);
 RESIDS = cell2mat(RESIDS);
 residindex = find(RESIDS == -1);
 XYZPOS(residindex, :) = NaN;
if residual == 1,
    XYZPOS = [XYZPOS, RESIDS];
end 
%--------------------------------------------------------------------------