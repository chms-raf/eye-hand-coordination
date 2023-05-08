% This file plots the raw data

% X-direction
figure('Name', [subject, ' X-direction'])
subplot(2,2,1)
plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX)
xlabel('Time (s)')
ylabel('X-direction (mm)')
title(['Eye-Alone with Feedback Raw Data: ', subject])

subplot(2,2,2)
plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeX)
xlabel('Time (s)')
ylabel('X-direction (mm)')
title(['Eye-Alone with No Feedback Raw Data: ', subject])

subplot(2,2,3)
plot(EyeHandFeedback.Time, EyeHandFeedback.EyeX)
hold on
plot(EyeHandFeedback.Time, EyeHandFeedback.HandX)
xlabel('Time (s)')
ylabel('X-direction (mm)')
title(['Eye-Hand with Feedback Raw Data: ', subject])

subplot(2,2,4)
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeX)
hold on
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandX)
xlabel('Time (s)')
ylabel('X-direction (mm)')
title(['Eye-Hand with No Feedback Raw Data: ', subject])

% Y-direction
figure('Name', [subject, ' Y-direction'])
subplot(2,2,1)
plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeY)
set(gca, 'YDir','reverse')
xlabel('Time (s)')
ylabel('Y-direction (mm)')
title(['Eye-Alone with Feedback Raw Data: ', subject])

subplot(2,2,2)
plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeY)
set(gca, 'YDir','reverse')
xlabel('Time (s)')
ylabel('Y-direction (mm)')
title(['Eye-Alone with No Feedback Raw Data: ', subject])

subplot(2,2,3)
plot(EyeHandFeedback.Time, EyeHandFeedback.EyeY)
set(gca, 'YDir','reverse')
hold on
plot(EyeHandFeedback.Time, EyeHandFeedback.HandY)
xlabel('Time (s)')
ylabel('Y-direction (mm)')
title(['Eye-Hand with Feedback Raw Data: ', subject])

subplot(2,2,4)
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeY)
set(gca, 'YDir','reverse')
hold on
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandY)
xlabel('Time (s)')
ylabel('Y-direction (mm)')
title(['Eye-Hand with No Feedback Raw Data: ', subject])

% XY-direction
figure('Name', [subject, ' XY-direction'])
subplot(2,2,1)
plot(EyeAloneFeedback.EyeX, EyeAloneFeedback.EyeY, 'o')
set(gca, 'YDir','reverse')
xlabel('X-direction (mm)')
ylabel('Y-direction (mm)')
title(['Eye-Alone with Feedback Raw Data: ', subject])
axis([0 1210 0 651])

subplot(2,2,2)
plot(EyeAloneNoFeedback.EyeX, EyeAloneNoFeedback.EyeY, 'o')
set(gca, 'YDir','reverse')
xlabel('X-direction (mm)')
ylabel('Y-direction (mm)')
title(['Eye-Alone with No Feedback Raw Data: ', subject])
axis([0 1210 0 651])

subplot(2,2,3)
plot(EyeHandFeedback.EyeX, EyeHandFeedback.EyeY, 'o')
set(gca, 'YDir','reverse')
hold on
plot(EyeHandFeedback.HandX, EyeHandFeedback.HandY, 'o')
xlabel('X-direction (mm)')
ylabel('Y-direction (mm)')
title(['Eye-Hand with Feedback Raw Data: ', subject])
axis([0 1210 0 651])

subplot(2,2,4)
plot(EyeHandNoFeedback.EyeX, EyeHandNoFeedback.EyeY, 'o')
set(gca, 'YDir','reverse')
hold on
plot(EyeHandNoFeedback.HandX, EyeHandNoFeedback.HandY, 'o')
xlabel('X-direction (mm)')
ylabel('Y-direction (mm)')
title(['Eye-Hand with No Feedback Raw Data: ', subject])
axis([0 1210 0 651])