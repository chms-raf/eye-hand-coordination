% This file removes trials with blinks from analysis

% The trials with blinks are identified manually and entered into
%   the arrays below.

%% Eye Alone Feedback

EyeX_BT = [5, 7, 8, 18, 22, 27, 42, 48];

EyeY_BT = 35;

EyeAloneFeedback.EyeX_F_NBT = EyeAloneFeedback.EyeX_F;
EyeAloneFeedback.EyeY_F_NBT = EyeAloneFeedback.EyeY_F;
EyeAloneFeedback.TargetX_NBT = EyeAloneFeedback.TargetX;
EyeAloneFeedback.TargetY_NBT = EyeAloneFeedback.TargetY;

temp = find(EyeAloneFeedback.ReachNumber == EyeX_BT(1) | ...
            EyeAloneFeedback.ReachNumber == EyeX_BT(2) | ...
            EyeAloneFeedback.ReachNumber == EyeX_BT(3) | ...
            EyeAloneFeedback.ReachNumber == EyeX_BT(4) | ...
            EyeAloneFeedback.ReachNumber == EyeX_BT(5) | ...
            EyeAloneFeedback.ReachNumber == EyeX_BT(6) | ...
            EyeAloneFeedback.ReachNumber == EyeX_BT(7) | ...
            EyeAloneFeedback.ReachNumber == EyeX_BT(8) | ...
            EyeAloneFeedback.ReachNumber == EyeY_BT(1));
        
EyeAloneFeedback.EyeX_F_NBT(temp) = 604.8285;
EyeAloneFeedback.EyeY_F_NBT(temp) = 455.6125;
EyeAloneFeedback.TargetX_NBT(temp) = 604.8285;
EyeAloneFeedback.TargetY_NBT(temp) = 455.6125;
%% Eye Alone No Feedback

EyeY_BT = [29, 44, 45];

EyeAloneNoFeedback.EyeX_F_NBT = EyeAloneNoFeedback.EyeX_F;
EyeAloneNoFeedback.EyeY_F_NBT = EyeAloneNoFeedback.EyeY_F;
EyeAloneNoFeedback.TargetX_NBT = EyeAloneNoFeedback.TargetX;
EyeAloneNoFeedback.TargetY_NBT = EyeAloneNoFeedback.TargetY;

temp = find(EyeAloneNoFeedback.ReachNumber == EyeY_BT(1) | ...
            EyeAloneNoFeedback.ReachNumber == EyeY_BT(2) | ...
            EyeAloneNoFeedback.ReachNumber == EyeY_BT(3));
        
EyeAloneNoFeedback.EyeX_F_NBT(temp) = 604.8285;
EyeAloneNoFeedback.EyeY_F_NBT(temp) = 455.6125;
EyeAloneNoFeedback.TargetX_NBT(temp) = 604.8285;
EyeAloneNoFeedback.TargetY_NBT(temp) = 455.6125;

%% Eye Hand Feedback

EyeX_BT = [13, 34];

EyeY_BT = 45;

EyeHandFeedback.EyeX_F_NBT = EyeHandFeedback.EyeX_F;
EyeHandFeedback.EyeY_F_NBT = EyeHandFeedback.EyeY_F;
EyeHandFeedback.HandX_NBT = EyeHandFeedback.HandX;
EyeHandFeedback.HandY_NBT = EyeHandFeedback.HandY;
EyeHandFeedback.TargetX_NBT = EyeHandFeedback.TargetX;
EyeHandFeedback.TargetY_NBT = EyeHandFeedback.TargetY;

temp = find(EyeHandFeedback.ReachNumber == EyeX_BT(1) | ...
            EyeHandFeedback.ReachNumber == EyeX_BT(2) | ...
            EyeHandFeedback.ReachNumber == EyeY_BT(1));
        
EyeHandFeedback.EyeX_F_NBT(temp) = 604.8285;
EyeHandFeedback.EyeY_F_NBT(temp) = 455.6125;
EyeHandFeedback.HandX_NBT(temp) = 604.8285;
EyeHandFeedback.HandY_NBT(temp) = 455.6125;
EyeHandFeedback.TargetX_NBT(temp) = 604.8285;
EyeHandFeedback.TargetY_NBT(temp) = 455.6125;

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

%% Plot

% % Eye Alone Feedback
% figure
% subplot(2,1,1)
% plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX_F)
% hold on
% plot(EyeAloneFeedback.Time, EyeAloneFeedback.TargetX)
% 
% subplot(2,1,2)
% plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX_F_NBT)
% hold on
% plot(EyeAloneFeedback.Time, EyeAloneFeedback.TargetX_NBT)
% 
% figure
% subplot(2,1,1)
% plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeY_F)
% hold on
% plot(EyeAloneFeedback.Time, EyeAloneFeedback.TargetY)
% 
% subplot(2,1,2)
% plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeY_F_NBT)
% hold on
% plot(EyeAloneFeedback.Time, EyeAloneFeedback.TargetY_NBT)
% 
% % Eye Alone No Feedback
% figure
% subplot(2,1,1)
% plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeX_F)
% hold on
% plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.TargetX)
% 
% subplot(2,1,2)
% plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeX_F_NBT)
% hold on
% plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.TargetX_NBT)
% 
% figure
% subplot(2,1,1)
% plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeY_F)
% hold on
% plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.TargetY)
% 
% subplot(2,1,2)
% plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeY_F_NBT)
% hold on
% plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.TargetY_NBT)
% 
% % Eye Hand Feedback
% figure
% subplot(2,1,1)
% plot(EyeHandFeedback.Time, EyeHandFeedback.EyeX_F)
% hold on
% plot(EyeHandFeedback.Time, EyeHandFeedback.HandX)
% plot(EyeHandFeedback.Time, EyeHandFeedback.TargetX)
% 
% subplot(2,1,2)
% plot(EyeHandFeedback.Time, EyeHandFeedback.EyeX_F_NBT)
% hold on
% plot(EyeHandFeedback.Time, EyeHandFeedback.HandX_NBT)
% plot(EyeHandFeedback.Time, EyeHandFeedback.TargetX_NBT)
% 
% figure
% subplot(2,1,1)
% plot(EyeHandFeedback.Time, EyeHandFeedback.EyeY_F)
% hold on
% plot(EyeHandFeedback.Time, EyeHandFeedback.HandY)
% plot(EyeHandFeedback.Time, EyeHandFeedback.TargetY)
% 
% subplot(2,1,2)
% plot(EyeHandFeedback.Time, EyeHandFeedback.EyeY_F_NBT)
% hold on
% plot(EyeHandFeedback.Time, EyeHandFeedback.HandY_NBT)
% plot(EyeHandFeedback.Time, EyeHandFeedback.TargetY_NBT)
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