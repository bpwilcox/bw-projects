% clear all
% close all

set = 'a';
trial=3;
load(strcat('Take_',set,num2str(trial)));
ArmParameters;
% 
% [B,A]=butter(3,2/50);
% filt = filtfilt(B,A,Qc);

% h =0.01;

% x1dot=diff(filt(:,2))/h;
% y1dot=diff(filt(:,3))/h;
% x2dot=diff(filt(:,5))/h;
% y2dot=diff(filt(:,6))/h;
% 
% 
% x1ddot=diff(x1dot)/h;
% y1ddot=diff(y1dot)/h;
% x2ddot=diff(x2dot)/h;
% y2ddot=diff(y2dot)/h;

% Fx1=m1*Ac(:,2);
% Fy1=m1*Ac(:,3);
% Fx2=m2*Ac(:,5);
% % Fy2=m2*Ac(:,6);
% Tt1=I1*Ac(:,1);
% Tt2=I2*Ac(:,4);
% % 
% Fx1=m1*r1*cos(Qc(:,1))*Ac(:,1);
% Fy1=m1*r1*sin(Qc(:,4))*Ac(:,4);
% Fx2=m2*r2*cos(Qc(:,1)+Qc(:,4))*(Ac(:,1)+Ac(:,4));
% Fy2=m2*r2*sin(Qc(:,1)+Qc(:,4))*(Ac(:,1)+Ac(:,4)); 
% 
G2=(r2*m2*g*cos(Qc([3:end],4)+Qc([3:end],1)));
% % G1=r1*m1*g*cos(filt([1:802],1));
% % 
G1=(g*m1*r1*cos(Qc([3:end],1))+g*m2*(r2*cos(Qc([3:end],4)+Qc([3:end],1)) + l1*cos(Qc([3:end],1))));
% 
% M1 = -(l2-r2)*sin(Qc([1:802],4)+Qc([1:802],1))*m2.*Ac(:,5);
% M2 = (l2-r2)*cos(Qc([1:802],4)+Qc([1:802],1))*m2.*Ac(:,6);
% M3= -r2*sin(Qc([1:802],4)+Qc([1:802],1))*m1.*Ac(:,2);
% M4= r2*cos(Qc([1:802],4)+Qc([1:802],1))*m1.*Ac(:,3);
% 
% U2 = Tt2-(M1+M2+M3+M4+Tt1);
% 
% M5 = -(l1-r1)*sin(Qc([1:802],1))*m1.*Ac(:,2);
% M6 = (l1-r1)*cos(Qc([1:802],1))*m1.*Ac(:,3);
% M7= -r1*sin(Qc([1:802],1))*m1.*Ac(:,2);
% M8= r1*cos(Qc([1:802],1))*m1.*Ac(:,3);
% 
% U1= Tt1-(M5+M5+Tt2);
% % U2 = Tt2-(r2*Fx2.*sin(Qc([1:802],4)+Qc([1:802],1))+r2*Fy2.*cos(Qc([1:802],4)+Qc([1:802],1)) +G2);
% % U1= Tt1-(l1*Fx1.*cos(pi/2-Qc([1:802],1))+l1*Fy1.*cos(Qc([1:802],1))+G1) ;
% 
% Ut=[-U1 -U2];



T2 = Aq(:,1).*(I2+m2*l1*l2/2.*cos(Qc(3:end,4))+(m2*l2^2)/4) +Aq(:,4).*(I2+(m2*l2^2)/4)+m2*l1*l2.*Vq(2:end,1).^2.*sin(Qc(3:end,4))/2;
T1 = Aq(:,1).*(I1+I2+m2*l1*l2.*cos(Qc(3:end,4))+(m1*l1^2+m2*l2^2)/4 +m2*l1^2)+Aq(:,4).*(I2+m2*l2^2/4+m2*l1*l2/2.*cos(Qc(3:end,4)))-m2*l1*l2.*Vq(2:end,4).^2.*sin(Qc(3:end,4))/2-m2*l1*l2.*Vq(2:end,1).*Vq(2:end,4).*sin(Qc(3:end,4));


U= [T1+G1 T2+G2];
% U= [T1 T2];


