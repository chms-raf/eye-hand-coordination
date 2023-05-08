% This file removes outliers in data

global EyeAloneFeedback EyeAloneNoFeedback EyeHandFeedback EyeHandNoFeedback

% EyeAloneFeedback
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

% EyeAloneNoFeedback
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

% EyeHandFeedback
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

% EyeHandNoFeedback
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