# bw-projects
This repository is a collection of robotics, control, and machine learning relevant projects over the past few years. It is meant to provide an overview of some of the technical methods that I have implemented in code.

# List of Projects:
* [Study of Human Motor Control and Task Performance with Circular Constraints](#study-of-human-motor-control-and-task-performance-with-circular-constraints) 
* [Adaptive Virtual Object Controller for an Interactive Robotic Manipulator](#adaptive-virtual-object-controller-for-an-interactive-robotic-manipulator)
* [Impedance Control for Use in Autonomous Decommissioning](#impedance-control-for-use-in-autonomous-decommissioning)
* [Port-Hamiltonian Modeling and Control for Multi-Body Simulation](#port-hamiltonian-modeling-and-control-for-multi-body-simulation)
* [Model-Less Control using local Jacobian updates](#model-less-control-using-local-jacobian-updates)
* [Online Learning and Control using Sparse Local Gaussian Processes for Teleoperation](#online-learning-and-control-using-sparse-local-gaussian-processes-for-teleoperation)
* [Orientation Tracking and Panoramic Image Stitching with IMU](#orientation-tracking-and-panoramic-image-stitching-with-imu) 
* [Color Segmentation and Barrel Detection](#color-segmentation-and-barrel-detection)
* [SLAM and Texture Mapping of mobile robot](#slam-and-texture-mapping-of-mobile-robot)
* [Kinematic and Dynamic Simulation of simple 3 DOF Robot Arm](#kinematic-and-dynamic-simulation-of-simple-3-dof-robot-arm)
* [2D Planar RRT motion planner](#2d-planar-rrt-motion-planner)
* [Support Vector Machines](#support-vector-machines)
* [Pixel Classification via EM for Gaussian Mixtures](#pixel-classification-via-em-for-gaussian-mixtures) 
* [Principal Component Analysis vs Linear Discriminant Analysis for Face Recognition](#principal-component-analysis-vs-linear-discriminant-analysis-for-face-recognition)
* [Multi-Layer Perceptron for MNIST digit classification](#multi-layer-perceptron-for-mnist-digit-classification)
* [Convolutional Neural Network Transfer Learning](#convolutional-neural-network-transfer-learning)
* [Character Level Recurrent Neural Network for music generation](#character-level-recurrent-neural-network-for-music-generation)
* [Bidirectional LSTM RNN for Metrical Analysis of Poetry](#bidirectional-lstm-rnn-for-metrical-analysis-of-poetry)


# Project Overviews:
## Study of Human Motor Control and Task Performance with Circular Constraints
### Description:
This project is from my MIT MechE bachelor's thesis. The aim is to investigate human motor control strategies. Curved constraints offer a unique opportunity to exploit forces of contact. A circular crank experiment using the MIT MANUS
robot was designed in order to test how well subjects can follow a set of simple instructions to
rotate the crank at various constant speeds.
### Methods:
* Velocity, force, and EMG data were collected during four tasks: 
  * turning the crank at the subject’s preferred or comfortable speed 
  * turning the crank at a constant preferred speed,
  * turning the crank at a constant preferred speed with a visual feedback display
  * rotating the crank at three instructed speeds (slow, medium, and fast) with visual feedback. 
* The coefficient of variation (CV) of the velocity for each trial was computed as a measure of performance.
### Results
Statistical analysis showed that speed significantly affected CV but the direction of turning the
crank, clockwise or counterclockwise, did not. The observation that CV increased as speed
decreased, despite visual feedback, confirms previous studies showing that human motor control
is more imprecise at slower speeds.

## Adaptive Virtual Object Controller for an Interactive Robotic Manipulator
### Description:
This project followed my thesis work in the MIT graduate course 2.152: Nonlinear Control, taught by Jean-Jacques Slotine. An InMotion2 planar robot arm was being used in research as a virtual crank in order to test human performance and motor control strategies with constrained motion. A limitation of these experiments is the non-uniform inertia of the robot manipulator which creates an undesired or less convincing experience for the subject and more unreliable data for the researcher. This project aimed to investigate a controller design which would remove the inertial and nonlinear effects of the device arm and will compensate for errors in the model while maintaining the virtual constraint. To do this, an adaptive impedance/admittance controller is designed and shown to be globally asymptotically stable for this application. 
### Methods:
* Computed Torque control: cancel inertial and nonlinear effects
* Admittance control: simulate virtual crank constraint and inertia
* Adaptive control: compensate for innacuracy of model 
### Results
Simulations showed convergence of the end effector to the radius and maintenance of desired velocity yet not convergence to the theoretical parameters.

## Impedance Control for Use in Autonomous Decommissioning
### Description:
This project was a group project in the MIT graduate course: 2.151: Advanced System Dyamics & Control The goal of this project is to determine the feasibility of achieving desirable endpoint impedances to promote stable and robust interactions from a free-floating vehicle equipped with a backdrivable manipulator, such as in the task of autonomous decommissioning of underwater structures. Because such a vehicle does not exist yet, analyses are drawn from two similar systems that together encapsulate the desired system: a fixed-base anthropomorphic robot with a redundant backdrivable manipulator (Baxter), and a free-floating raft with a non-backdrivable manipulator (Dexter), both constrained to planar motion. An LQR controller design is also compared to address the mechanical and control effort constraints for the given robots and tasks.  

### Methods:
* Impedance control design
* Observer design
* Kalman filter
* LQR control

### Results
Through experimentation, Dexter provides a concrete example of achievable manipulator impedance characteristics for a desirable interaction response, creating the performance parameters that are then matched by Baxter’s more complex manipulator. Physical experimentation is complemented by simulations of the two impedance systems, using the physical parameters determined for both Dexter and Baxter. LQR design is suitable for considering limitations on the actuators and geometry of the manipulators, with future work possible to include impedance into the cost function. 

## Port-Hamiltonian Modeling and Control for Multi-Body Simulation
### Description:

### Methods:

### Results

## Model-Less Control using local Jacobian updates
### Description:

### Methods:

### Results

## Online Learning and Control using Sparse Local Gaussian Processes for Teleoperation
### Description:

### Methods:

### Results

## Orientation Tracking and Panoramic Image Stitching with IMU 
### Description:

### Methods:

### Results

## Color Segmentation and Barrel Detection 
### Description:

### Methods:

### Results

## SLAM and Texture Mapping of mobile robot
### Description:

### Methods:

### Results

## Kinematic and Dynamic Simulation of simple 3 DOF Robot Arm
### Description:

### Methods:

### Results

## 2D Planar RRT motion planner
### Description:

### Methods:

### Results

## Support Vector Machines
### Description:

### Methods:

### Results

## Pixel Classification via EM for Gaussian Mixtures 
### Description:

### Methods:

### Results

## Principal Component Analysis vs Linear Discriminant Analysis for Face Recognition
### Description:

### Methods:

### Results

## Multi-Layer Perceptron for MNIST digit classification
### Description:

### Methods:

### Results

## Convolutional Neural Network Transfer Learning
### Description:

### Methods:

### Results

## Character Level Recurrent Neural Network for music generation
### Description:

### Methods:

### Results

## Bidirectional LSTM RNN for Metrical Analysis of Poetry
### Description:

### Methods:

### Results




