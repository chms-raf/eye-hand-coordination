% This function filters the data

Fs = 240;
T = 1/Fs;

%% EyeHandNoFeedback
fprintf('    EyeHandNoFeedback:\n')
fprintf('    EyeX...')

L = length(EyeHandNoFeedback.EyeX);
% t = (0:L-1)*T;
NFFT = 2^nextpow2(L);
Spect = fft(EyeHandNoFeedback.EyeX,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
spectralData = 2*abs(Spect(1:NFFT/2+1));

figure
bar(f,spectralData)
axis([0 25 0 25])
title('EyeHandNoFeedback: EyeX')
xlabel('Frequency (Hz)')
ylabel('Power')

% Set Fcutoff from spectral density chart
Fcutoff = ginput(1);
close
Fcutoff = Fcutoff(1);

fnorm = Fcutoff/(Fs/2);
[b,a] = butter(2,fnorm);
EyeHandNoFeedback.EyeX_F = filtfilt(b,a,EyeHandNoFeedback.EyeX);

fprintf('    fcutoff = %f\n', Fcutoff)

fprintf('    EyeY...')

L = length(EyeHandNoFeedback.EyeY);
t = (0:L-1)*T;
NFFT = 2^nextpow2(L);
Spect = fft(EyeHandNoFeedback.EyeY,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
spectralData = 2*abs(Spect(1:NFFT/2+1));

figure
bar(f,spectralData)
axis([0 25 0 25])
title('EyeHandNoFeedback: EyeY')
xlabel('Frequency (Hz)')
ylabel('Power')

% Set Fcutoff from spectral density chart
Fcutoff = ginput(1);
close
Fcutoff = Fcutoff(1);

fnorm = Fcutoff/(Fs/2);
[b,a] = butter(2,fnorm);
EyeHandNoFeedback.EyeY_F = filtfilt(b,a,EyeHandNoFeedback.EyeY);

fprintf('    fcutoff = %f\n', Fcutoff)

% figure
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeY)
% hold on
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeY_F)
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetY)
% legend('EyeY','Filtered EyeY', 'Target')
% title('EyeHandNoFeedback: Filtered EyeY Data')
% xlabel('Time (s)')
% ylabel('Y Direction (mm)')
% 
% figure
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeX)
% hold on
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeX_F)
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetX)
% legend('EyeX','Filtered EyeX', 'Target')
% title('EyeHandNoFeedback: Filtered EyeX Data')
% xlabel('Time (s)')
% ylabel('X Direction (mm)')
% 
% disp('Hit enter to continue')
% pause
% 
% close all