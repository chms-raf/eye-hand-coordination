% This code plots data (after removing blinks)

global EyeHandNoFeedback EyeHandFeedback

% EyeHandNoFeedback
figure
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeX_F_NBT)
hold on
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandX)
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetX)
title('EyeHandNoFeedback: EyeX and HandX vs time')
xlabel('Time (s)')
ylabel('x-coordinate (mm)')
legend('EyeX','HandX','Target')

% EyeHandFeedback
figure
plot(EyeHandFeedback.Time, EyeHandFeedback.EyeX_F_NBT)
hold on
plot(EyeHandFeedback.Time, EyeHandFeedback.HandX)
plot(EyeHandFeedback.Time, EyeHandFeedback.TargetX)
title('EyeHandFeedback: EyeX and HandX vs time')
xlabel('Time (s)')
ylabel('x-coordinate (mm)')
legend('EyeX','HandX','Target')