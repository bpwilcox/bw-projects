% Robotics Toolbox.
% Version 9.9.0  2014-04-28
%
%
% Homogeneous transformations 3D
%    angvec2r                   - angle/vector to RM
%    angvec2tr                  - angle/vector to HT
%    eul2r                      - Euler angles to RM
%    eul2tr                     - Euler angles to HT
%    oa2r                       - orientation and approach vector to RM
%    oa2tr                      - orientation and approach vector to HT
%    r2t                        - RM to HT
%    rt2tr                      - (R,t) to HT
%    rotx                       - RM for rotation about X-axis
%    roty                       - RM for rotation about Y-axis
%    rotz                       - RM for rotation about Z-axis
%    rpy2r                      - roll/pitch/yaw angles to RM
%    rpy2tr                     - roll/pitch/yaw angles to HT
%    t2r                        - HT to RM
%    tr2angvec                  - HT/RM to angle/vector form
%    tr2eul                     - HT/RM to Euler angles
%    tr2rpy                     - HT/RM to roll/pitch/yaw angles
%    tr2rt                      - HT to (R,t)
%    tranimate                  - animate a coordinate frame
%    trchain                    - evaluate a series of transforms
%    tripleangle                - graphical interactive three angle rotation
%    transl                     - set or extract the translational component of HT
%    trnorm                     - normalize HT
%    trchain                    - chain of SE(3) transforms
%    trplot                     - plot HT as a coordinate frame
%    trprint                    - print an HT
%    trotx                      - HT for rotation about X-axis
%    troty                      - HT for rotation about Y-axis
%    trotz                      - HT for rotation about Z-axis
%    trscale                    - HT for scale change
%
%  * HT: homogeneous transformation, a 4x4 matrix, in SE(3)
%  * RM: rotation matrix, orthonormal 3x3 matrix, in SO(3)
%  * Functions of the form tr2XX will also accept an HT or RM as the argument
%
% Homogeneous transformations 2D
%    rot2                       - RM for SE(2) rotation
%    se2                        - HT in SE(2)
%    transl2                    - set or extract the translational component of SE(2) HT
%    trchain2                   - chain of SE(2) transforms
%    trot2                      - SO(2) rotation
%    trplot2                    - plot HT, SE(2), as a coordinate frame
%
%  * HT: homogeneous transformation, a 3x3 matrix, in SE(2)
%  * RM: rotation matrix, orthonormal 2x2 matrix, in SO(2)
%
% Homogeneous points and lines
%    e2h                        - Euclidean coordinates to homogeneous
%    h2e                        - homogeneous coordinates to Euclidean
%    homline                    - create line from 2 points
%    homtrans                   - transform points
%
% Differential motion
%    delta2tr                   - differential motion vector to HT
%    eul2jac                    - Euler angles to Jacobian
%    rpy2jac                    - RPY angles to Jacobian
%    skew                       - vector to skew symmetric matrix
%    tr2delta                   - HT to differential motion vector
%    tr2jac                     - HT to Jacobian
%    vex                        - skew symmetric matrix to vector
%    wtrans                     - transform wrench between frames
%
% Trajectory generation
%    ctraj                      - Cartesian trajectory
%    jtraj                      - joint space trajectory
%    lspb                       - 1D trapezoidal trajectory
%    mtraj                      - multi-axis trajectory for arbitrary function
%    mstraj                     - multi-axis multi-segment trajectory
%    tpoly                      - 1D polynomial trajectory
%    trinterp                   - interpolate HT s
%
% Quaternion
%    Quaternion                 - constructor
%    /                          - divide quaternion by quaternion or scalar
%    *                          - multiply quaternion by a quaternion or vector
%    inv                        - invert a quaternion
%    norm                       - norm of a quaternion
%    plot                       - display a quaternion as a 3D rotation
%    unit                       - unitize a quaternion
%    interp                     - interpolate a quaternion
%
% Serial-link manipulator
%    CodeGenerator              - construct a robot specific code generator object
%    SerialLink                 - construct a serial-link robot object
%    Link                       - construct a general robot link object
%    Prismatic                  - construct a prismatic robot link object
%    Revolute                   - construct a revolute robot link object
%    PrismaticMDH               - construct a prismatic robot link object
%    RevoluteMDH                - construct a revolute robot link object
%    *                          - compound two robots
%    friction                   - return joint friction torques
%    nofriction                 - return a robot object with no friction
%    perturb                    - return a robot object with perturbed parameters
%    plot                       - plot/animate robot
%    plot3d                     - plot/animate robot as solid model
%    teach                      - drive a graphical  robot
%
%     Models
%        mdl_Fanuc10L           - Fanuc 10L (DH, kine)
%        mdl_irb140             - ABB IRB140 (DH, kine)
%        mdl_irb140_mdh         - ABB IRB140 (MDH, kine)
%        mdl_jaco               - Kinova Jaco arm (DH, kine)
%        mdl_m16                - Fanuc M16 (DH, kine)
%        mdl_mico               - Kinova Mico arm (DH, kine)
%        mdl_MotomanHP6         - Motoman HP6 (DH, kine)
%        mdl_nao                - Alderabaran NAO arms and legs (DH, kine)
%        mdl_phantomx           - PhantomX pincher 4DOF hobby arm (DH, kine)
%        mdl_puma560            - Puma 560 data (DH, kine, dyn)
%        mdl_puma560akb         - Puma 560 data (MDH, kine, dyn)
%        mdl_S4ABB2p8           - ABB S4 2.8 (DH, kine)
%        mdl_stanford           - Stanford arm data (DH, kine, dyn)
%        mdl_stanford_mdh       - Stanford arm data (MDH, kine, dyn)
%        mdl_onelink            - simple 1-link example (DH, kine)
%        mdl_planar1            - simple 1 link planar model (DH, kine)
%        mdl_planar2            - simple 2 link planar model (DH, kine)
%        mdl_planar3            - simple 3 link planar model (DH, kine)
%        mdl_3link3d            - Simple 3DOF arm, no shoulder offset (DH, kine)
%        mdl_twolink            - simple 2-link example (DH, kine, dyn)
%        mdl_twolink_mdh        - simple 2-link example (MDH, kine)
%        mdl_ball               - high DOF chain that forms a ball
%        mdl_coil               - high DOF chain that forms a coil
%        mdl_hyper2d            - 2D high DOF chain
%        mdl_hyper3d            - 3D high DOF chain
%        mdl_quadcopter         - simple quadcopter model
%
%     Kinematic
%        DHFactor               - transform sequence to DH description
%        jsingu                 - find dependent joints
%        fkine                  - forward kinematics
%        ikine                  - inverse kinematics (numeric)
%        ikine_sym              - inverse kinematics (symbolic)
%        ikine6s                - inverse kinematics for 6-axis arm with sph.wrist
%        jacob0                 - Jacobian in base coordinate frame
%        jacobn                 - Jacobian in end-effector coordinate frame
%        maniplty               - compute manipulability
%
%     Dynamics
%        accel                  - forward dynamics
%        cinertia               - Cartesian manipulator inertia matrix
%        coriolis               - centripetal/coriolis torque
%        fdyn                   - forward dynamics
%        wtrans                 - transform a force/moment
%        gravload               - gravity loading
%        inertia                - manipulator inertia matrix
%        itorque                - inertia torque
%        rne                    - inverse dynamics
%
% Mobile robot
%    Map                        - point feature map object
%    RandomPath                 - driver for Vehicle object
%    RangeBearingSensor         - "laser scanner" object
%    Vehicle                    - construct a mobile robot object
%    sl_bicycle                 - Simulink "bicycle model" of non-holonomic wheeled vehicle
%    Navigation                 - Navigation superclass
%    Sensor                     - robot sensor superclass
%    makemap                    - build an occupancy grid
%    plot_vehicle               - plot vehicle
%
%     Localization
%        EKF                    - extended Kalman filter object
%        ParticleFilter         - Monte Carlo estimator
%
%     Path planning
%        Bug2                   - bug navigation
%        DXform                 - distance transform from map
%        Dstar                  - D* planner
%        PRM                    - probabilistic roadmap planner
%        RRT                    - rapidly exploring random tree
%
% Graphics
%    plot2                      - plot trajectory
%    plotp                      - plot points
%    plot_arrow                 - draw an arrow
%    plot_box                   - draw a box
%    plot_circle                - draw a circle
%    plot_ellipse               - draw an ellipse
%    plot_homline               - plot homogeneous line
%    plot_point                 - plot points
%    plot_poly                  - plot polygon
%    plot_sphere                - draw a sphere
%    qplot                      - plot joint angle trajectories
%    plot2                      - Plot trajectories
%    plotp                      - Plot trajectories
%    xaxis                      - set x-axis scaling
%    yaxis                      - set y-axis scaling
%    xyzlabel                   - label axes x, y and z
%
% Utility
%    about                      - summary of object size and type
%    angdiff                    - subtract 2 angles modulo 2pi
%    arrow3                     - draw a 3D arrow (third party code)
%    bresenham                  - Bresenhan line drawing
%    circle                     - compute/draw points on a circle
%    colnorm                    - columnwise norm of matrix
%    colorname                  - map color name to RGB
%    diff2                      - elementwise diff
%    edgelist                   - trace edge of a shape
%    gauss2d                    - Gaussian distribution in 2D
%    ishomog                    - true if argument is a 4x4 matrix
%    ismatrix                   - true if non scalar
%    isrot                      - true if argument is a 3x3 matrix
%    isvec                      - true if argument is a 3-vector
%    numcols                    - number of columns in matrix
%    numrows                    - number of rows in matrix
%    peak                       - find peak in 1D signal
%    peak2                      - find peak in 2D signal
%    PGraph                     - general purpose graph class
%    polydiff                   - derivative of polynomial
%    Polygon                    - general purpose polygon class
%    randinit                   - initialize random number generator
%    ramp                       - create linear ramp
%    unit                       - unitize a vector
%    tb_optparse                - toolbox argument parser
%    distancexform              - compute distance transform
%    runscript                  - interactively step through a script
%    multidfprintf              - printf extension
%
% Demonstrations
%    rtbdemo                    - Serial-link manipulator demonstration
%    tripleangle                - demonstrate angle sequences
%
% Interfacing
%    RobotArm                   - Connect SerialLink object to real robot
%    joystick                   - Help for joystick interface mex file
%    joy2tr                     - Update HT based on joystick input
%    VREP                       - VREP interface class
%    VREP_mirror                - MATLAB mirror for VREP object
%    VREP_arm                   - MATLAB mirror for VREP robot arm
%    VREP_obj                   - MATLAB mirror for VREP object
%    VREP_camera                - MATLAB mirror for VREP camera object
%
%  *  Arbotix class in the folder robot/interfaces
%  *  VREP classes are in the folder robot/interfaces/VREP
%
% Examples
%    sl_quadcopter              - Simulink model of a flying quadcopter
%    sl_braitenberg             - Simulink model a Braitenberg vehicle
%    movepoint                  - non-holonomic vehicle moving to a point
%    moveline                   - non-holonomic vehicle moving to a line
%    movepose                   - non-holonomic vehicle moving to a pose
%    walking                    - example of 4-legged walking robot
%    eg_inertia                 - joint 1 inertia I(q1,q2)
%    eg_inertia22               - joint 2 inertia I(q3)
%    eg_grav                    - joint 2 gravity load g(q2,q3)
%
%  *  located in the examples folder
%
% Copyright (C) 2011 Peter Corke
