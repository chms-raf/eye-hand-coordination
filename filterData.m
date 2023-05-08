Fs = 240;
T = 1/Fs;

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
%axis([0 25 0 25])
axis([0 50 0 50])
title('EyeAloneFeedback: EyeX')
xlabel('Frequency (Hz)')
ylabel('Power')

% Set Fcutoff from spectral density chart
Fcutoff = ginput(1);
close
Fcutoff = Fcutoff(1);

fnorm = Fcutoff/(Fs/2);
[b,a] = butter(2,fnorm);
EyeAloneFeedback.EyeX = filtfilt(b,a,EyeAloneFeedback.EyeX);

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
%axis([0 25 0 25])
axis([0 50 0 50])
title('EyeAloneFeedback: EyeY')
xlabel('Frequency (Hz)')
ylabel('Power')

% Set Fcutoff from spectral density chart
Fcutoff = ginput(1);
close
Fcutoff = Fcutoff(1);

fnorm = Fcutoff/(Fs/2);
[b,a] = butter(2,fnorm);
EyeAloneFeedback.EyeY = filtfilt(b,a,EyeAloneFeedback.EyeY);

fprintf('    fcutoff = %f\n', Fcutoff)