%% This assembles vectors to be used in statistics
% Only run one section at a time

selpath = uigetdir;
subject = selpath(length(selpath)-9:length(selpath));
str = string([subject, 'fixationFilterM.mat']);
load(fullfile(selpath, str))

%% Run this section the first time through
ERROR = [error_EAF; error_EAnF; error_EHF; error_EHnF];
ERRORHAND = [errorHand_EHF; errorHand_EHnF];

TRIALCONDITION = repmat('EAF ',length(error_EAF),1);
TRIALCONDITION = [TRIALCONDITION; repmat('EAnF',length(error_EAnF),1)];
TRIALCONDITION = [TRIALCONDITION; repmat('EHF ',length(error_EHF),1)];
TRIALCONDITION = [TRIALCONDITION; repmat('EHnF',length(error_EHnF),1)];
TRIALCONDITIONHAND = repmat('EHF ',length(errorHand_EHF),1);
TRIALCONDITIONHAND = [TRIALCONDITIONHAND; repmat('EHnF',length(errorHand_EHnF),1)];


fixationTargetNumbers_EAF = EyeAloneFeedback.TargetNumber(fixationIndices_EAF);
fixationTargetNumbers_EAnF = EyeAloneNoFeedback.TargetNumber(fixationIndices_EAnF);
fixationTargetNumbers_EHF = EyeHandFeedback.TargetNumber(fixationIndices_EHF);
fixationTargetNumbers_EHnF = EyeHandNoFeedback.TargetNumber(fixationIndices_EHnF);
fixationTargetNumbersHand_EHF = EyeHandFeedback.TargetNumber(fixationIndicesHand_EHF);
fixationTargetNumbersHand_EHnF = EyeHandNoFeedback.TargetNumber(fixationIndicesHand_EHnF);

TARGETS = num2str(fixationTargetNumbers_EAF);
TARGETS = [TARGETS; num2str(fixationTargetNumbers_EAnF)];
TARGETS = [TARGETS; num2str(fixationTargetNumbers_EHF)];
TARGETS = [TARGETS; num2str(fixationTargetNumbers_EHnF)];
TARGETSHAND = num2str(fixationTargetNumbersHand_EHF);
TARGETSHAND = [TARGETSHAND; num2str(fixationTargetNumbersHand_EHnF)];

l = length(error_EAF)+length(error_EAnF)+length(error_EHF)+length(error_EHnF);
lHand = length(errorHand_EHF)+length(errorHand_EHnF);

SUBJECT = repmat(subject, l, 1);
SUBJECTHAND = repmat(subject, lHand, 1);

save('statVars', 'ERROR', 'ERRORHAND','TRIALCONDITION', 'TRIALCONDITIONHAND', 'TARGETS', 'TARGETSHAND', 'SUBJECT', 'SUBJECTHAND');

%% Run this section after first time through
% Create vector of fixation errors
ERROR = [ERROR; error_EAF; error_EAnF; error_EHF; error_EHnF];
ERRORHAND = [ERRORHAND; errorHand_EHF; errorHand_EHnF];

TRIALCONDITION = [TRIALCONDITION; repmat('EAF ',length(error_EAF),1)];
TRIALCONDITION = [TRIALCONDITION; repmat('EAnF',length(error_EAnF),1)];
TRIALCONDITION = [TRIALCONDITION; repmat('EHF ',length(error_EHF),1)];
TRIALCONDITION = [TRIALCONDITION; repmat('EHnF',length(error_EHnF),1)];
TRIALCONDITIONHAND = [TRIALCONDITIONHAND; repmat('EHF ',length(errorHand_EHF),1)];
TRIALCONDITIONHAND = [TRIALCONDITIONHAND; repmat('EHnF',length(errorHand_EHnF),1)];

fixationTargetNumbers_EAF = EyeAloneFeedback.TargetNumber(fixationIndices_EAF);
fixationTargetNumbers_EAnF = EyeAloneNoFeedback.TargetNumber(fixationIndices_EAnF);
fixationTargetNumbers_EHF = EyeHandFeedback.TargetNumber(fixationIndices_EHF);
fixationTargetNumbers_EHnF = EyeHandNoFeedback.TargetNumber(fixationIndices_EHnF);
fixationTargetNumbersHand_EHF = EyeHandFeedback.TargetNumber(fixationIndicesHand_EHF);
fixationTargetNumbersHand_EHnF = EyeHandNoFeedback.TargetNumber(fixationIndicesHand_EHnF);

TARGETS = [TARGETS; num2str(fixationTargetNumbers_EAF)];
TARGETS = [TARGETS; num2str(fixationTargetNumbers_EAnF)];
TARGETS = [TARGETS; num2str(fixationTargetNumbers_EHF)];
TARGETS = [TARGETS; num2str(fixationTargetNumbers_EHnF)];
TARGETSHAND = [TARGETSHAND; num2str(fixationTargetNumbersHand_EHF)];
TARGETSHAND = [TARGETSHAND; num2str(fixationTargetNumbersHand_EHnF)];

l = length(error_EAF)+length(error_EAnF)+length(error_EHF)+length(error_EHnF);
lHand = length(errorHand_EHF)+length(errorHand_EHnF);

SUBJECT = [SUBJECT; repmat(subject, l, 1)];
SUBJECTHAND = [SUBJECTHAND; repmat(subject, lHand, 1)];

save('statVarsANOVA3', 'ERROR', 'ERRORHAND','TRIALCONDITION', 'TRIALCONDITIONHAND', 'TARGETS', 'TARGETSHAND', 'SUBJECT', 'SUBJECTHAND');