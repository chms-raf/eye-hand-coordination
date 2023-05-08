clear; clc; close all

load reachFunctionVars

% This function filters the data

%% Filter Hand Data
HandX_F = filterData2(HandX,15);

% figure
% plot(time,HandX)
% hold on
% plot(time,HandX_F)
% plot(time,TargetX)
% title('Sample Reach')
% ylabel('Position (mm)')
% legend('Unfiltered', 'Filtered','Target')

HandX = HandX_F;

%% Invert reach

TargetX = (1 - TargetX) + 603.8285;
EyeX = (1 - EyeX) + 603.8285;
HandX = (1 - HandX) + 603.8285;

%% Calculate velocities and accelerations
EyeXdot = zeros(length(time)-1,1);
HandXdot = zeros(length(time)-1,1);
EyeXddot = zeros(length(time)-2,1);
HandXddot = zeros(length(time)-2,1);

for i = 1:1:length(EyeX) - 1
    EyeXdot(i,1) = (EyeX(i+1) - EyeX(i))/(time(i+1) - time(i));
    HandXdot(i,1) = (HandX(i+1) - HandX(i))/(time(i+1) - time(i));
end

for i = 1:1:length(EyeXdot) - 1
    EyeXddot(i,1) = (EyeXdot(i+1) - EyeXdot(i))/(time(i+1) - time(i));
    HandXddot(i,1) = (HandXdot(i+1) - HandXdot(i))/(time(i+1) - time(i));
end

TargetX = TargetX(2:end-1);
time = time(2:end-1);
EyeX = EyeX(2:end-1);
EyeXdot = EyeXdot(1:end-1);
HandX = HandX(2:end-1);
HandXdot = HandXdot(1:end-1);

%% Calculate Delay
temp = find(EyeXdot > 100);
EyeOnset = [time(temp(1)), EyeX(temp(1))];
temp = find(HandXdot > 100);
HandOnset = [time(temp(1)), HandX(temp(1))];

delay = HandOnset(1) - EyeOnset(1);

%% Plot Data

figure
plot(time,EyeX)
hold on
plot(time,HandX)
plot(time,TargetX)
plot(EyeOnset(1), EyeOnset(2), 'ko')
plot(HandOnset(1), HandOnset(2), 'ko')
title('Sample Reach')
ylabel('Position (mm)')
xlabel('Time (s)')
legend('Eye', 'Hand', 'Target', 'Onset')

figure
subplot(3,1,1)
plot(time,EyeX)
hold on
plot(time,HandX)
plot(time,TargetX)
plot(EyeOnset(1), EyeOnset(2), 'ko')
plot(HandOnset(1), HandOnset(2), 'ko')
title('Sample Reach')
ylabel('Position (mm)')
legend('Eye', 'Hand', 'Target', 'Onset')

subplot(3,1,2)
plot(time,EyeXdot)
hold on
plot(time,HandXdot)
ylabel('Velocity (mm/s)')
legend('Eye', 'Hand')

subplot(3,1,3)
plot(time,EyeXddot)
hold on
plot(time,HandXddot)
ylabel('Acceleration (mm/s^2)')
legend('Eye', 'Hand')
xlabel('Time (s)')

%% Reaching Function

handP = f(EyeX, EyeXdot, EyeXddot);

h = figure('units','normalized','outerposition',[0 0 1 1]);
ax = gca;
ay = gcf;
ay.Color = 'w';
plot(time - time(1), TargetX, 'LineWidth', 3)
hold on
plot(time - time(1), EyeX, 'LineWidth', 3)
plot(time - time(1),HandX, 'LineWidth', 3)
plot(time - time(1) + delay, handP, 'k', 'LineWidth', 3)
xlabel('Time (s)', 'FontSize', 26)
ax.FontSize = 20;
axis([0 8 -20 140])
ylabel('Position (mm)', 'FontSize', 26)
legend('Target', 'Eye', 'Hand', 'Predicted Hand', 'FontSize', 22)

%orient(h,'landscape')
%print('FillPageFigure','-dpdf','-fillpage')
saveas(h,'ReachFunctionFig.pdf')


RMSE = sqrt(mean((handP - HandX).^2));
% fprintf('RMSE: %f\n', RMSE)

function y = f(x, xDot, xDDot)

    a = .001;
    b = -.05;
    c = 1;
    
    y = a*xDDot+ b*xDot + c*x;

end

function HandX_F = filterData2(HandX,Fcutoff)
Fs = 240;

% L = length(hand);
% % t = (0:L-1)*T;
% NFFT = 2^nextpow2(L);
% Spect = fft(hand,NFFT)/L;
% f = Fs/2*linspace(0,1,NFFT/2+1);
% spectralData = 2*abs(Spect(1:NFFT/2+1));

% figure
% bar(f,spectralData)
% axis([0 100 0 100])
% title('EyeHandNoFeedback: HandX')
% xlabel('Frequency (Hz)')
% ylabel('Power')
% 
% % Set Fcutoff from spectral density chart
% Fcutoff = ginput(1);
% close
% Fcutoff = Fcutoff(1);

fnorm = Fcutoff/(Fs/2);
[b,a] = butter(2,fnorm);
HandX_F = filtfilt(b,a,HandX);
end
