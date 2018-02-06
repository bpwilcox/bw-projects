function frames = nframes(itf)
% NFRAMES - returns integer value of the number of video frames
% contained in an open C3D file.
% 
% USAGE: frames = nframes(itf)
% INPUTS:
%   itf  = variable name used for COM object
% OUTPUTS:
%   frames = integer value of number of video frames in c3d file


 frames = itf.GetVideoFrame(1) - itf.GetVideoFrame(0) + 1;
%--------------------------------------------------------------------------