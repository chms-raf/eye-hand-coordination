% This file splits data into specific reaches

global EyeAloneFeedback EyeAloneNoFeedback EyeHandFeedback EyeHandNoFeedback

idx = find(EyeAloneFeedback.ReachNumber == 1);
EyeAloneFeedback.Reach1 = zeros(length(idx),12);
EyeAloneFeedback.Reach1(:,1) = EyeAloneFeedback.Time(idx);
EyeAloneFeedback.Reach1(:,2) = EyeAloneFeedback.EyeX(idx);
EyeAloneFeedback.Reach1(:,3) = EyeAloneFeedback.EyeY(idx);
EyeAloneFeedback.Reach1(:,4) = EyeAloneFeedback.FixationTime(idx);
EyeAloneFeedback.Reach1(:,5) = EyeAloneFeedback.FixationTimer(idx);
EyeAloneFeedback.Reach1(:,6) = EyeAloneFeedback.HandX(idx);
EyeAloneFeedback.Reach1(:,7) = EyeAloneFeedback.HandY(idx);
EyeAloneFeedback.Reach1(:,8) = EyeAloneFeedback.HandZ(idx);
EyeAloneFeedback.Reach1(:,9) = EyeAloneFeedback.ReachNumber(idx);
EyeAloneFeedback.Reach1(:,10) = EyeAloneFeedback.TargetNumber(idx);
EyeAloneFeedback.Reach1(:,11) = EyeAloneFeedback.TargetX(idx);
EyeAloneFeedback.Reach1(:,12) = EyeAloneFeedback.TargetY(idx);

plot(EyeAloneFeedback.Reach1(:,1), EyeAloneFeedback.Reach1(:,2))
hold on
plot(EyeAloneFeedback.Reach1(:,1), EyeAloneFeedback.Reach1(:,11))
