%SerialLink.ikine6s Inverse kinematics for 6-axis robot with spherical wrist
%
% Q = R.ikine6s(T) is the joint coordinates corresponding to the robot
% end-effector pose T represented by the homogenenous transform.  This
% is a analytic solution for a 6-axis robot with a spherical wrist (such as
% the Puma 560).
%
% Q = R.IKINE6S(T, CONFIG) as above but specifies the configuration of the arm in
% the form of a string containing one or more of the configuration codes:
%
% 'l'   arm to the left (default)
% 'r'   arm to the right
% 'u'   elbow up (default)
% 'd'   elbow down
% 'n'   wrist not flipped (default)
% 'f'   wrist flipped (rotated by 180 deg)
%
% Notes::
% - Only applicable for an all revolute 6-axis robot RRRRRR.
% - The inverse kinematic solution is generally not unique, and 
%   depends on the configuration string.
% - Joint offsets, if defined, are added to the inverse kinematics to 
%   generate Q.
%
% Reference::
% - Inverse kinematics for a PUMA 560,
%   Paul and Zhang,
%   The International Journal of Robotics Research,
%   Vol. 5, No. 2, Summer 1986, p. 32-44
%
% Author::
% Robert Biro with Gary Von McMurray,
% GTRI/ATRP/IIMB,
% Georgia Institute of Technology
% 2/13/95
%
% See also SerialLink.FKINE, SerialLink.IKINE.

function theta = ikine6s(robot, T, varargin)
    
    if robot.mdh ~= 0
        error('Solution only applicable for standard DH conventions');
    end
    
    % recurse over all poses in a trajectory
    if ndims(T) == 3
        theta = zeros(size(T,3),robot.n);
        for k=1:size(T,3)
            theta(k,:) = ikine6s(robot, T(:,:,k), varargin{:});
        end
        return;
    end
    
    if ~robot.isspherical()
        error('wrist is not spherical')
    end
    
    if ~ishomog(T)
        error('RTB:ikine:badarg', 'T is not a homog xform');
    end
    
    % The configuration parameter determines what n1,n2,n4 values are used
    % and how many solutions are determined which have values of -1 or +1.
    
    if nargin < 3
        configuration = '';
    else
        configuration = lower(varargin{1});
    end
    
    % default configuration
    
    n1 = -1;    % L
    n2 = -1;    % U
    n4 = -1;    % N
    if ~isempty(strfind(configuration, 'l'))
        n1 = -1;
    end
    if ~isempty(strfind(configuration, 'r'))
        n1 = 1;
    end
    if ~isempty(strfind(configuration, 'u'))
        if n1 == 1
            n2 = 1;
        else
            n2 = -1;
        end
    end
    if ~isempty(strfind(configuration, 'd'))
        if n1 == 1
            n2 = -1;
        else
            n2 = 1;
        end
    end
    if ~isempty(strfind(configuration, 'n'))
        n4 = 1;
    end
    if ~isempty(strfind(configuration, 'f'))
        n4 = -1;
    end
                            L = robot.links;

            
    % 1 Puma
    % 2 Centred arm
    % 3 Offset arm
    % 4 Spherical
    
    type = 0;
    
    if isprismatic(L(3))
        type = 4;
    elseif 
    
    % test which type it is
    
    
    %% now solve for the first 3 joints, based on position of the spherical wrist centre
    x = T(1,4); y = T(2,4)); z = T(3,4);
    
    switch type
        case 1
            % Puma model with should and elbow offsets      

            a2 = L(2).a;
            a3 = L(3).a;
            d3 = L(3).d;
            d4 = L(4).d;        
            
            % undo base and tool transformations
            T = inv(robot.base) * T;
            T = T * inv(robot.tool);
            
            % The following parameters are extracted from the Homogeneous
            % Transformation as defined in equation 1, p. 34
            
            Ox = T(1,2);
            Oy = T(2,2);
            Oz = T(3,2);
            
            Ax = T(1,3);
            Ay = T(2,3);
            Az = T(3,3);
            
            Px = T(1,4);
            Py = T(2,4);
            Pz = T(3,4);

            %
            % Solve for theta(1)
            %
            % r is defined in equation 38, p. 39.
            % theta(1) uses equations 40 and 41, p.39,
            % based on the configuration parameter n1
            %
            
            r=sqrt(Px^2 + Py^2);
            if (n1 == 1)
                theta(1)= atan2(Py,Px) + asin(d3/r);
            else
                theta(1)= atan2(Py,Px) + pi - asin(d3/r);
            end
            
            %
            % Solve for theta(2)
            %
            % V114 is defined in equation 43, p.39.
            % r is defined in equation 47, p.39.
            % Psi is defined in equation 49, p.40.
            % theta(2) uses equations 50 and 51, p.40, based on the configuration
            % parameter n2
            %
            
            V114= Px*cos(theta(1)) + Py*sin(theta(1));
            r=sqrt(V114^2 + Pz^2);
            Psi = acos((a2^2-d4^2-a3^2+V114^2+Pz^2)/(2.0*a2*r));
            if ~isreal(Psi)
                warning('RTB:ikine6s:notreachable', 'point not reachable');
                theta = [NaN NaN NaN NaN NaN NaN];
                return
            end
            theta(2) = atan2(Pz,V114) + n2*Psi;
            
            %
            % Solve for theta(3)
            %
            % theta(3) uses equation 57, p. 40.
            %
            
            num = cos(theta(2))*V114+sin(theta(2))*Pz-a2;
            den = cos(theta(2))*Pz - sin(theta(2))*V114;
            theta(3) = atan2(a3,d4) - atan2(num, den);
            
        case 2
                % Centred arm

                a2 = L(2).a;
                a3 = L(3).a;
                d1 = L(1).d;
                
                r = sqrt(x^2 + y^2);
                                theta(1) = atan2(y, x);

                D = (x^2 + y^2 - d^2 + (z-d1)^2 - a2^2 -a3^2) / (2*a2*a3);
                
                theta(3) = atan2(n2*sqrt(1-D^2), D);
                
                c3 = cos(theta(3)); s3 = sin(theta(3));
                theta(2) = atan2( z-d1), sqrt(x^2+y^2-d^2)) - atan2(a3*s3, a2+a3*c3);
                
        case 3
                % Offset arm
                
                                a2 = L(2).a;
                a3 = L(3).a;
                d1 = L(1).d;
                
                r = sqrt(x^2 + y^2);
                theta(1) = atan2(y, x) + atan2(-d, -sqrt(r^2-d^2)); % left
                theta(1) = atan2(y, x) - 

                D = (x^2 + y^2 - d^2 + (z-d1)^2 - a2^2 -a3^2) / (2*a2*a3);
                
                theta(3) = atan2(n2*sqrt(1-D^2), D);
                
                c3 = cos(theta(3)); s3 = sin(theta(3));
                theta(2) = atan2( z-d1), sqrt(x^2+y^2-d^2)) - atan2(a3*s3, a2+a3*c3);

        case 4
                % Spherical (Stanford arm like)
                
                d1 = L(1).d;
                d2 = L(2).d;
                
                theta(1) = atan2(y, c);
                r = sqrt(x^2 + y^2);
                
                s = z - d1;
                
                theta(2) = atan2(s, r) + pi/2;
                theta(3) = sqrt(r^2 + s^2);
            
    end
    
    % Solve for the wrist rotation
    
    T13 = robot.A(1:3, theta(1:3));
    
    R = inv(T13)*T;
    
    theta(4) = atan2(n4*R(1,3), n4*R(2,3));
    theta(5) = atan2( R(3,3), sqrt(R(1,3)^2 + R(2,3)^2));
    theta(6) = atan2(-R(3,1), R(3,2));

    % remove the link offset angles
    for i=1:robot.n   %#ok<*AGROW>
        theta(i) = theta(i) - L(i).offset;
    end
