% This code labels recorded structure data

% Recorded Data Key
% 1) Experiment Time (s)......... Time since start of experiment
% 2) EyeX (mm)............... X position of the eyes
% 3) EyeY (mm)............... Y position of the eyes
% 4) Fixation Time (s)....... Fixation Time of current reach
% 5) Fixation Timer (s)...... Running timer that determines when targets appear
% 6) OptoX (mm).............. X position of the hand
% 7) OptoY (mm).............. Y position of the hand
% 8) OptoZ (mm).............. Z position of the hand
% 9) Reach Number............ Number of current reach
% 10) Target Number.......... Number of current target
% 11) TargetX (mm)........... X position of taret
% 12) TargetY (mm)........... Y position of target

EyeAloneFeedback.Time = EyeAloneFeedback.Y(1).Data';
EyeAloneFeedback.EyeX = EyeAloneFeedback.Y(2).Data';
EyeAloneFeedback.EyeY = EyeAloneFeedback.Y(3).Data';
EyeAloneFeedback.FixationTime = EyeAloneFeedback.Y(4).Data';
EyeAloneFeedback.FixationTimer = EyeAloneFeedback.Y(5).Data';
EyeAloneFeedback.HandX = EyeAloneFeedback.Y(6).Data';
EyeAloneFeedback.HandY = EyeAloneFeedback.Y(7).Data';
EyeAloneFeedback.HandZ = EyeAloneFeedback.Y(8).Data';
EyeAloneFeedback.ReachNumber = EyeAloneFeedback.Y(9).Data';
EyeAloneFeedback.TargetNumber = EyeAloneFeedback.Y(10).Data';
EyeAloneFeedback.TargetX = EyeAloneFeedback.Y(11).Data';
EyeAloneFeedback.TargetY = EyeAloneFeedback.Y(12).Data';

EyeAloneNoFeedback.Time = EyeAloneNoFeedback.Y(1).Data';
EyeAloneNoFeedback.EyeX = EyeAloneNoFeedback.Y(2).Data';
EyeAloneNoFeedback.EyeY = EyeAloneNoFeedback.Y(3).Data';
EyeAloneNoFeedback.FixationTime = EyeAloneNoFeedback.Y(4).Data';
EyeAloneNoFeedback.FixationTimer = EyeAloneNoFeedback.Y(5).Data';
EyeAloneNoFeedback.HandX = EyeAloneNoFeedback.Y(6).Data';
EyeAloneNoFeedback.HandY = EyeAloneNoFeedback.Y(7).Data';
EyeAloneNoFeedback.HandZ = EyeAloneNoFeedback.Y(8).Data';
EyeAloneNoFeedback.ReachNumber = EyeAloneNoFeedback.Y(9).Data';
EyeAloneNoFeedback.TargetNumber = EyeAloneNoFeedback.Y(10).Data';
EyeAloneNoFeedback.TargetX = EyeAloneNoFeedback.Y(11).Data';
EyeAloneNoFeedback.TargetY = EyeAloneNoFeedback.Y(12).Data';

EyeHandFeedback.Time = EyeHandFeedback.Y(1).Data';
EyeHandFeedback.EyeX = EyeHandFeedback.Y(2).Data';
EyeHandFeedback.EyeY = EyeHandFeedback.Y(3).Data';
EyeHandFeedback.FixationTime = EyeHandFeedback.Y(4).Data';
EyeHandFeedback.FixationTimer = EyeHandFeedback.Y(5).Data';
EyeHandFeedback.HandX = EyeHandFeedback.Y(6).Data';
EyeHandFeedback.HandY = EyeHandFeedback.Y(7).Data';
EyeHandFeedback.HandZ = EyeHandFeedback.Y(8).Data';
EyeHandFeedback.ReachNumber = EyeHandFeedback.Y(9).Data';
EyeHandFeedback.TargetNumber = EyeHandFeedback.Y(10).Data';
EyeHandFeedback.TargetX = EyeHandFeedback.Y(11).Data';
EyeHandFeedback.TargetY = EyeHandFeedback.Y(12).Data';

EyeHandNoFeedback.Time = EyeHandNoFeedback.Y(1).Data';
EyeHandNoFeedback.EyeX = EyeHandNoFeedback.Y(2).Data';
EyeHandNoFeedback.EyeY = EyeHandNoFeedback.Y(3).Data';
EyeHandNoFeedback.FixationTime = EyeHandNoFeedback.Y(4).Data';
EyeHandNoFeedback.FixationTimer = EyeHandNoFeedback.Y(5).Data';
EyeHandNoFeedback.HandX = EyeHandNoFeedback.Y(6).Data';
EyeHandNoFeedback.HandY = EyeHandNoFeedback.Y(7).Data';
EyeHandNoFeedback.HandZ = EyeHandNoFeedback.Y(8).Data';
EyeHandNoFeedback.ReachNumber = EyeHandNoFeedback.Y(9).Data';
EyeHandNoFeedback.TargetNumber = EyeHandNoFeedback.Y(10).Data';
EyeHandNoFeedback.TargetX = EyeHandNoFeedback.Y(11).Data';
EyeHandNoFeedback.TargetY = EyeHandNoFeedback.Y(12).Data';