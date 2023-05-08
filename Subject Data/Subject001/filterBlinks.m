% This function filters out blinks

% EyeY Spectral Density Chart
EyeXsample = downsample(EyeAloneFeedback.EyeX, 50);
TimeSample = downsample(EyeAloneFeedback.Time, 50);

Fs = 240;
T = 1/Fs;
L = length(EyeXsample);
t = (0:L-1)*T;
NFFT = 2^nextpow2(L);
Spect = fft(EyeAloneFeedback.EyeX,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
spectralData = 2*abs(Spect(1:NFFT/2+1));

figure
bar(f,spectralData)
axis([0 25 0 25])
title('Spectral Density Chart for EyeY')
xlabel('Frequency (Hz)')
ylabel('Power')

% Set Fcutoff from spectral density chart
Fcutoff = ginput(1);
Fcutoff = Fcutoff(1);

fnorm = Fcutoff/(Fs/2);
[b,a] = butter(2,fnorm);
EyeX_F = filtfilt(b,a,EyeXsample);

figure
plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX)
hold on
plot(TimeSample, EyeX_F)
plot(EyeAloneFeedback.Time, EyeAloneFeedback.TargetX)
legend('EyeX', 'Filtered EyeX', 'Target')
title('Filtered EyeX Data')
xlabel('Time (s)')
ylabel('X Direction (mm)')