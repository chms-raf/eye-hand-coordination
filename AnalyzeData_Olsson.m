% This code analyzes data collected for the Eye-Hand Coordination Experiment
% Created by Jack Schultz, April 9th 2020
% Uses a fixation filter described by Pontus Olsson

clear; 
clc;
close all

%%%%% Set filter parameters %%%%%
ds = 10;            % Downsample integer factor (10 for 100 Hz)
r = 8;              % Averaging window for computing the difference vector
                    % Set r to equal the equivalent of 80ms of data
                    %   For   50Hz,  r = 4
                    %   For  100Hz,  r = 8
                    %   For 1000Hz,  r = 80
h = 20;             % Window for removing peaks, higher for noisy data (~20)
threshold = 70;    % Threshold for deciding what peaks to use, should around 
                    %   smallest amplitude saccade (~100)
radius = 70;       % Radius for calcuating fixations, should be same as threshold (~100)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose subject file to open
loadData

% Log Command Window
str = string([subject, 'diary.txt']);
diary(str);

labelData

downsampleData

%%%%% Fixation Filter Algorithm %%%%%

% Step 1: Interpolate missing data
interpolateData

% Step 1.5: filter data
%filterData

% Step 2: Calculate the difference vector
% d = computeDiffVector(time, xData, yData, r);
d_EAF = computeDiffVector(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX, EyeAloneFeedback.EyeY, r);
d_EAnF = computeDiffVector(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeX, EyeAloneNoFeedback.EyeY, r);
d_EHF = computeDiffVector(EyeHandFeedback.Time, EyeHandFeedback.EyeX, EyeHandFeedback.EyeY, r);
d_EHnF = computeDiffVector(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeX, EyeHandNoFeedback.EyeY, r);

% Step 3: Find peaks in the difference vector
% peak = findPeaks(time,d);
peak_EAF = findPeaks(EyeAloneFeedback.Time,d_EAF);
peak_EAnF = findPeaks(EyeAloneNoFeedback.Time,d_EAnF);
peak_EHF = findPeaks(EyeHandFeedback.Time,d_EHF);
peak_EHnF = findPeaks(EyeHandNoFeedback.Time,d_EHnF);

% str = 'All Peaks: ';
% plotPeaks

% Step 4: Remove peaks that are too close to each other in time domain
% peak = removePeaks(time,peak,h,d);
%   str = 'y' to plot peaks
%   str = 'n' to skip plotting
peak_EAF = removePeaks(EyeAloneFeedback.Time,peak_EAF,h);
peak_EAnF = removePeaks(EyeAloneNoFeedback.Time,peak_EAnF,h);
peak_EHF = removePeaks(EyeHandFeedback.Time,peak_EHF,h);
peak_EHnF = removePeaks(EyeHandNoFeedback.Time,peak_EHnF,h);

str = 'Peaks After Removal/Merging: ';
plotPeaks

% Step 5: Create a list with peak indices
% peakIndices = createList(time,threshold,peak)
peakIndices_EAF = createList(EyeAloneFeedback.Time,threshold,peak_EAF);
peakIndices_EAnF = createList(EyeAloneNoFeedback.Time,threshold,peak_EAnF);
peakIndices_EHF = createList(EyeHandFeedback.Time,threshold,peak_EHF);
peakIndices_EHnF = createList(EyeHandNoFeedback.Time,threshold,peak_EHnF);

% Step 6: Estimate the spatial positions of the fixations
% [fixations, fixationIndices] = computeFixations(xData,yData,peakIndices,radius,str)
[fixations_EAF, fixationIndices_EAF] = computeFixations(EyeAloneFeedback.EyeX, EyeAloneFeedback.EyeY, peakIndices_EAF, radius);
[fixations_EAnF, fixationIndices_EAnF] = computeFixations(EyeAloneNoFeedback.EyeX, EyeAloneNoFeedback.EyeY, peakIndices_EAnF, radius);
[fixations_EHF, fixationIndices_EHF] = computeFixations(EyeHandFeedback.EyeX, EyeHandFeedback.EyeY, peakIndices_EHF, radius);
[fixations_EHnF, fixationIndices_EHnF] = computeFixations(EyeHandNoFeedback.EyeX, EyeHandNoFeedback.EyeY, peakIndices_EHnF, radius);

plotFixations

fixationTargets_EAF = [EyeAloneFeedback.TargetX(fixationIndices_EAF), EyeAloneFeedback.TargetY(fixationIndices_EAF)];
fixationTargets_EAnF = [EyeAloneNoFeedback.TargetX(fixationIndices_EAnF), EyeAloneNoFeedback.TargetY(fixationIndices_EAnF)];
fixationTargets_EHF = [EyeHandFeedback.TargetX(fixationIndices_EHF), EyeHandFeedback.TargetY(fixationIndices_EHF)];
fixationTargets_EHnF = [EyeHandNoFeedback.TargetX(fixationIndices_EHnF), EyeHandNoFeedback.TargetY(fixationIndices_EHnF)];

computeError

% Print Output
fprintf('Eye-Hand Coordination Experiment, %s:\n', subject)
fprintf('------------------------\n');
fprintf('Filter Parameters:\n')
fprintf('     r =      %i\n', r);
fprintf('     h =      %i\n', h);
fprintf('     th =     %i\n', threshold);
fprintf('     radius = %i\n', radius);
fprintf('------------------------\n');
fprintf('Eye Alone Feedback: Accuracy of all reaches = %f %c %f\n', errorAllTargets_EAF, char(177), stdAllTargets_EAF)
fprintf('Eye Alone No Feedback: Accuracy of all reaches = %f %c %f\n', errorAllTargets_EAnF, char(177), stdAllTargets_EAnF)
fprintf('Eye Hand Feedback: Accuracy of all reaches = %f %c %f\n', errorAllTargets_EHF, char(177), stdAllTargets_EHF)
fprintf('Eye Hand No Feedback: Accuracy of all reaches = %f %c %f\n', errorAllTargets_EHnF, char(177), stdAllTargets_EHnF)

% Save variables to file
s = string([subject, 'fixationFilter.mat']);
save(s,'d_EAF','d_EAnF','d_EHF','d_EHnF','ds','error_EAF','error_EAnF','error_EHF','error_EHnF',...
     'errorAllTargets_EAF','errorAllTargets_EAnF','errorAllTargets_EHF','errorAllTargets_EHnF',...
     'stdAllTargets_EAF', 'stdAllTargets_EAnF', 'stdAllTargets_EHnF', 'stdAllTargets_EHnF',...
     'EyeAloneFeedback','EyeAloneNoFeedback','EyeHandFeedback','EyeHandNoFeedback',...
     'fixationIndices_EAF','fixationIndices_EAnF','fixationIndices_EHF','fixationIndices_EHnF',...
     'fixations_EAF','fixations_EAnF','fixations_EHF','fixations_EHnF',...
     'fixationTargets_EAF','fixationTargets_EAnF','fixationTargets_EHF','fixationTargets_EHnF',...
     'h','peak_EAF','peak_EAnF','peak_EHF','peak_EHnF','peakIndices_EAF','peakIndices_EAnF',...
     'peakIndices_EHF','peakIndices_EHnF','r','radius','subject','threshold');
 
s = string([subject, 'fixationFilterFig.fig']);
savefig(f,s)

diary off