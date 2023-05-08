% This function filters out blinks

Fs = 240;
T = 1/Fs;

%% EyeAloneFeedback
fprintf('    EyeAloneFeedback:\n')
fprintf('    EyeX...')

L = length(EyeAloneFeedback.EyeX);
% t = (0:L-1)*T;
NFFT = 2^nextpow2(L);
Spect = fft(EyeAloneFeedback.EyeX,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
spectralData = 2*abs(Spect(1:NFFT/2+1));

figure
bar(f,spectralData)
axis([0 25 0 25])
title('EyeAloneFeedback: EyeX')
xlabel('Frequency (Hz)')
ylabel('Power')

% Set Fcutoff from spectral density chart
Fcutoff = ginput(1);
close
Fcutoff = Fcutoff(1);

fnorm = Fcutoff/(Fs/2);
[b,a] = butter(2,fnorm);
EyeAloneFeedback.EyeX_F = filtfilt(b,a,EyeAloneFeedback.EyeX);

fprintf('    fcutoff = %f\n', Fcutoff)

fprintf('    EyeY...')

L = length(EyeAloneFeedback.EyeY);
% t = (0:L-1)*T;
NFFT = 2^nextpow2(L);
Spect = fft(EyeAloneFeedback.EyeY,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
spectralData = 2*abs(Spect(1:NFFT/2+1));

figure
bar(f,spectralData)
axis([0 25 0 25])
title('EyeAloneFeedback: EyeY')
xlabel('Frequency (Hz)')
ylabel('Power')

% Set Fcutoff from spectral density chart
Fcutoff = ginput(1);
close
Fcutoff = Fcutoff(1);

fnorm = Fcutoff/(Fs/2);
[b,a] = butter(2,fnorm);
EyeAloneFeedback.EyeY_F = filtfilt(b,a,EyeAloneFeedback.EyeY);

fprintf('    fcutoff = %f\n', Fcutoff)

%% EyeAloneNoFeedback
fprintf('    EyeAloneNoFeedback:\n')
fprintf('    EyeX...')

L = length(EyeAloneNoFeedback.EyeX);
% t = (0:L-1)*T;
NFFT = 2^nextpow2(L);
Spect = fft(EyeAloneNoFeedback.EyeX,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
spectralData = 2*abs(Spect(1:NFFT/2+1));

figure
bar(f,spectralData)
axis([0 25 0 25])
title('EyeAloneNoFeedback: EyeX')
xlabel('Frequency (Hz)')
ylabel('Power')

% Set Fcutoff from spectral density chart
Fcutoff = ginput(1);
close
Fcutoff = Fcutoff(1);

fnorm = Fcutoff/(Fs/2);
[b,a] = butter(2,fnorm);
EyeAloneNoFeedback.EyeX_F = filtfilt(b,a,EyeAloneNoFeedback.EyeX);

fprintf('    fcutoff = %f\n', Fcutoff)

fprintf('    EyeY...')

L = length(EyeAloneNoFeedback.EyeY);
% t = (0:L-1)*T;
NFFT = 2^nextpow2(L);
Spect = fft(EyeAloneNoFeedback.EyeY,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
spectralData = 2*abs(Spect(1:NFFT/2+1));

figure
bar(f,spectralData)
axis([0 25 0 25])
title('EyeAloneNoFeedback: EyeY')
xlabel('Frequency (Hz)')
ylabel('Power')

% Set Fcutoff from spectral density chart
Fcutoff = ginput(1);
close
Fcutoff = Fcutoff(1);

fnorm = Fcutoff/(Fs/2);
[b,a] = butter(2,fnorm);
EyeAloneNoFeedback.EyeY_F = filtfilt(b,a,EyeAloneNoFeedback.EyeY);

fprintf('    fcutoff = %f\n', Fcutoff)

%% EyeHandFeedback
fprintf('    EyeHandFeedback:\n')
fprintf('    EyeX...')

L = length(EyeHandFeedback.EyeX);
% t = (0:L-1)*T;
NFFT = 2^nextpow2(L);
Spect = fft(EyeHandFeedback.EyeX,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
spectralData = 2*abs(Spect(1:NFFT/2+1));

figure
bar(f,spectralData)
axis([0 25 0 25])
title('EyeHandFeedback: EyeX')
xlabel('Frequency (Hz)')
ylabel('Power')

% Set Fcutoff from spectral density chart
Fcutoff = ginput(1);
close
Fcutoff = Fcutoff(1);

fnorm = Fcutoff/(Fs/2);
[b,a] = butter(2,fnorm);
EyeHandFeedback.EyeX_F = filtfilt(b,a,EyeHandFeedback.EyeX);

fprintf('    fcutoff = %f\n', Fcutoff)

fprintf('    EyeY...')

L = length(EyeHandFeedback.EyeY);
% t = (0:L-1)*T;
NFFT = 2^nextpow2(L);
Spect = fft(EyeHandFeedback.EyeY,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
spectralData = 2*abs(Spect(1:NFFT/2+1));

figure
bar(f,spectralData)
axis([0 25 0 25])
title('EyeHandFeedback: EyeY')
xlabel('Frequency (Hz)')
ylabel('Power')

% Set Fcutoff from spectral density chart
Fcutoff = ginput(1);
close
Fcutoff = Fcutoff(1);

fnorm = Fcutoff/(Fs/2);
[b,a] = butter(2,fnorm);
EyeHandFeedback.EyeY_F = filtfilt(b,a,EyeHandFeedback.EyeY);

fprintf('    fcutoff = %f\n', Fcutoff)

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

%% Plot

% figure
% plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX)
% hold on
% plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX_F)
% plot(EyeAloneFeedback.Time, EyeAloneFeedback.TargetX)
% legend('EyeX','Filtered EyeX', 'Target')
% title('EyeAloneFeedback: Filtered EyeX Data')
% xlabel('Time (s)')
% ylabel('X Direction (mm)')
% 
% figure
% plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeY)
% hold on
% plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeY_F)
% plot(EyeAloneFeedback.Time, EyeAloneFeedback.TargetY)
% legend('EyeY','Filtered EyeY', 'Target')
% title('EyeAloneFeedback: Filtered EyeY Data')
% xlabel('Time (s)')
% ylabel('Y Direction (mm)')
% 
% figure
% plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeX)
% hold on
% plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeX_F)
% plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.TargetX)
% legend('EyeX','Filtered EyeX', 'Target')
% title('EyeAloneNoFeedback: Filtered EyeX Data')
% xlabel('Time (s)')
% ylabel('X Direction (mm)')
% 
% figure
% plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeY)
% hold on
% plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeY_F)
% plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.TargetY)
% legend('EyeY','Filtered EyeY', 'Target')
% title('EyeAloneNoFeedback: Filtered EyeY Data')
% xlabel('Time (s)')
% ylabel('Y Direction (mm)')
% 
% figure
% plot(EyeHandFeedback.Time, EyeHandFeedback.EyeX)
% hold on
% plot(EyeHandFeedback.Time, EyeHandFeedback.EyeX_F)
% plot(EyeHandFeedback.Time, EyeHandFeedback.TargetX)
% legend('EyeX','Filtered EyeX', 'Target')
% title('EyeHandFeedback: Filtered EyeX Data')
% xlabel('Time (s)')
% ylabel('X Direction (mm)')
% 
% figure
% plot(EyeHandFeedback.Time, EyeHandFeedback.EyeY)
% hold on
% plot(EyeHandFeedback.Time, EyeHandFeedback.EyeY_F)
% plot(EyeHandFeedback.Time, EyeHandFeedback.TargetY)
% legend('EyeY','Filtered EyeY', 'Target')
% title('EyeHandFeedback: Filtered EyeY Data')
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
% figure
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeY)
% hold on
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeY_F)
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetY)
% legend('EyeY','Filtered EyeY', 'Target')
% title('EyeHandNoFeedback: Filtered EyeY Data')
% xlabel('Time (s)')
% ylabel('Y Direction (mm)')