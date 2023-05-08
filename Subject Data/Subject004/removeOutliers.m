% This file removes outliers in data

global EyeAloneFeedback EyeAloneNoFeedback EyeHandFeedback EyeHandNoFeedback

% EyeAloneFeedback
EyeAloneFeedback.Time = downsample(EyeAloneFeedback.Time, 15);
EyeAloneFeedback.EyeX = downsample(EyeAloneFeedback.EyeX, 15);
EyeAloneFeedback.EyeY = downsample(EyeAloneFeedback.EyeY, 15);
EyeAloneFeedback.FixationTime = downsample(EyeAloneFeedback.FixationTime, 15);
EyeAloneFeedback.FixationTimer = downsample(EyeAloneFeedback.FixationTimer, 15);
EyeAloneFeedback.HandX = downsample(EyeAloneFeedback.HandX, 15);
EyeAloneFeedback.HandY = downsample(EyeAloneFeedback.HandY, 15);
EyeAloneFeedback.HandZ = downsample(EyeAloneFeedback.HandZ, 15);
EyeAloneFeedback.ReachNumber = downsample(EyeAloneFeedback.ReachNumber, 15);
EyeAloneFeedback.TargetNumber = downsample(EyeAloneFeedback.TargetNumber, 15);
EyeAloneFeedback.TargetX = downsample(EyeAloneFeedback.TargetX, 15);
EyeAloneFeedback.TargetY = downsample(EyeAloneFeedback.TargetY, 15);

temp = find(EyeAloneFeedback.Time <= 0 | EyeAloneFeedback.EyeX <= 0 | EyeAloneFeedback.EyeY <= 0);
EyeAloneFeedback.Time(temp) = [];
EyeAloneFeedback.EyeX(temp) = [];
EyeAloneFeedback.EyeY(temp) = [];
EyeAloneFeedback.FixationTime(temp) = [];
EyeAloneFeedback.FixationTimer(temp) = [];
EyeAloneFeedback.HandX(temp) = [];
EyeAloneFeedback.HandY(temp) = [];
EyeAloneFeedback.HandZ(temp) = [];
EyeAloneFeedback.ReachNumber(temp) = [];
EyeAloneFeedback.TargetNumber(temp) = [];
EyeAloneFeedback.TargetX(temp) = [];
EyeAloneFeedback.TargetY(temp) = [];

temp = find(EyeAloneFeedback.ReachNumber > 50);
EyeAloneFeedback.Time(temp) = [];
EyeAloneFeedback.EyeX(temp) = [];
EyeAloneFeedback.EyeY(temp) = [];
EyeAloneFeedback.FixationTime(temp) = [];
EyeAloneFeedback.FixationTimer(temp) = [];
EyeAloneFeedback.HandX(temp) = [];
EyeAloneFeedback.HandY(temp) = [];
EyeAloneFeedback.HandZ(temp) = [];
EyeAloneFeedback.ReachNumber(temp) = [];
EyeAloneFeedback.TargetNumber(temp) = [];
EyeAloneFeedback.TargetX(temp) = [];
EyeAloneFeedback.TargetY(temp) = [];

% EyeAloneNoFeedback
EyeAloneNoFeedback.Time = downsample(EyeAloneNoFeedback.Time, 15);
EyeAloneNoFeedback.EyeX = downsample(EyeAloneNoFeedback.EyeX, 15);
EyeAloneNoFeedback.EyeY = downsample(EyeAloneNoFeedback.EyeY, 15);
EyeAloneNoFeedback.FixationTime = downsample(EyeAloneNoFeedback.FixationTime, 15);
EyeAloneNoFeedback.FixationTimer = downsample(EyeAloneNoFeedback.FixationTimer, 15);
EyeAloneNoFeedback.HandX = downsample(EyeAloneNoFeedback.HandX, 15);
EyeAloneNoFeedback.HandY = downsample(EyeAloneNoFeedback.HandY, 15);
EyeAloneNoFeedback.HandZ = downsample(EyeAloneNoFeedback.HandZ, 15);
EyeAloneNoFeedback.ReachNumber = downsample(EyeAloneNoFeedback.ReachNumber, 15);
EyeAloneNoFeedback.TargetNumber = downsample(EyeAloneNoFeedback.TargetNumber, 15);
EyeAloneNoFeedback.TargetX = downsample(EyeAloneNoFeedback.TargetX, 15);
EyeAloneNoFeedback.TargetY = downsample(EyeAloneNoFeedback.TargetY, 15);

temp = find(EyeAloneNoFeedback.Time <= 0 | EyeAloneNoFeedback.EyeX <= 0 | EyeAloneNoFeedback.EyeY <= 0);
EyeAloneNoFeedback.Time(temp) = [];
EyeAloneNoFeedback.EyeX(temp) = [];
EyeAloneNoFeedback.EyeY(temp) = [];
EyeAloneNoFeedback.FixationTime(temp) = [];
EyeAloneNoFeedback.FixationTimer(temp) = [];
EyeAloneNoFeedback.HandX(temp) = [];
EyeAloneNoFeedback.HandY(temp) = [];
EyeAloneNoFeedback.HandZ(temp) = [];
EyeAloneNoFeedback.ReachNumber(temp) = [];
EyeAloneNoFeedback.TargetNumber(temp) = [];
EyeAloneNoFeedback.TargetX(temp) = [];
EyeAloneNoFeedback.TargetY(temp) = [];

temp = find(EyeAloneNoFeedback.ReachNumber > 50);
EyeAloneNoFeedback.Time(temp) = [];
EyeAloneNoFeedback.EyeX(temp) = [];
EyeAloneNoFeedback.EyeY(temp) = [];
EyeAloneNoFeedback.FixationTime(temp) = [];
EyeAloneNoFeedback.FixationTimer(temp) = [];
EyeAloneNoFeedback.HandX(temp) = [];
EyeAloneNoFeedback.HandY(temp) = [];
EyeAloneNoFeedback.HandZ(temp) = [];
EyeAloneNoFeedback.ReachNumber(temp) = [];
EyeAloneNoFeedback.TargetNumber(temp) = [];
EyeAloneNoFeedback.TargetX(temp) = [];
EyeAloneNoFeedback.TargetY(temp) = [];

% EyeHandFeedback
EyeHandFeedback.Time = downsample(EyeHandFeedback.Time, 15);
EyeHandFeedback.EyeX = downsample(EyeHandFeedback.EyeX, 15);
EyeHandFeedback.EyeY = downsample(EyeHandFeedback.EyeY, 15);
EyeHandFeedback.FixationTime = downsample(EyeHandFeedback.FixationTime, 15);
EyeHandFeedback.FixationTimer = downsample(EyeHandFeedback.FixationTimer, 15);
EyeHandFeedback.HandX = downsample(EyeHandFeedback.HandX, 15);
EyeHandFeedback.HandY = downsample(EyeHandFeedback.HandY, 15);
EyeHandFeedback.HandZ = downsample(EyeHandFeedback.HandZ, 15);
EyeHandFeedback.ReachNumber = downsample(EyeHandFeedback.ReachNumber, 15);
EyeHandFeedback.TargetNumber = downsample(EyeHandFeedback.TargetNumber, 15);
EyeHandFeedback.TargetX = downsample(EyeHandFeedback.TargetX, 15);
EyeHandFeedback.TargetY = downsample(EyeHandFeedback.TargetY, 15);

temp = find(EyeHandFeedback.Time <= 0 | EyeHandFeedback.EyeX <= 0 | EyeHandFeedback.EyeY <= 0 | EyeHandFeedback.HandX <= 0 | EyeHandFeedback.HandY <= 0);
EyeHandFeedback.Time(temp) = [];
EyeHandFeedback.EyeX(temp) = [];
EyeHandFeedback.EyeY(temp) = [];
EyeHandFeedback.FixationTime(temp) = [];
EyeHandFeedback.FixationTimer(temp) = [];
EyeHandFeedback.HandX(temp) = [];
EyeHandFeedback.HandY(temp) = [];
EyeHandFeedback.HandZ(temp) = [];
EyeHandFeedback.ReachNumber(temp) = [];
EyeHandFeedback.TargetNumber(temp) = [];
EyeHandFeedback.TargetX(temp) = [];
EyeHandFeedback.TargetY(temp) = [];

temp = find(EyeHandFeedback.ReachNumber > 50);
EyeHandFeedback.Time(temp) = [];
EyeHandFeedback.EyeX(temp) = [];
EyeHandFeedback.EyeY(temp) = [];
EyeHandFeedback.FixationTime(temp) = [];
EyeHandFeedback.FixationTimer(temp) = [];
EyeHandFeedback.HandX(temp) = [];
EyeHandFeedback.HandY(temp) = [];
EyeHandFeedback.HandZ(temp) = [];
EyeHandFeedback.ReachNumber(temp) = [];
EyeHandFeedback.TargetNumber(temp) = [];
EyeHandFeedback.TargetX(temp) = [];
EyeHandFeedback.TargetY(temp) = [];

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