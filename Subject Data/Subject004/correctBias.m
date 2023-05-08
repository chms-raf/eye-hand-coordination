% This file applies a bias across whole trial to correct eye position

%% EyeHandNoFeedback

temp = EyeHandNoFeedback.TargetNumber == 0;
avg = mean(EyeHandNoFeedback.HandX_NBT(temp));

EyeHandNoFeedback.HandX_NBT_bias = EyeHandNoFeedback.HandX_NBT + (604.8285 - avg);

% EyeHandNoFeedback
figure
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandX_NBT)
hold on
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandX_NBT_bias)
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetX)
title('EyeHandNoFeedback: EyeX and HandX vs time')
xlabel('Time (s)')
ylabel('x-coordinate (mm)')
legend('HandX','HandX with bias','Target')
%% EyeHandFeedback
% 
% temp = EyeHandFeedback.TargetNumber == 0;
% avg = mean(EyeHandFeedback.HandX_NBT(temp));
% 
% EyeHandFeedback.HandX_NBT_bias = EyeHandFeedback.HandX_NBT + (604.8285 - avg);
