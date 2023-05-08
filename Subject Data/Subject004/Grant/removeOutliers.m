% This file removes outliers in data

global EyeHandNoFeedback

% EyeHandNoFeedback
EyeHandNoFeedback.Time = downsample(EyeHandNoFeedback.Time, 15);
EyeHandNoFeedback.EyeX = downsample(EyeHandNoFeedback.EyeX, 15);
EyeHandNoFeedback.EyeY = downsample(EyeHandNoFeedback.EyeY, 15);
EyeHandNoFeedback.FixationTime = downsample(EyeHandNoFeedback.FixationTime, 15);
EyeHandNoFeedback.FixationTimer = downsample(EyeHandNoFeedback.FixationTimer, 15);
EyeHandNoFeedback.HandX = downsample(EyeHandNoFeedback.HandX, 15);
EyeHandNoFeedback.HandY = downsample(EyeHandNoFeedback.HandY, 15);
EyeHandNoFeedback.HandZ = downsample(EyeHandNoFeedback.HandZ, 15);
EyeHandNoFeedback.ReachNumber = downsample(EyeHandNoFeedback.ReachNumber, 15);
EyeHandNoFeedback.TargetNumber = downsample(EyeHandNoFeedback.TargetNumber, 15);
EyeHandNoFeedback.TargetX = downsample(EyeHandNoFeedback.TargetX, 15);
EyeHandNoFeedback.TargetY = downsample(EyeHandNoFeedback.TargetY, 15);

temp = find(EyeHandNoFeedback.Time <= 0 | EyeHandNoFeedback.EyeX <= 0 | EyeHandNoFeedback.EyeY <= 0 | EyeHandNoFeedback.HandX <= 0 | EyeHandNoFeedback.HandY <= 0);
EyeHandNoFeedback.Time(temp) = [];
EyeHandNoFeedback.EyeX(temp) = [];
EyeHandNoFeedback.EyeY(temp) = [];
EyeHandNoFeedback.FixationTime(temp) = [];
EyeHandNoFeedback.FixationTimer(temp) = [];
EyeHandNoFeedback.HandX(temp) = [];
EyeHandNoFeedback.HandY(temp) = [];
EyeHandNoFeedback.HandZ(temp) = [];
EyeHandNoFeedback.ReachNumber(temp) = [];
EyeHandNoFeedback.TargetNumber(temp) = [];
EyeHandNoFeedback.TargetX(temp) = [];
EyeHandNoFeedback.TargetY(temp) = [];

temp = find(EyeHandNoFeedback.ReachNumber > 50);
EyeHandNoFeedback.Time(temp) = [];
EyeHandNoFeedback.EyeX(temp) = [];
EyeHandNoFeedback.EyeY(temp) = [];
EyeHandNoFeedback.FixationTime(temp) = [];
EyeHandNoFeedback.FixationTimer(temp) = [];
EyeHandNoFeedback.HandX(temp) = [];
EyeHandNoFeedback.HandY(temp) = [];
EyeHandNoFeedback.HandZ(temp) = [];
EyeHandNoFeedback.ReachNumber(temp) = [];
EyeHandNoFeedback.TargetNumber(temp) = [];
EyeHandNoFeedback.TargetX(temp) = [];
EyeHandNoFeedback.TargetY(temp) = [];