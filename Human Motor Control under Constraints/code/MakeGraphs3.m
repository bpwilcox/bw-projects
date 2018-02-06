close all
clear all

ts = -inf;
te = inf;

h1 = openfig('9_5_AvgNForceRev.fig','reuse'); % visual
ax1 = gca; % get handle to axes of figure
h2 = openfig('9_3_AvgNForceRev.fig','reuse'); % blind
ax2 = gca;
h3 = openfig('10_5_AvgNForceRev.fig','reuse'); % visiual
ax3 = gca; % get handle to axes of figure
h4 = openfig('10_3_AvgNForceRev.fig','reuse'); % blind
ax4 = gca;

h3 = figure; %create new figure

s1 = subplot(2,2,1); %create and get handle to the subplot axes
axis([ts,te,-inf,inf])
ylabel('Force (N)')
title('I,Pref w/ visual, CW')


s2 = subplot(2,2,3);
title('I,Pref w/o visual, CW')
ylabel('Force (N)')
xlabel('Position (rev)')
axis([ts,te,-inf,inf])

s3 = subplot(2,2,2); %create and get handle to the subplot axes
axis([ts,te,-inf,inf])
title('J,Pref w/visual, CCW')

s4 = subplot(2,2,4); %create and get handle to the subplot axes
xlabel('Position (rev)')
axis([ts,te,-inf,inf])
title('J,Pref w/o visual, CCW')




fig1 = get(ax1,'children'); %get handle to all the children in the figure
fig2 = get(ax2,'children');
fig3 = get(ax3,'children'); %get handle to all the children in the figure
fig4 = get(ax4,'children');


copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes
copyobj(fig2,s2);
copyobj(fig3,s3); %copy children to new parent axes i.e. the subplot axes
copyobj(fig4,s4);

