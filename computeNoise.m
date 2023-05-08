% This code high pass filters the data

clear;
clc;
close all;

% Choose subject file to open
loadData

labelData

ds = 10;
downsampleData

fs = 1000/ds;
fn = fs/2;
fc = 2.5;

[z,p] = butter(2,fc/fn,'high');
EyeAloneFeedback.EyeX = filtfilt(z,p,EyeAloneFeedback.EyeX);
EyeAloneFeedback.EyeY = filtfilt(z,p,EyeAloneFeedback.EyeY);

norm = histfit(EyeAloneFeedback.EyeX);
[muHat, sigmaHat] = normfit(EyeAloneFeedback.EyeX);
% Plot bounds at +- 3 * sigma.
lowBound = muHat - 3 * sigmaHat;
highBound = muHat + 3 * sigmaHat;
yl = ylim;
line([lowBound, lowBound], yl, 'Color', [0, .6, 0], 'LineWidth', 3);
line([highBound, highBound], yl, 'Color', [0, .6, 0], 'LineWidth', 3);
line([muHat, muHat], yl, 'Color', [0, .6, 0], 'LineWidth', 3);
grid on;

EyeAloneNoFeedback.EyeX = filtfilt(z,p,EyeAloneNoFeedback.EyeX);
EyeAloneNoFeedback.EyeY = filtfilt(z,p,EyeAloneNoFeedback.EyeY);

EyeHandFeedback.EyeX = filtfilt(z,p,EyeHandFeedback.EyeX);
EyeHandFeedback.EyeY = filtfilt(z,p,EyeHandFeedback.EyeY);

EyeHandNoFeedback.EyeX = filtfilt(z,p,EyeHandNoFeedback.EyeX);
EyeHandNoFeedback.EyeY = filtfilt(z,p,EyeHandNoFeedback.EyeY);

figure
subplot(1,2,1)
histogram(EyeAloneFeedback.EyeX)

subplot(1,2,2)
histogram(EyeAloneFeedback.EyeY)

figure
subplot(1,2,1)
histogram(EyeAloneNoFeedback.EyeX)

subplot(1,2,2)
histogram(EyeAloneNoFeedback.EyeY)

figure
subplot(1,2,1)
histogram(EyeHandFeedback.EyeX)

subplot(1,2,2)
histogram(EyeHandFeedback.EyeY)

figure
subplot(1,2,1)
histogram(EyeHandNoFeedback.EyeX)

subplot(1,2,2)
histogram(EyeHandNoFeedback.EyeY)