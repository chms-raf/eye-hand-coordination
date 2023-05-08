% Test

clear; 
clc;
close all

%%%%% Set filter parameters %%%%%
ds = 10;            % Downsample integer factor (10 for 100 Hz)
                    %                           (20 for 50 Hz)
radius = 110;       % Radius for calcuating fixations, < 2 seconds
                    %                           (200 for 100 Hz)
                    %                           (100 for 50 Hz)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose subject file to open
loadData

labelData

downsampleData

interpolateData


%% FFT
Fs = 1000/ds;
T = 1/Fs;
L = length(EyeAloneFeedback.EyeX);

EyeAloneFeedback.EyeX_FFT = fft(EyeAloneFeedback.EyeX);

P2 = abs(EyeAloneFeedback.EyeX_FFT/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

figure
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

% High Pass Filter data

figure
subplot(5,1,1)
plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX)
hold on
plot(EyeAloneFeedback.Time, EyeAloneFeedback.TargetX)

fs = 1000/ds;
fn = fs/2;
fc = 5;

[z,p] = butter(2,fc/fn,'high');
%[z,p] = butter(2,fc/fn);
EyeAloneFeedback.EyeX_F = filtfilt(z,p,EyeAloneFeedback.EyeX);
EyeAloneFeedback.EyeY_F = filtfilt(z,p,EyeAloneFeedback.EyeY);

subplot(5,1,2)
plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX_F)
ylabel('5 Hz')

fc = 2.5;
[z,p] = butter(2,fc/fn,'high');
EyeAloneFeedback.EyeX_F = filtfilt(z,p,EyeAloneFeedback.EyeX);

subplot(5,1,3)
plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX_F)
ylabel('2.5 Hz')

fc = 1.25;
[z,p] = butter(2,fc/fn,'high');
EyeAloneFeedback.EyeX_F = filtfilt(z,p,EyeAloneFeedback.EyeX);

subplot(5,1,4)
plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX_F)
ylabel('1.25 Hz')

fc = .625;
[z,p] = butter(2,fc/fn,'high');
EyeAloneFeedback.EyeX_F = filtfilt(z,p,EyeAloneFeedback.EyeX);

subplot(5,1,5)
plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX_F)
ylabel('.625 Hz')

% figure
% histfit(EyeAloneFeedback.EyeX_F)
% 
% pdX = fitdist(EyeAloneFeedback.EyeX_F,'Normal')
% 
% figure
% histfit(EyeAloneFeedback.EyeY_F)
% 
% pdY = fitdist(EyeAloneFeedback.EyeY_F,'Normal')