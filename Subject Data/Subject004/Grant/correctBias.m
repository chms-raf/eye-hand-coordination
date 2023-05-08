% This file applies a bias across whole trial to correct eye position

%% EyeHandNoFeedback

temp = EyeHandNoFeedback.TargetNumber == 0;

avg = mean(EyeHandNoFeedback.HandX_NBT(temp));
EyeHandNoFeedback.HandX_NBT_bias = EyeHandNoFeedback.HandX_NBT + (604.8285 - avg);

avg = mean(EyeHandNoFeedback.EyeX_F_NBT(temp));
EyeHandNoFeedback.EyeX_F_NBT_bias = EyeHandNoFeedback.EyeX_F_NBT + (604.8285 - avg);

% % EyeHandNoFeedback
% figure
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeX_F_NBT)
% hold on
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeX_F_NBT_bias)
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetX)
% title('EyeX')
% xlabel('Time (s)')
% ylabel('x-coordinate (mm)')
% legend('EyeX','EyeX with bias','Target')
% 
% figure
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandX_NBT)
% hold on
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandX_NBT_bias)
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetX)
% title('HandX')
% xlabel('Time (s)')
% ylabel('x-coordinate (mm)')
% legend('HandX','HandX with bias','Target')
% 
% disp('Hit enter to continue')
% pause
% 
% close all