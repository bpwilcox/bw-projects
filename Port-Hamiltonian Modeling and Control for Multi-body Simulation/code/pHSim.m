clear all
close all;
% x=0.01:0.01:8.02;
%load parameters
ArmParameters;

%set initial values
% XI = zeros (4,1);
XI = zeros (6,1);
XI(1) =-1.344430711486921;
% XI(1) =0;
XI(2) = 0.016149512725076;
XI(3) = -0.012312568408850;
XI(4) = 0.005385809010703;
XI(5)=0;
XI(6)=0;


%set simulation length
TF =8;
dT= 10^-2;
% tspan = [0,TF];
tspan=0:dT:TF;

%solve ode
[T, X] = ode23s ('pHdiff', tspan, XI);


load('inputs');
error = [(X(:,1) - Qc(1:801,1)),X(:,3) - Qc(1:801,4)];

%Plot the angle responses for both angle(1) and angle(2)
subplot(2,2,1)
plot(T,X(:,1))
title('Angle 1 vs Time')
ylabel('angle (rad)')
xlabel ('time (s)')
hold on
plot(T, Qc(1:801,1))

subplot (2,2,2)
plot (T,X(:,3))
title('Angle 2 vs Time')
ylabel('angle ((rad)')
xlabel ('time (s)')
hold on
plot(T,Qc(1:801,4))

subplot(2,2,3)
plot(T,error(:,1))
title('Angle 1 Error vs Time')
ylabel('angle (rad)')
xlabel ('time (s)')


subplot (2,2,4)
plot (T,error(:,2))
title('Angle 2 Error vs Time')
ylabel('angle ((rad)')
xlabel ('time (s)')


%Now we want to calculate the energy for this model simulation
% 
% %constants 
% a1 = m1*r1^2 + m2*l1^2+I1;
% a2 = m2*r2^2+I2;
% b1 = m2*l1*r2;
% 
% %Define Energy vectors
% TotalEnergy = zeros(length(X),1);
% Potential = zeros(length(X),1);
% Kinetic = zeros(length(X),1);
% 
% %Because the Mass matrix depends on the states (angles), we need to
% %iterate it through every step
% for i=1:length(X)
% %Mass matrix from Paper interated every step. Remove comment to execute.
% %Mass = [a1+a2+2*b1*cos(X(i,3)), a2+b1*cos(X(i,3));a2+b1*cos(X(i,3)), a2]; 
% 
% %Mass matrix from model iterated every step
% a=-r1*sin(X(i,1));
% b = r1*cos(X(i,1));
% c = -(l1*sin(X(i,1))+r2*sin(X(i,1)+X(i,3)));
% d=-r2*sin(X(i,1)+X(i,3));
% e=(l1*cos(X(i,1))+r2*cos(X(i,1)+X(i,3)));
% f=r2*cos(X(i,1)+X(i,3));
% 
% R = [1 0;a 0;b 0;0 1;c d;e f];
% M = [I1 0 0 0 0 0;0 m1 0 0 0 0;0 0 m1 0 0 0;0 0 0 I2 0 0;0 0 0 0 m2 0;0 0 0 0 0 m2];
% Mnew = R.'*M*R;
% 
% %Calculate potential energy
% V1= m1*g*r1*sin(X(i,1));
% V2=m2*g*(l1*sin(X(i,1))+r2*sin(X(i,1)+X(i,3)));
% Potential(i) = V1+V2;
% 
% %Calculate kinetic energy. Change 'Mnew' to 'Mass' to calculate for Mass
% %matrix from paper.
% Kinetic(i) = 1/2*[X(i,2),X(i,4)]*inv(Mnew)*[X(i,2),X(i,4)].';
% 
% %Calculate total energy. Change 'Mnew' to 'Mass' to calculate for Mass
% %matrix from paper.
% TotalEnergy(i) = 1/2*[X(i,2),X(i,4)]*inv(Mnew)*[X(i,2),X(i,4)].'+V1+V2;
% 
% end
% 
% % %Plot Energy
% % subplot(2,2,3)
% % plot (T,TotalEnergy)
% % title('Total Energy (pH Model) vs Time')
% % ylabel('Energy ((J)')
% % xlabel ('time (s)')
% % %axis([0 2 0 5])
% 
% 
% 
% 
% 
