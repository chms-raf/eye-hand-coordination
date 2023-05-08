% This file runs all codes in order

clear; clc; close all

disp('loading data...')
loadData

disp('labeling data...')
labelData

disp('removing outliers...')
removeOutliers

disp('filtering...')
filterBlinks

removeBlinkTrials
disp('removing trials with blinks')

% correctBias
% disp('correcting bias...')

% plotData_NBT
% disp('plotting data after blinks were removed...')

disp('Hit enter to calculate accuracy')
pause

clc

calcAccuracy

% disp('Hit Enter to continue')
% pause

% close all

% plotData
% disp('plotting data...')