
clear; clc; close all
load Subject005fixationFilterM.mat

vs = -.1;

startTrial = 10;
endTrial = 90;
framesPerTrial = 373.2;

% figure('Position', [10 10 500 500])
figure
fig = gcf;
fig.Color = 'w';
ax = gca;
plot(vs*EyeHandFeedback.HandX(startTrial*framesPerTrial:endTrial*framesPerTrial) - vs*604.8285, vs*EyeHandFeedback.HandY(startTrial*framesPerTrial:endTrial*framesPerTrial) - vs*455.6125,'--','LineWidth',1.5)
%set(gca, 'YDir','reverse')
hold on
plot(vs*EyeHandFeedback.HandX(handOnsetIndices_EHF(startTrial:endTrial)) - vs*604.8285,vs*EyeHandFeedback.HandY(handOnsetIndices_EHF(startTrial:endTrial)) - vs*455.6125,'rx','MarkerSize',16,'LineWidth',2)
ax.FontSize = 28;

h(1) = drawCircle(vs*604.8285 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100, 'k');
h(2) = drawCircle(vs*362.8971 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100, 'k');
h(3) = drawCircle(vs*483.8628 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100, 'k');
h(4) = drawCircle(vs*725.7942 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100, 'k');
h(5) = drawCircle(vs*846.7599 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100, 'k');
h(6) = drawCircle(vs*604.8285 - vs*604.8285, vs*325.4375 - vs*455.6125, 0, vs*25, 100, 'k');
h(7) = drawCircle(vs*604.8285 - vs*604.8285, vs*195.2625 - vs*455.6125, 0, vs*25, 100, 'k');

h(1).Color = [.3 1 .3];
h(1).LineWidth = 3;

legend('Raw Hand Data','Hand Endpoints','Starting Target','Task Targets')

axis([-30 30 -5 30])
% axis('equal')
xlabel('x-direction (cm)')
ylabel('y-direction (cm)')

% figure('Position', [10 10 500 500])
figure
fig = gcf;
fig.Color = 'w';
ax = gca;
plot(vs*EyeHandFeedback.EyeX(startTrial*framesPerTrial:endTrial*framesPerTrial) - vs*604.8285, vs*EyeHandFeedback.EyeY(startTrial*framesPerTrial:endTrial*framesPerTrial) - vs*455.6125,'r','LineWidth',1.5)
hold on
plot(vs*fixations_EHF(startTrial:endTrial,1) - vs*604.8285, vs*fixations_EHF(startTrial:endTrial,2) - vs*455.6125,'x','MarkerSize',16,'MarkerEdgeColor',[0 0.4470 0.7410],'LineWidth',2)
ax.FontSize = 28;

h(1) = drawCircle(vs*604.8285 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100, 'k');
h(2) = drawCircle(vs*362.8971 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100, 'k');
h(3) = drawCircle(vs*483.8628 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100, 'k');
h(4) = drawCircle(vs*725.7942 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100, 'k');
h(5) = drawCircle(vs*846.7599 - vs*604.8285, vs*455.6125 - vs*455.6125, 0, vs*25, 100, 'k');
h(6) = drawCircle(vs*604.8285 - vs*604.8285, vs*325.4375 - vs*455.6125, 0, vs*25, 100, 'k');
h(7) = drawCircle(vs*604.8285 - vs*604.8285, vs*195.2625 - vs*455.6125, 0, vs*25, 100, 'k');

h(1).Color = [.3 1 .3];
h(1).LineWidth = 3;

legend('Raw Eye Data','Eye Fixations','Starting Target','Task Targets')

axis([-30 30 -5 30])
% axis('equal')
xlabel('x-direction (cm)')
ylabel('y-direction (cm)')