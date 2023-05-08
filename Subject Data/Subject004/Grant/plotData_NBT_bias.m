% This code plots data (after removing blinks)

global EyeHandNoFeedback

% EyeHandNoFeedback
figure
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeX_F_NBT_bias)
hold on
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandX_NBT_bias)
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetX)
title('EyeHandNoFeedback: EyeX and HandX vs time')
xlabel('Time (s)')
ylabel('x-coordinate (mm)')
legend('EyeX','HandX','Target')