% This code plots data

global EyeAloneFeedback EyeAloneNoFeedback EyeHandFeedback EyeHandNoFeedback

% EyeAloneFeedback
figure
plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX)
hold on
plot(EyeAloneFeedback.Time, EyeAloneFeedback.TargetX)
title('EyeAloneFeedback: EyeX vs time')
xlabel('Time (s)')
ylabel('x-coordinate (mm)')
legend('Eye','Target')

figure
plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeY)
hold on
plot(EyeAloneFeedback.Time, EyeAloneFeedback.TargetY)
title('EyeAloneFeedback: EyeY vs time')
xlabel('Time (s)')
ylabel('y-coordinate (mm)')
legend('Eye','Target')

% EyeAloneNoFeedback
figure
plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeX)
hold on
plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.TargetX)
title('EyeAloneNoFeedback: EyeX vs time')
xlabel('Time (s)')
ylabel('x-coordinate (mm)')
legend('Eye','Target')

figure
plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeY)
hold on
plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.TargetY)
title('EyeAloneNoFeedback: EyeY vs time')
xlabel('Time (s)')
ylabel('y-coordinate (mm)')
legend('Eye','Target')

% EyeHandFeedback
figure
plot(EyeHandFeedback.Time, EyeHandFeedback.EyeX)
hold on
plot(EyeHandFeedback.Time, EyeHandFeedback.TargetX)
plot(EyeHandFeedback.Time, EyeHandFeedback.HandX)
title('EyeHandFeedback: EyeX and HandX vs time')
xlabel('Time (s)')
ylabel('x-coordinate (mm)')
legend('Eye','Target', 'Hand')

figure
plot(EyeHandFeedback.Time, EyeHandFeedback.EyeY)
hold on
plot(EyeHandFeedback.Time, EyeHandFeedback.TargetY)
plot(EyeHandFeedback.Time, EyeHandFeedback.HandY)
title('EyeHandFeedback: EyeY and HandY vs time')
xlabel('Time (s)')
ylabel('y-coordinate (mm)')
legend('Eye','Target', 'Hand')

% EyeHandNoFeedback
figure
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeX)
hold on
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetX)
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandX)
title('EyeHandNoFeedback: EyeX and HandX vs time')
xlabel('Time (s)')
ylabel('x-coordinate (mm)')
legend('Eye','Target', 'Hand')

figure
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeY)
hold on
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetY)
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandY)
title('EyeHandNoFeedback: EyeY and HandY vs time')
xlabel('Time (s)')
ylabel('y-coordinate (mm)')
legend('Eye','Target', 'Hand')