%% This assembles vectors to be used in statistics
% Only run one section at a time

selpath = uigetdir;
subject = selpath(length(selpath)-9:length(selpath));
str = string([subject, 'fixationFilterM.mat']);
load(fullfile(selpath, str))

%% Run this section the first time through
ERROR = [errorAllTargets_EAF, errorAllTargets_EAnF, errorAllTargets_EHF, errorAllTargets_EHnF];
ERRORHAND = [errorAllTargetsHand_EHF, errorAllTargetsHand_EHnF];

save('statvar', 'ERROR', 'ERRORHAND');

%% Run this section after first time through
% Create vector of fixation errors
ERROR = [ERROR; errorAllTargets_EAF, errorAllTargets_EAnF, errorAllTargets_EHF, errorAllTargets_EHnF];
ERRORHAND = [ERRORHAND; errorAllTargetsHand_EHF, errorAllTargetsHand_EHnF];

save('statvar', 'ERROR', 'ERRORHAND');