clc;clear all

itf=c3dserver;              %COM object variable 'itf' is now loaded
file=input('File name of c3d data:','s');

openc3d(itf,0,file);

n_orig_frames=nframes(itf);     
n_param=itf.GetNumberParameters;        

%Searching LABEL parameters
i=0;
while(i<n_param)
     name=itf.GetParameterName(i);
     if(strcmp(name,'LABELS'))
         n_label=i;
         i=n_param;
     end
     i=i+1;
end

%Capturing labels
n_points=itf.GetNumber3DPoints();
labels=[];
for i=0:(n_points-1)
    name=itf.GetParameterValue(n_label,i);
    labels=strvcat(labels, name);
end

aux=sprintf('%d markers captured, with %d points each one.',n_points,n_orig_frames);
disp(aux);
disp('Labels:');
disp(labels);

% Obtaining data

orig_capture=[];
for i=1:(n_points)
    orig_capture=[orig_capture get3dtarget(itf,labels(i,:))];
end

closec3d(itf);

% No frames are deleted

ini_frame=1;

n_frames=n_orig_frames-(ini_frame-1);
capture=orig_capture(ini_frame:n_orig_frames,:);

%%
% Frame base

Ts=1/100;  % 100 fps
T=[0:Ts:((n_frames-1)*Ts)];


%% Read initial real markers

i=1;
j=1;
for i=1:n_points;
    if isnan(capture(1,3*i));
    else
        markers(1,(3*j-2):3*j)=capture(1,(3*i-2):3*i);
        j=j+1;
    end
end
n_markers=length(markers)/3;
new_points=markers;

velocities=zeros(1,n_markers*3);
maxdist=35;
%% Organize data. Take all data for each initial marker.
for frame=2:n_frames 
    j=1;
     for i=1:n_points
         if isnan(capture(frame,3*i))
         else
             m(1,(3*j-2):3*j)=capture(frame,(3*i-2):3*i);
             j=j+1;
         end
         i=i+1;
     end
     n_current_markers=length(m)/3;
     
     estimated_marker=new_points(frame-1,:)+velocities*Ts;
     
     %%  Compare when n_current_markers==n_markers
     if n_current_markers==n_markers;
         for i=1:n_current_markers
             distances(i)=dist(m(1,(3*i-2):3*i),new_points(frame-1,(3*i-2):3*i)');
             distances2(i)=dist(m(1,(3*i-2):3*i),estimated_marker(1,(3*i-2):3*i)');
         end
         if (max(distances)<maxdist)&(max(distances2)<maxdist) %When markers and current markers are the same
             new_points(frame,:)=m;
         else
             for i=1:n_markers
                 if(distances(i)<maxdist)&(distances2(i)<maxdist) %When not all markers and current markers are the same
                     new_points(frame,(3*i-2):3*i)=m(1,(3*i-2):3*i);
                 else
                     for j=1:n_current_markers
                         disonevsall(j)=dist(new_points(frame-1,(3*i-2):3*i),m(1,(3*j-2):3*j)');
                         dis2onevsall(j)=dist(estimated_marker(1,(3*i-2):3*i),m(1,(3*j-2):3*j)');
                         sumdis(j)=sqrt(0*disonevsall(j)^2+dis2onevsall(j)^2);
                     end
                     [mindis,Idis]=min(disonevsall);
                     [mindis2,Idis2]=min(dis2onevsall);
                     if Idis==Idis2 %When a marker with min estimated distance and min distance from the last frame, this new frame is added
                         new_points(frame,(3*i-2):3*i)=m(1,(3*Idis-2):3*Idis);
                         found=true;
                     else
                         [minsumdis,Isumdis]=min(sumdis);
                         if minsumdis<maxdist*sqrt(2)
                             new_points(frame,(3*i-2):3*i)=m(1,(3*Isumdis-2):3*Isumdis);
                             found=true;
                         else
                         end                         
                     end
                     if found==false;
                         sprintf('marker %d not found at frame %d', i,frame)
                     end
                 end
             end
         end
     end
         
     
     found=false;
     %% Compare when n_current_markers>=n_markers;
     if n_current_markers>n_markers;
         for i=1:n_markers
             for j=1:n_current_markers 
                 disonevsall(j)=dist(new_points(frame-1,(3*i-2):3*i),m(1,(3*j-2):3*j)');
                 dis2onevsall(j)=dist(estimated_marker(1,(3*i-2):3*i),m(1,(3*j-2):3*j)');
                 sumdis(j)=sqrt(0*disonevsall(j)^2+dis2onevsall(j)^2);
             end
             [mindis,Idis]=min(disonevsall);
             [mindis2,Idis2]=min(dis2onevsall);
             if Idis==Idis2 %When a marker with min estimated distance and min distance from the last frame, this new frame is added
                 new_points(frame,(3*i-2):3*i)=m(1,(3*Idis-2):3*Idis);
                 found=true;
             else
                 [minsumdis,Isumdis]=min(sumdis);
                 if minsumdis<maxdist*sqrt(2)
                     new_points(frame,(3*i-2):3*i)=m(1,(3*Isumdis-2):3*Isumdis);
                     found=true;
                 else
                 end
             end
             if found==false;
                sprintf('marker %d not found at frame %d', i,frame)
             end
         end
     end
     
     
     velocities=(new_points(frame,:)-new_points(frame-1,:))/Ts;
     clear distances distances2 disonevsall dis2onevsall m Isumdis Idis Idis2 sumdis minsumdis
frame
end  

%% Plot 3D Data

a=figure();
h=newplot();
set(h,'NextPlot','replacechildren ');
axis([-2000 2000 -3500 3500 0 2000])
title('3D Animation');
view([-20  45])
grid on;

for i1=1:2:n_frames
    
    h=newplot();
    set(h,'NextPlot','replacechildren ');

    h=newplot();
    set(h,'NextPlot','add');
    
    % Completed data

    for i2=1:n_markers
        x=new_points(i1,i2*3-2);    
        y=new_points(i1,i2*3-1);    
        z=new_points(i1,i2*3);    
        plot3(x,y,z,'.','MarkerEdgeColor','blue','MarkerSize',12);       
    end

    drawnow;
end

% Position-Identification Markers
figure(a);
a=figure();

% Initial pose

i1=1;
subplot(1,2,1);
h=newplot();
set(h,'NextPlot','replacechildren ');
axis([-2000 2000 -3500 3500 0 2000])
title('Initial pose markers');
view([-16  21])
grid off;
h=newplot();
set(h,'NextPlot','add');
grid;

% Complete data

for i2=1:n_markers
    x=new_points(i1,i2*3-2);    
    y=new_points(i1,i2*3-1);    
    z=new_points(i1,i2*3);   
    plot3(x,y,z,'.','MarkerEdgeColor','blue','MarkerSize',5);    
    text(double(x),double(y),double(z),sprintf('%d%',i2));
end
drawnow;

% Final pose

i1=n_frames;
subplot(1,2,2);
h=newplot();
set(h,'NextPlot','replacechildren ');
drawnow;
axis([-2000 2000 -3500 3500 0 2000])
title('Final pose markers');
view([-16  21])
grid off;
h=newplot();
set(h,'NextPlot','add');

%Complete data

for i2=1:n_markers
    x=new_points(i1,i2*3-2);    
    y=new_points(i1,i2*3-1);    
    z=new_points(i1,i2*3);  
    plot3(x,y,z,'.','MarkerEdgeColor','blue','MarkerSize',5);    
    text(double(x),double(y),double(z),sprintf('%d%',i2));
end

drawnow;
figure(a);

coinc=0;
for i=1:n_markers
    for j=(i+1):(n_markers-1)
        if (new_points(end,i*3))==(new_points(end,j*3))
            coinc=coinc+1;
        else
        end
    end
end

sprintf('There are %d trajectories in %d markers',n_markers-coinc,n_markers)

%% File to run Main_Bcn
datos=new_points;
save(file,'T','Ts','n_orig_frames','n_frames','n_points','orig_capture','labels','datos')