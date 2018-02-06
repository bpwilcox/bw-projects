function [D,G,C] = dyneq(th1,th2,th3)

% Angles
q1 = sym('q1');
q2 = sym('q2');
q3 = sym('q3');
q = [q1;q2;q3];

% Lengths
l1 = sym(0);
l2 = sym('l2');
l3 = sym('l3');
l = [l1;l2;l3];

% Masses
m1 = sym(0);
m2 = sym('m2');
m3 = sym('m3');
m = [m1;m2;m3];

% Radii
r1 = sym('r1');
r2 = sym('r2');
r3 = sym('r3');

% Gravity
g = sym('g');

I1 = sym(zeros(3,3)); % link inertia
I2 = [sym((1/12))*m2*(3*r2^2+l2^2) 0 0;0 sym((1/12))*m2*(3*r2^2+l2^2) 0;0 0 sym((1/2))*m2*r2^2];
I3 = [(1/12)*m3*(3*r3^2+l3^2) 0 0;0 (1/12)*m3*(3*r3^2+l3^2) 0;0 0 (1/2)*m3*r3^2];
% I3 = I2;
I(:,:,1) = I1;
I(:,:,2) = I2;
I(:,:,3) = I3;

%Rotations
R_01 = [cos(q1) -sin(q1) 0;sin(q1) cos(q1) 0;0 0 1];
R_12 = [cos(q2) -sin(q2) 0;sin(q2) cos(q2) 0;0 0 1];
R_X = [sym(1) sym(0) sym(0);0 cos(-pi/sym(2)) -sin(-pi/sym(2));sym(0) sin(-pi/sym(2)) cos(-pi/sym(2))];
R_23 = [cos(q3) -sin(q3) 0;sin(q3) cos(q3) 0;0 0 1];

% joint locations
p0 = [sym(0); sym(0); sym(0)];
% p1 = [sym(0); sym(0); l1];
p1 = [l1; sym(0); sym(0)];
p2 = [l2; sym(0); sym(0)];
p3 = [l3; sym(0); sym(0)];
b = [sym(0) sym(0) sym(0) sym(1)];


% Relative Center of mass locations
p1c = [l1/2; sym(0); sym(0)];
p2c = [l2/2; sym(0); sym(0)];
p3c = [l3/2; sym(0); sym(0)];

% Homogeneous matrices (for joint locations % end effector)
H_01 = [R_01 p0;b];
H_X = [R_X p0;b];
H_12 = [R_12 p1;b];
H_23 = [R_23 p2;b];
H_e = [eye(3) p3;b];

% Homogeneous matrices for centroid location
H_23c = [R_23 p2c;b];
H_ec = [eye(3) p3c;b];

%world frame position vector and homogeneous matrix for end effector
psym = H_01*H_X*H_12*H_23*[p3;1];
psym = simplify(psym);

Hsym = H_01*H_X*H_12*H_23*H_e;
Hsym = simplify(Hsym);

%world frame position and homogeneous matrix for centroids
psym1c = H_01*[p1c;1];

psym2c = H_01*H_X*H_12*[p2c;1];
psym2c = simplify(psym2c);
Hsym2c = H_01*H_X*H_12*H_23c;
Hsym2c = simplify(Hsym2c);


psym3c = H_01*H_X*H_12*H_23*[p3c;1];
psym3c = simplify(psym3c);
Hsym3c = H_01*H_X*H_12*H_23*H_ec;
Hsym3c = simplify(Hsym3c);


%Jacobian Jv
Jv1 = jacobian(psym1c(1:3),[q1 q2 q3]);
Jv2 = jacobian(psym2c(1:3),[q1 q2 q3]);
Jv3 = jacobian(psym3c(1:3),[q1 q2 q3]);

J = jacobian(psym(1:3),[q1 q2 q3]);

Jv(:,:,1) = Jv1;
Jv(:,:,2) = Jv2;
Jv(:,:,3) = Jv3;

Jv = simplify(Jv);

%Rotations R

%Jacobian Jw
dq1 = sym('dq1');
dq2 = sym('dq2');
dq3 = sym('dq3');

dq = [dq1;dq2;dq3];
k = [sym(0);sym(0);sym(1)];
% R_00 = sym(eye(3));
R(:,:,1) = R_01;
R(:,:,2) = R_01*R_X*R_12;
R(:,:,3) = R_01*R_X*R_12*R_23;


w = sym(zeros(3,1));
Jww = sym(zeros(3,3));
for i = 1:3
    
    w = w+dq(i)*R(:,:,i)*k;
    
    Jww(:,i) = R(:,:,i)*k;
    Jw(:,:,i) = Jww;
end

% Inertia Matrix

rp = psym(1:3);
mp = sym('mp');

D= sym(zeros(3,3));
for j = 1:3
    
    D = D + (m(j)*Jv(:,:,j).'*Jv(:,:,j)+Jw(:,:,j).'*R(:,:,j)*I(:,:,j)*R(:,:,j).'*Jw(:,:,j));

end
Drob = simplify(D);

Ip = mp*(rp.'*rp*sym(eye(3))-rp*rp.');
Ipp = mp*J.'*J;
Dload = simplify(Ipp);

D = simplify(Drob+Dload);

% Gravity Terms 

% rc = [psym1c(1:3) psym2c(1:3) psym3c(1:3)];
rc = [psym1c(1:3) psym2c(1:3) psym3c(1:3)];

P = 0;
for i = 1:3
    P = P+m(i)*[0 0 g]*rc(:,i);
end

Pp = mp*[0 0 g]*rp;
Gload = gradient(Pp,[q1 q2 q3]);
Grob = gradient(P,[q1 q2 q3]);

G = simplify(Grob+Gload);



% Coriolis/Centrifugal Terms
qd1 = sym('qd1');
qd2 = sym('qd2');
qd3 = sym('qd3');

qd = [qd1 qd2 qd3];

Crob = sym(zeros(3,3));
Cload = sym(zeros(3,3));
h = sym(zeros(3,1));
hp = sym(zeros(3,1));

for i = 1:3
    for j=1:3
        for k=1:3
            
%             c = gradient(D(i,j),q(k))-sym(1/2)*gradient(D(j,k),q(i));
            c = sym(1/2)*(gradient(Drob(i,j),q(k))+gradient(Drob(i,k),q(j))-gradient(Drob(j,k),q(i)));
%             h(i)= h(i)+ c*qd(j)*qd(k);           
            Crob(i,j) = Crob(i,j)+ c*qd(k);
            
            cp = sym(1/2)*(gradient(Dload(i,j),q(k))+gradient(Dload(i,k),q(j))-gradient(Dload(j,k),q(i)));
            Cload(i,j) = Cload(i,j)+ cp*qd(k);
        end
    end
end

% Cload;
C = simplify(Crob+Cload);
end

