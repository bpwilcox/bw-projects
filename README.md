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
rotate the crank at various constant speeds. In addition to velocity measurements read at the end effector of teh MIT MANUS, force and EMG measurements are also taken and qualitatively analyzed.
### Methods:
* Velocity, force, and EMG data were collected during four tasks: 
  * turning the crank at the subject’s preferred or comfortable speed 
  * turning the crank at a constant preferred speed,
  * turning the crank at a constant preferred speed with a visual feedback display
  * rotating the crank at three instructed speeds (slow, medium, and fast) with visual feedback. 
* The coefficient of variation (CV) of the velocity for each trial was computed as a measure of performance.
### Results
![pref](https://user-images.githubusercontent.com/22353511/35853880-9ce051c2-0ae3-11e8-9601-4f820cd91725.jpg)
![cvspeed](https://user-images.githubusercontent.com/22353511/35853901-af42be2c-0ae3-11e8-9325-59e630351f63.jpg)

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
![circlefast](https://user-images.githubusercontent.com/22353511/35853224-ce1b093c-0ae1-11e8-948f-39fe4c2e75bd.jpg)
![circlefastr](https://user-images.githubusercontent.com/22353511/35853284-f47b6c48-0ae1-11e8-8e76-f810c9c4a22f.jpg)
![params](https://user-images.githubusercontent.com/22353511/35853299-fc924924-0ae1-11e8-8f5f-a053e339775d.jpg)

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
This project was undertaken during my internship abroad in the UPC Biomechanical Engineering Group (BIOMEC) in Barcelona, Spain. In this work, we focused on the Port-Hamiltonian modeling approach as a method for control design of human multi-body computer simulations (Matlab suffers erros in forward simulation as a result of numerical integration). This pH approach is viable for biomechanical systems because it is simple to connect multiple body segments, external assistive devices, actuators, and more under the same methodology. Under this Port-Hamiltonian formulation, we conduct inverse dynamics, forward dynamics, and control design in a way that remains consistent with the fundamental framework and that is easily implemented in computer simulations. We have described a pH model of a simple biomechanical system and show how the pH model is suitable for the simulation of human generated motion capture data.
### Methods:
* Motion Capture
* Coordinate Correction for rigid-body links
* PD Control
* Port-Hamiltonian dynamics modeling and control design

### Results
Below is the forward dynamics simulation with no control 
![forwardsim](https://user-images.githubusercontent.com/22353511/35853989-e554474c-0ae3-11e8-9c4e-6b3bb31320b7.jpg)
Using the PH control design, we obtain:
![phcontrolsim](https://user-images.githubusercontent.com/22353511/35854013-fcf68374-0ae3-11e8-8699-b0ccbb392d85.jpg)

While PD control is a common, and successful, method for reducing the tracking error, we find that the control design described by Dirksz and Scherpen to offer the advantage of transforming the Port-Hamiltonian formulation of the system into a new form that is easily implemented without having to perform inverse dynamics directly.

## Model-Less Control using local Jacobian updates
### Description:
This was the beginning of my current MS research project where I began by trying to extend my advisor, Professor Yip's, previous work on model-less control of continuum manipulators. This work is a simple example using parts of his basic methodology on a simpler planar robot model.
### Methods:
* PD Control
* Local Jacobian update optimization
### Results

## Online Learning and Control using Sparse Local Gaussian Processes for Teleoperation
### Description:
This project is a work-in-progress for my MS Thesis work in the ARClab at UC San Diego. This work aims to achieve the goal of online model-learning and control for a teleoperation task by using Sparse Online Local Gaussian Process Regression (SOLGPR) to infer a local function mapping of robot sensor states to joint states and perform a prediction of the teleoperation command for joint control. In this iteration (not most recent), local Gaussian process models are learned and sparsified via Variational Inference with user-tuned bounds on model size and complexity. An optimization scheme involving periodic optimization of a drifting Gaussian process helps to reduce computation time in conjunction with the sparse local models. This framework provides a basis for a tradeoff between model complexity and performance.   

### Methods:
* Gaussian Process Regression
* Local GP Partitioning
* Drifting GP
* Variational Inference
* ROS platform

### Results

## Orientation Tracking and Panoramic Image Stitching with IMU 
### Description: 
In this project, we use an unscented Kalman filter to track the orientation of a rotating camera. A panorama is generated using these filtered 3-D orientation states by stitching together rotated images.

### Methods:
* Quaternion transformations and averaging
* Unscented Kalman Filter (UKF)
* Panoramic Image Stitching
### Results
![o2](https://user-images.githubusercontent.com/22353511/35855249-81f33e48-0ae7-11e8-8b69-2ac742751644.png)
![a2](https://user-images.githubusercontent.com/22353511/35855258-876ac01c-0ae7-11e8-9fa7-a1fe9060eb92.png)
![p2](https://user-images.githubusercontent.com/22353511/35855273-92235cd0-0ae7-11e8-9552-3675821315ac.png)

## Color Segmentation and Barrel Detection 
### Description:
In this project, a multivariate Gaussian model is trained to classify the pixels of images containing a red barrel into several color
classes. The red barrels are detected by grouping the regions of the barrel’s red labeled pixels into bounded boxes and determining whether these boxes satisfy a ”barrellness” threshold. The distance to the barrel from the camera was learned by training a linear regressor on the training data of known distances and the width and height of the detected barrels. This method was evaluated on a validation and test set.
### Methods:
* Multivariate Gaussian Classification
* OpenCV Bounded-Box detection
* Linear Regression

### Results

## SLAM and Texture Mapping of mobile robot
### Description:
In this project, we use grid-based SLAM with particle filters to predict and update the state of the robot and an occupancy grid of the environment map. Observations from a lidar senso, odometry information, and configurations of the lidar relative to the robot center of mass are given. Given localized robot poses and updated grid map from SLAM, RGB-D camera images are used to generate a color texture map of the ground plane in the grid map. 
### Methods:
* Particle Filter
* 2D Occupancy Grid
* SLAM
* Stratified Resampling
* RGB-D Texture Mapping
### Results

## Kinematic and Dynamic Simulation of simple 3 DOF Robot Arm
### Description:
In this project, kinematic and dynamic models are built and used to simulate a trajectory profile, compensate for gravity, and track control to a reference position 
### Methods:
* Forward/inverse kinematics
* Forward/Inverse dynamics
* P-control
### Results
![q1traj](https://user-images.githubusercontent.com/22353511/35854721-f33f3e5a-0ae5-11e8-9515-e5c91194c8ff.gif)
![q2f_rect](https://user-images.githubusercontent.com/22353511/35854737-fd6300ba-0ae5-11e8-9820-d4ca1dcd4fbf.gif)

## 2D Planar RRT motion planner
### Description:
Given a 2 dof planar robot arm model and physical obstacles in a task space, this project entailed creating an RRT motion planner with collision detection in the robot's c-space. The final trajectory was smoothed with a spline. 
### Methods:
* Configuration-space collision detection
* Rapidly exploring random trees (RRT)
* Spline trajectory smoothing
### Results
![0229](https://user-images.githubusercontent.com/22353511/35854551-794796b0-0ae5-11e8-8e86-b1e462c8c1f5.png)
![ezgif com-optimize](https://user-images.githubusercontent.com/22353511/35854425-2e981e5a-0ae5-11e8-8bd4-ab2d64d3d92f.gif)

## Support Vector Machines
### Description:
The objective of this project was to review the Support Vector Machine algorithm as a convex optimization problem and show how its dual formulation solves for the optimal decision boundary. The use of soft-margin version and the kernel trick are shown to form a strong dual form and their strengths are verified through an algorithm in MATLAB to classify datasets.
### Methods:
* SVM
* Hard-Margin
* Soft-Margin
* Kernel Trick
### Results
![soft1](https://user-images.githubusercontent.com/22353511/35854595-9d7c29b0-0ae5-11e8-9f9c-51cdcba0ca27.png)
![rbf1](https://user-images.githubusercontent.com/22353511/35854607-a597fc6e-0ae5-11e8-88f2-becebada522b.png)
![poly](https://user-images.githubusercontent.com/22353511/35854621-ade5bf3c-0ae5-11e8-8219-b763056726c8.png)

## Pixel Classification via EM for Gaussian Mixtures 
### Description:
In this work, a cheetah image was classified into foreground and background via Gaussian mixtures trained with Expectation maximization (EM). Different combinations of randomly initialized mixtures are compared as well as the dimension of the features (1 to 64) and number of mixtures (1 to 32). 
### Methods:
* Multivariate Gaussian Mixtures
* Expectation Maximization
### Results

## Principal Component Analysis vs Linear Discriminant Analysis for Face Recognition
### Description:
In this work, a 
### Methods:
* PCA by SVD
* Linear Discriminant Analysis (LDA)
* Regularized Discriminant Analysis (RDA)
* PCA + LDA
### Results
![5a](https://user-images.githubusercontent.com/22353511/35854890-81db4a3c-0ae6-11e8-8e1e-cddd1fed35d0.jpg)
![5b](https://user-images.githubusercontent.com/22353511/35854909-8c3735c2-0ae6-11e8-9648-85bbc3291fae.jpg)

PCA Results: 33.33% error;
LDA Results: 18.33% error;
PCA + LDA Results: 30% error
## Multi-Layer Perceptron for MNIST digit classification
### Description:
In this pair project, we built (from scratch) a small neural network to classify handwritten digits, obtained from the MNIST  database. We experimented with 1 and 2 hidden layers between the inputs (785 image pixels) and the outputs (10 classication probabilities) -  the hidden layers used hyperbolic tangent and sigmoid activation functions, while the output layer used softmax activation to discern classes. To increase speed of convergence, we employed some standard techniques such as momentum, stochastic gradient descent, and preprocessing on input data. 
### Methods:
*	N-layer multi-player perceptron
*	Stochastic gradient descent 
*	momentum
*	annealing
*	hyperbolic tangent sigmoid
* l1/l2 regulatization

### Results
We observed that with momentum, stochastic descent, and two relatively small hidden layers,
we managed to achieve a classification accuracy of 95% on the test dataset.

## Convolutional Neural Network Transfer Learning
### Description:
This group project in a Neural Networks course was focused on doing Transfer Learning with VGG16. We utilized Keras which is a Deep Learning Library which includes the VGG16 ConvNet. VGG16 was trained on ImageNet, we worked with the CalTech256 and UrbanTibes dataset. To perform the transfer learning, we replaced the Softmax Layer of the VGG16 pre-trained model by our own Softmax Layer which will predict classes of our datasets. After replacing, we attempted to train it and observe its performance. Lastly, we explored the use of a temperature-based softmax regression on the last output layer of the VGG16 model as input to a softmax layer for the Caltech256.
### Methods:
* Deep Learning CNN on Keras Library
* Transfer Learning
* Temperature-based Softmax Regression 
### Results

## Character Level Recurrent Neural Network for music generation
### Description:
For this project, we explored recurrent neural networks. This was done through training a basic RNN model using characters extracted from a music dataset that was provided in ABC format. Varying hidden units, temperature-based softmax regression, and dropout regularization were methods used to improve validation loss. After training, we ran the network in generative mode in order to "compose" music. 

### Methods:
* Deep Learning RNN on Keras Library
* Dropout regularization
* Temperature-based Softmax Regression 
### Results

## Bidirectional LSTM RNN for Metrical Analysis of Poetry
### Description:
In this project, we used a biLSTM  recurrent neural network to perform character-level supervised learning on English metrical poetry. Scansion is the process of parsing out the stressed and unstressed syllables in each line. Using For Better For Verse, a project by the University of Virginia’s Department of English, we obtained a training dataset in the form of English language poems together with their metrical scansion. After formatting the syllabication into a character-level form, we trained 64 poems and validated the network on 16 poems. 
### Methods:
* BiDirectional LSTM RNN
* Dropout regularization
* L2 regularization
### Results




