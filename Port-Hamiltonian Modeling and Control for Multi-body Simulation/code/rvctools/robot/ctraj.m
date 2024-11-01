%CTRAJ Cartesian trajectory between two points
%
% TC = CTRAJ(T0, T1, N) is a Cartesian trajectory (4x4xN) from pose T0 to T1
% with N points that follow a trapezoidal velocity profile along the path.
% The Cartesian trajectory is a homogeneous transform sequence and the last 
% subscript being the point index, that is, T(:,:,i) is the i'th point along
% the path.
%
% TC = CTRAJ(T0, T1, S) as above but the elements of S (Nx1) specify the 
% fractional distance  along the path, and these values are in the range [0 1].
% The i'th point corresponds to a distance S(i) along the path.
%
% Notes::
% - If T0 or T1 is equal to [] it is taken to be the identity matrix.
%
% See also LSPB, MSTRAJ, TRINTERP, Quaternion.interp, TRANSL.



% Copyright (C) 1993-2014, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for MATLAB (RTB).
% 
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com

function traj = ctraj(T0, T1, t)

    if isempty(T0)
        T0 = eye(4,4);
    end
    if isempty(T1)
        T1 = eye(4,4);
    end
    
    if ~ishomog(T0) || ~ishomog(T1)
        error('arguments must be homogeneous transformations');
    end
    
    % distance along path is a smooth function of time
    if isscalar(t)
        s = lspb(0, 1, t);
    else
        s = t(:);
    end

    traj = [];

    for S=s'
        traj = cat(3, traj, trinterp(T0, T1, S));
    end

    
