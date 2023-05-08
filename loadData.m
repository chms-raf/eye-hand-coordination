% This file loads the data

selpath = uigetdir;

load(fullfile(selpath, 'EyeAloneFeedback.mat'))
load(fullfile(selpath, 'EyeAloneNoFeedback.mat'))
load(fullfile(selpath, 'EyeHandFeedback.mat'))
load(fullfile(selpath, 'EyeHandNoFeedback.mat'))

subject = selpath(length(selpath)-9:length(selpath));
