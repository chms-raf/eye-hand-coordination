% This file removes trials with blinks from analysis

% The trials with blinks are identified manually and entered into
%   the arrays below.

%% Eye Hand No Feedback

EyeX_BT = [25, 39];

EyeY_BT = 45;

EyeHandNoFeedback.EyeX_F_NBT = EyeHandNoFeedback.EyeX_F;
EyeHandNoFeedback.EyeY_F_NBT = EyeHandNoFeedback.EyeY_F;
EyeHandNoFeedback.HandX_NBT = EyeHandNoFeedback.HandX;
EyeHandNoFeedback.HandY_NBT = EyeHandNoFeedback.HandY;
EyeHandNoFeedback.TargetX_NBT = EyeHandNoFeedback.TargetX;
EyeHandNoFeedback.TargetY_NBT = EyeHandNoFeedback.TargetY;

temp = find(EyeHandNoFeedback.ReachNumber == EyeX_BT(1) | ...
            EyeHandNoFeedback.ReachNumber == EyeX_BT(2) | ...
            EyeHandNoFeedback.ReachNumber == EyeY_BT(1));
        
EyeHandNoFeedback.EyeX_F_NBT(temp) = 604.8285;
EyeHandNoFeedback.EyeY_F_NBT(temp) = 455.6125;
EyeHandNoFeedback.HandX_NBT(temp) = 604.8285;
EyeHandNoFeedback.HandY_NBT(temp) = 455.6125;
EyeHandNoFeedback.TargetX_NBT(temp) = 604.8285;
EyeHandNoFeedback.TargetY_NBT(temp) = 455.6125;

% %% Plot
% 
% % Eye Hand No Feedback
% figure
% subplot(2,1,1)
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeX_F)
% hold on
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandX)
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetX)
% 
% subplot(2,1,2)
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeX_F_NBT)
% hold on
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandX_NBT)
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetX_NBT)
% 
% figure
% subplot(2,1,1)
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeY_F)
% hold on
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandY)
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetY)
% 
% subplot(2,1,2)
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeY_F_NBT)
% hold on
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandY_NBT)
% plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetY_NBT)
% 
% disp('Hit Enter to continue')
% pause
% 
% close all