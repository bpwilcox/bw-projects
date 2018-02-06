% close all
% clear all
% fig = openfig('7_8_RawVelTime.fig')
% subplot(2,1,1)


ts = -inf;
te = inf;

h1 = openfig('7_7_RawVelTime.fig','reuse'); % slow cw
ax1 = gca; % get handle to axes of figure
h2 = openfig('7_9_RawVelTime.fig','reuse');
ax2 = gca;
h3 = openfig('7_18_RawVelTime.fig','reuse'); % med cw
ax3 = gca; % get handle to axes of figure
h4 = openfig('7_16_RawVelTime.fig','reuse');
ax4 = gca;
h5 = openfig('7_14_RawVelTime.fig','reuse'); % open figure
ax5 = gca; % get handle to axes of figure
h6 = openfig('7_12_RawVelTime.fig','reuse');
ax6 = gca;

% test1.fig and test2.fig are the names of the figure files which you would % like to copy into multiple subplots
h3 = figure; %create new figure

s1 = subplot(2,3,1); %create and get handle to the subplot axes
axis([ts,te,-inf,inf])
ylabel('Velocity (m/s)')
title('G, Slow, CW')


s2 = subplot(2,3,4);
title('G, Slow, CCW')
ylabel('Velocity (m/s')
xlabel('Time (s)')
axis([ts,te,-inf,inf])

s3 = subplot(2,3,2); %create and get handle to the subplot axes
axis([ts,te,-inf,inf])
title('G, Med, CW')

s4 = subplot(2,3,5); %create and get handle to the subplot axes
xlabel('Position (rev)')
axis([ts,te,-inf,inf])
title('G, Med, CCW')

s5 = subplot(2,3,3); %create and get handle to the subplot axes
axis([ts,te,-inf,inf])
title('G, Fast, CW')

s6 = subplot(2,3,6); %create and get handle to the subplot axes
xlabel('Position (rev)')
axis([ts,te,-inf,inf])
title('G, Fast, CCW')


fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children'); %get handle to all the children in the figure
fig4 = get(ax4,'children');
fig5 = get(ax5,'children'); %get handle to all the children in the figure
fig6 = get(ax6,'children');

copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3); %copy children to new parent axes i.e. the subplot axes
copyobj(fig4,s4);
copyobj(fig5,s5); %copy children to new parent axes i.e. the subplot axes
copyobj(fig6,s6);
