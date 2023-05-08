% This file runs all codes in order (test for grant)

clear; clc; close all

disp('loading data...')
loadData

disp('labeling data...')
labelData

disp('removing outliers...')
removeOutliers

disp('filtering data')
% Chose about 12 Hz for cutoff frequency
filterData

removeBlinkTrials
disp('removing trials with blinks...')

correctBias
disp('correcting bias...')

disp('plotting data...')
plotData_NBT_bias
% 
% close all

% disp('plotting reach Number 17...')
% plotReach(17)