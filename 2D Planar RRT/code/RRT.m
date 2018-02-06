addpath GJK2D
addpath rvctools

startup_rvc

close all
clear all
%% Waypoints
W1 = [0 20];
W2 = [0 -20];
W3 = [-19.43 4.62];
W4 = [2,2];
W5 = [-8 0];
W6 = [-5 -5];
W7 = [-9 0];

W = [W1;W2;W3;W4;W5;W6;W7];

%% Convert to joint angles

l1 = 10;
l2 = 10;

a = sqrt(1-((W(:,1).^2+W(:,2).^2-l1^2-l2^2)/(2*l1*l2)).^2);
b = (W(:,1).^2+W(:,2).^2-l1^2-l2^2)/(2*l1*l2);

Q2 = atan2(a,b);

Q1 = atan2(W(:,2),W(:,1))-atan2(l2*sin(Q2),l1+l2*cos(Q2));


Q =[Q1 Q2];
Q = wrapTo2Pi(Q);

%% RRT
a = 30;
b = 1;
c = 35;
d = 5;
e = 11;
f = 28;

numLinks = 2;
L = repmat(Link('d', 0, 'a', 10, 'alpha', 0, 'm', .001, 'r', [-0.5, 0, 0]), numLinks, 1);
R = SerialLink(L);
R.base = trotx(pi/2)*R.base;
w=1;

o1 = [e,0;e+b,0;e+b,c;e,c];
o2 = [-(e+b),d;-e,d;-e,c;-(e+b),c];
o3 = [-(e+b),-c;-e,-c;-e,0;-(e+b),0];
o4 = [e,-c;e+b,-c;e+b,-d;e,-d];

obs{1} = o1;
obs{2} = o2;
obs{3} = o3;
obs{4} = o4;

dq = 0.1;


K = 300;
check = 0;
Goalprob = 0.3;
isgoal = 0;
i =2;

start =  3;
goal = 2;

G{1,1} = Q(start,:);
G{1,2} = Q(start,:);



while(isgoal==0)
    
    bias = rand(1);
    if bias < Goalprob
        qrand = Q(goal,:);
        
    else
        while(check==0)
            qrand = 2*pi*rand(1,2);
            P = generateArmPolygons(R, qrand, w);
            check = gjk2Darray(P,obs);
        end
    end
    for j = 1:size(G,1)
        qnorm = norm(G{j,1}-qrand);
        if (j==1) || (qnorm < minqnorm)
            minqnorm = qnorm;
            near = j;
            qnear = G{j,1};
        end
    end
    
    if bias > Goalprob
        [check,qnew] = EdgeCollision2(0.3,qnear,qrand,R,w,obs);
    else
        [check,qnew] = EdgeCollision(dq,qnear,qrand,R,w,obs);
    end
    if ~isequal(qnew,qnear)
        
        G{i,1} = qnew;
        G{i,2} = qnear;
        i = i+1;
    end
    
    if isequal(round(qnew,8),round(Q(goal,:),8))
        isgoal=1
        i
    end
    
    check = 0;
  
end

%%
% h1= figure(1)

h1 = openfig('Cspace.fig');
subplot(1,2,1,gca)
axis([0 2*pi 0 2*pi])
hold on
for k = 1:size(G,1)
    
    P1 =[G{k,2}(1);G{k,1}(1)];
    P2 =[G{k,2}(2);G{k,1}(2)];
    
    plot(P1,P2,'r-o')
    
end

%% Find Path

for n = 1:size(G,1)
    Parent(n,:) = G{n,2};
    Child(n,:) = G{n,1};
end


Gpath{1,1} = Child(end,:);
Gpath{1,2} = Parent(end,:);


m = size(Parent,1);
r = 2;
isroot = 0;
while(isroot ==0)
    
    ff = find(ismember(Child,Parent(m,:),'rows'));
    next = max(ff);
    
    Gpath{r,1} = Parent(m,:);
    Gpath{r,2} = Parent(next,:);
      
   
    isroot = isequal(Gpath{r,2},Q(start,:));
    
    
    m = next;
    
    r=r+1;
    
    
end
%%

for k = 1:size(Gpath,1)
    
    P1 =[Gpath{k,2}(1);Gpath{k,1}(1)];
    P2 =[Gpath{k,2}(2);Gpath{k,1}(2)];
    

    plot(P1,P2,'g-o')
    Path(k,:) = [P1(2),P2(2)];
end
%%
Path = [Path;P1(1) P2(1)];
Pathsmooth = [];
for t = 1:length(Path)-1
    
qq = linspace(Path(t,1),Path(t+1,1),10)';

s = spline(Path(t:t+1,1),Path(t:t+1,2),qq);

Pathsmooth = [Pathsmooth;qq s];

end

plot(Pathsmooth(:,1),Pathsmooth(:,2),'k-')

%%
plot([Q(start,1);Q(goal,1)],[Q(start,2);Q(goal,2)],'b+')

%% Plot robot


% h2 = figure(2)
subplot(1,2,2)
time_delay = 0.05;
axLim = [-(e+b+f) (e+b+f) -10 10 -(c) c];
R.plotopt = {'view', 'x', 'noshading', 'noname', 'ortho', ...
    'workspace', axLim, 'tile1color', [1,1,1], 'delay', time_delay, 'trail', '',...
    'noshadow', 'nobase', 'nowrist', ...
    'linkcolor', 'b', 'toolcolor', 'b', ...
    'jointcolor', 0.2*[1 1 1], 'jointdiam', 2,'scale', 0.5};
axis(axLim); axis square; hold on;

for i = 1:length(obs)
    obs{i} = cat(1, obs{i}, obs{i}(1,:));
    fill3(obs{i}(:,1), ones(size(obs{i}(:,1))), obs{i}(:,2), 0.8*[1 1 1], 'facealpha', 1)
end

R.plot(flip(Pathsmooth))
% R.plot(flip(Pathsmooth),'movie','Path6')



