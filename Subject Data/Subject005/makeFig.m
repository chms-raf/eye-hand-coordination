% This code creates a figure for the paper

clear; clc; close all

load('Subject005fixationFilterM.mat')

ds = 239.14;
vs = 60.5;

figure
ax = gca;
fig = gcf;
fig.Color = 'w';
hold on
% plot(EyeHandFeedback.Time - ds, .1*EyeHandFeedback.TargetX - vs, 'Color', [0.9290, 0.6940, 0.1250], 'LineWidth', 3)
plot(EyeHandFeedback.Time - ds, .1*EyeHandFeedback.TargetX - vs, 'k--', 'LineWidth', 3)
plot(EyeHandFeedback.Time - ds, .1*EyeHandFeedback.EyeX - vs, 'r', 'LineWidth', 3)
plot(EyeHandFeedback.Time - ds, .1*EyeHandFeedback.HandX - vs, 'Color', [0 0.4470 0.7410], 'LineWidth', 3)
plot(EyeHandFeedback.Time(fixationIndices_EHF) - ds, .1*fixations_EHF(:,1) - vs, 'kx', 'MarkerSize', 18, 'LineWidth', 3)
plot(EyeHandNoFeedback.Time(handOnsetIndicesX_EHnF) - ds, .1*handOnsetsX_EHnF - vs,'ko', 'MarkerSize', 14, 'LineWidth', 2.5)
xlim([0, 242.5 - ds])
ax.FontSize = 24;
legend('Target', 'Raw Eye Data', 'Raw Hand Data', 'Eye Fixation', 'Hand Endpoint', 'FontSize', 20)
xlabel('Time (s)')
ylabel('Movement (cm)')