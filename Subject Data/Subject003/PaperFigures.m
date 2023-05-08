
clear; clc; close all
load Subject003fixationFilterM.mat

vs = -.1;

figure
fig = gcf;
fig.Color = 'w';
ax = gca;
plot(vs*EyeHandFeedback.HandX - vs*604.8285, vs*EyeHandFeedback.HandY - vs*455.6125,'--','LineWidth',1.5)
hold on
plot(vs*EyeHandFeedback.HandX(handOnsetIndices_EHF) - vs*604.8285,vs*EyeHandFeedback.HandY(handOnsetIndices_EHF) - vs*455.6125,'rx','MarkerSize',14,'LineWidth',2)

h(1) = drawCircle(vs*604.8285 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100);
h(2) = drawCircle(vs*362.8971 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100);
h(3) = drawCircle(vs*483.8628 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100);
h(4) = drawCircle(vs*725.7942 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100);
h(5) = drawCircle(vs*846.7599 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100);
h(6) = drawCircle(vs*604.8285 - vs*604.8285, vs*325.4375 - vs*455.6125, 0, vs*25, 100);
h(7) = drawCircle(vs*604.8285 - vs*604.8285, vs*195.2625 - vs*455.6125, 0, vs*25, 100);

ax.FontSize = 24;
legend('Raw Hand Data','End of Hand Movements','Targets')

axis([-30 30 -5 30])
% axis('equal')
xlabel('x-direction (cm)')
ylabel('y-direction (cm)')

figure
fig = gcf;
fig.Color = 'w';
ax = gca;
plot(vs*EyeHandFeedback.EyeX - vs*604.8285, vs*EyeHandFeedback.EyeY - vs*455.6125,'r','LineWidth',1.5)
hold on
plot(vs*fixations_EHF(:,1) - vs*604.8285, vs*fixations_EHF(:,2) - vs*455.6125,'x','MarkerSize',14,'LineWidth',2)

h(1) = drawCircle(vs*604.8285 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100);
h(2) = drawCircle(vs*362.8971 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100);
h(3) = drawCircle(vs*483.8628 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100);
h(4) = drawCircle(vs*725.7942 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100);
h(5) = drawCircle(vs*846.7599 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100);
h(6) = drawCircle(vs*604.8285 - vs*604.8285, vs*325.4375 - vs*455.6125, 0, vs*25, 100);
h(7) = drawCircle(vs*604.8285 - vs*604.8285, vs*195.2625 - vs*455.6125, 0, vs*25, 100);

ax.FontSize = 24;
legend('Raw Eye Data','Estimated Fixations','Targets')

axis([-30 30 -5 30])
% axis('equal')
xlabel('x-direction (cm)')
ylabel('y-direction (cm)')