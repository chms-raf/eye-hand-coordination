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

global EyeHandNoFeedback

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