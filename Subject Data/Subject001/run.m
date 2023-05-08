% This file runs all codes in order

clear; clc; close all

loadData
disp('loading data...')

labelData
disp('labeling data...')

removeOutliers
disp('removing outliers...')

% splitReaches
% disp('splitting data into specific reaches')
% 
% plotData
% disp('plotting data...')
% disp('done.')