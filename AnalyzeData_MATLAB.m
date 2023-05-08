% This code analyzes data collected for the Eye-Hand Coordination Experiment
% Created by Jack Schultz, April 9th 2020
% Uses MATLAB's change detection and fixation estimation based on Pontus
% Olsson methods.

clear; 
clc;
close all

%%%%% Set filter parameters %%%%%
ds = 10;            % Downsample integer factor (10 for 100 Hz)
                    %                           (20 for 50 Hz)
radius = 110;       % Radius for calcuating fixations, < 2 seconds
                    %                           (200 for 100 Hz)
                    %                           (100 for 50 Hz)
vt = 10;            % Velocity threshold        (~10cm/s)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose subject file to open
loadData

% Log Command Window
str = string([subject, 'diaryM.txt']);
diary(str);

labelData

downsampleData

interpolateData

% Compute Fixations (Eye Alone Feedback)
changeIndicesX_EAF = findchangepts(EyeAloneFeedback.EyeX,'MaxNumChanges',78);
changeIndicesY_EAF = findchangepts(EyeAloneFeedback.EyeY,'MaxNumChanges',22);
changeIndices_EAF = sort([changeIndicesX_EAF; changeIndicesY_EAF]);
[fixations_EAF, fixationIndices_EAF] = computeFixations(EyeAloneFeedback.EyeX,EyeAloneFeedback.EyeY,changeIndices_EAF,radius);

% Compute Fixations (Eye Alone No Feedback)
changeIndicesX_EAnF = findchangepts(EyeAloneNoFeedback.EyeX,'MaxNumChanges',78);
changeIndicesY_EAnF = findchangepts(EyeAloneNoFeedback.EyeY,'MaxNumChanges',22);
changeIndices_EAnF = sort([changeIndicesX_EAnF; changeIndicesY_EAnF]);
[fixations_EAnF, fixationIndices_EAnF] = computeFixations(EyeAloneNoFeedback.EyeX,EyeAloneNoFeedback.EyeY,changeIndices_EAnF,radius);

% Compute Fixations (Eye Hand Feedback)
changeIndicesX_EHF = findchangepts(EyeHandFeedback.EyeX,'MaxNumChanges',78);
changeIndicesY_EHF = findchangepts(EyeHandFeedback.EyeY,'MaxNumChanges',22);
changeIndices_EHF = sort([changeIndicesX_EHF; changeIndicesY_EHF]);
[fixations_EHF, fixationIndices_EHF] = computeFixations(EyeHandFeedback.EyeX,EyeHandFeedback.EyeY,changeIndices_EHF,radius);

% Compute Fixations (Eye Hand No Feedback)
changeIndicesX_EHnF = findchangepts(EyeHandNoFeedback.EyeX,'MaxNumChanges',78);
changeIndicesY_EHnF = findchangepts(EyeHandNoFeedback.EyeY,'MaxNumChanges',22);
changeIndices_EHnF = sort([changeIndicesX_EHnF; changeIndicesY_EHnF]);
[fixations_EHnF, fixationIndices_EHnF] = computeFixations(EyeHandNoFeedback.EyeX,EyeHandNoFeedback.EyeY,changeIndices_EHnF,radius);

% Compute Hand Onsets and Reach Endpoints
[handOnsetsX_EHF, handOnsetsY_EHF, handOnsetIndicesX_EHF, handOnsetIndicesY_EHF] = computeHandOnsets(EyeHandFeedback.Time, EyeHandFeedback.HandX, EyeHandFeedback.HandY, vt);
[handOnsetsX_EHnF, handOnsetsY_EHnF, handOnsetIndicesX_EHnF, handOnsetIndicesY_EHnF] = computeHandOnsets(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandX, EyeHandNoFeedback.HandY, vt);

removeBlinkTrials
removeHandOnsets

% Find targets to compare fixations to
fixationTargets_EAF = [EyeAloneFeedback.TargetX(fixationIndices_EAF), EyeAloneFeedback.TargetY(fixationIndices_EAF)];
fixationTargets_EAnF = [EyeAloneNoFeedback.TargetX(fixationIndices_EAnF), EyeAloneNoFeedback.TargetY(fixationIndices_EAnF)];
fixationTargets_EHF = [EyeHandFeedback.TargetX(fixationIndices_EHF), EyeHandFeedback.TargetY(fixationIndices_EHF)];
fixationTargets_EHnF = [EyeHandNoFeedback.TargetX(fixationIndices_EHnF), EyeHandNoFeedback.TargetY(fixationIndices_EHnF)];

fixationTargetsHandX_EHF = EyeHandFeedback.TargetX(handOnsetIndicesX_EHF);
fixationTargetsHandY_EHF = EyeHandFeedback.TargetY(handOnsetIndicesY_EHF);
fixationTargetsHandX_EHnF = EyeHandNoFeedback.TargetX(handOnsetIndicesX_EHnF);
fixationTargetsHandY_EHnF = EyeHandNoFeedback.TargetY(handOnsetIndicesY_EHnF);

plotData

%computeDelays

computeError

handOnsetIndices_EHF = [handOnsetIndicesX_EHF; handOnsetIndicesY_EHF];
handOnsetIndices_EHF = sort(handOnsetIndices_EHF);

handOnsetIndices_EHnF = [handOnsetIndicesX_EHnF; handOnsetIndicesY_EHnF];
handOnsetIndices_EHnF = sort(handOnsetIndices_EHnF);

% Figure
str = sprintf('Eye Fixations: %0.0f', length(fixations_EAF));

f(5) = figure('Name', subject);
subplot(2,2,1)
plot(EyeAloneFeedback.EyeX, EyeAloneFeedback.EyeY,'r')
set(gca, 'YDir','reverse')
text(160, 150, str, 'FontSize', 10);
hold on
plot(fixations_EAF(:,1),fixations_EAF(:,2),'x','MarkerSize',12,'LineWidth',2)
drawTargets
axis([100 1110 100 651])
title('Gaze Data with Fixations: Eye Alone Feedback')
xlabel('x-direction (mm)')
ylabel('y-direction (mm)')

str = sprintf('Eye Fixations: %0.0f', length(fixations_EAnF));

subplot(2,2,2)
p(1) = plot(EyeAloneNoFeedback.EyeX, EyeAloneNoFeedback.EyeY,'r');
set(gca, 'YDir','reverse')
text(160, 150, str, 'FontSize', 10);
hold on
p(2) = plot(fixations_EAnF(:,1),fixations_EAnF(:,2),'x','MarkerSize',12,'LineWidth',2);
drawTargets
axis([100 1110 100 651])
title('Gaze Data with Fixations: Eye Alone No Feedback')
xlabel('x-direction (mm)')
ylabel('y-direction (mm)')
legend([p(1), p(2), h(1)],'Raw Gaze Data', 'Gaze Fixations', 'Targets')

str1 = sprintf('Eye Fixations: %0.0f', length(fixations_EHF));
str2 = sprintf('Hand Fixations: %0.0f', length(handOnsetIndicesX_EHF)+length(handOnsetIndicesY_EHF));

subplot(2,2,3)
plot(EyeHandFeedback.EyeX, EyeHandFeedback.EyeY,'r')
set(gca, 'YDir','reverse')
text(160, 150, str1, 'FontSize', 10);
text(160, 180, str2, 'FontSize', 10);
hold on
plot(EyeHandFeedback.HandX, EyeHandFeedback.HandY,'c--')
plot(fixations_EHF(:,1),fixations_EHF(:,2),'x','MarkerSize',12,'LineWidth',2)
plot(EyeHandFeedback.HandX(handOnsetIndices_EHF), EyeHandFeedback.HandY(handOnsetIndices_EHF),'gx','MarkerSize',12,'LineWidth',2)
drawTargets
axis([100 1110 100 651])
title('Gaze Data with Fixations: Eye Hand Feedback')
xlabel('x-direction (mm)')
ylabel('y-direction (mm)')

str1 = sprintf('Eye Fixations: %0.0f', length(fixations_EHnF));
str2 = sprintf('Hand Fixations: %0.0f', length(handOnsetIndicesX_EHnF)+length(handOnsetIndicesY_EHnF));

subplot(2,2,4)
p(1) = plot(EyeHandNoFeedback.EyeX, EyeHandNoFeedback.EyeY,'r');
set(gca, 'YDir','reverse')
text(160, 150, str1, 'FontSize', 10);
text(160, 180, str2, 'FontSize', 10);
hold on
p(2) = plot(EyeHandNoFeedback.HandX, EyeHandNoFeedback.HandY,'c--');
p(3) = plot(fixations_EHnF(:,1),fixations_EHnF(:,2),'x','MarkerSize',12,'LineWidth',2);
p(4) = plot(EyeHandNoFeedback.HandX(handOnsetIndices_EHnF), EyeHandNoFeedback.HandY(handOnsetIndices_EHnF),'gx','MarkerSize',12,'LineWidth',2);
drawTargets
axis([100 1110 100 651])
title('Gaze Data with Fixations: Eye Hand No Feedback')
xlabel('x-direction (mm)')
ylabel('y-direction (mm)')
legend([p(1), p(2), p(3), p(4), h(1)],'Raw Gaze Data', 'Raw Hand Data', 'Gaze Fixations', 'Hand Fixations', 'Targets')

% Print Output
fprintf('Eye-Hand Coordination Experiment, %s:\n', subject)
fprintf('-----------------------------\n');
fprintf('Parameters:\n')
fprintf('Sampling Frequency = %i Hz\n', 1000/ds)
fprintf('            radius = %i mm\n', radius);
fprintf('Velocity Threshold =  %i cm/s\n', vt);
fprintf('-----------------------------\n');
fprintf('Eye Alone Feedback (Eye): Error of all reaches = %f %c %f\n', errorAllTargets_EAF, char(177), stdAllTargets_EAF)
fprintf('Eye Alone No Feedback (Eye): Error of all reaches = %f %c %f\n', errorAllTargets_EAnF, char(177), stdAllTargets_EAnF)
fprintf('Eye Hand Feedback (Eye): Error of all reaches = %f %c %f\n', errorAllTargets_EHF, char(177), stdAllTargets_EHF)
fprintf('Eye Hand Feedback (Hand): Error of all reaches = %f %c %f\n', errorAllTargetsHand_EHF, char(177), stdAllTargetsHand_EHF)
fprintf('Eye Hand No Feedback (Eye): Error of all reaches = %f %c %f\n', errorAllTargets_EHnF, char(177), stdAllTargets_EHnF)
fprintf('Eye Hand No Feedback (Hand): Error of all reaches = %f %c %f\n', errorAllTargetsHand_EHnF, char(177), stdAllTargetsHand_EHnF)
fprintf('Error of all trial conditions (Eye) = %f %c %f\n', errorAllConditions, char(177), stdAllConditions)
fprintf('Error of all trial conditions (Hand) = %f %c %f\n', errorAllConditionsHand, char(177), stdAllConditionsHand)
fprintf('Error of Feedback conditions (Eye) = %f %c %f\n', errorFeedback, char(177), stdFeedback)
fprintf('Error of Feedback conditions (Hand) = %f %c %f\n', errorFeedbackHand, char(177), stdFeedbackHand)
fprintf('Error of No Feedback conditions (Eye) = %f %c %f\n', errorNoFeedback, char(177), stdNoFeedback)
fprintf('Error of No Feedback conditions (Hand) = %f %c %f\n', errorNoFeedbackHand, char(177), stdNoFeedbackHand)

%% Save variables to file
s = string([subject, 'fixationFilterM.mat']);
save(s,'changeIndices_EAF','changeIndices_EAnF','changeIndices_EHF','changeIndices_EHnF',...
     'changeIndicesX_EAF','changeIndicesX_EAnF','changeIndicesX_EHF','changeIndicesX_EHnF',...
     'changeIndicesY_EAF','changeIndicesY_EAnF','changeIndicesY_EHF','changeIndicesY_EHnF',...
     'ds','error_EAF','error_EAnF','error_EHF','error_EHnF','errorAllConditions', 'errorAllConditionsHand',...
     'errorAllTargets_EAF','errorAllTargets_EAnF','errorAllTargets_EHF','errorAllTargets_EHnF','errorAllTargetsHand_EHF','errorAllTargetsHand_EHnF',...
     'errorFeedback', 'errorFeedbackHand', 'errorHandX_EHF', 'errorHandX_EHnF', 'errorHandY_EHF', 'errorHandY_EHnF', 'errorNoFeedback', 'errorNoFeedbackHand',...
     'EyeAloneFeedback','EyeAloneNoFeedback','EyeHandFeedback','EyeHandNoFeedback',...
     'fixationIndices_EAF','fixationIndices_EAnF','fixationIndices_EHF','fixationIndices_EHnF',...
     'fixations_EAF','fixations_EAnF','fixations_EHF','fixations_EHnF',...
     'fixationTargets_EAF','fixationTargets_EAnF','fixationTargets_EHF','fixationTargets_EHnF',...
     'fixationTargetsHandX_EHF', 'fixationTargetsHandX_EHnF', 'fixationTargetsHandY_EHF', 'fixationTargetsHandY_EHnF',...
     'handOnsetIndices_EHF', 'handOnsetIndices_EHnF', 'handOnsetIndicesX_EHF', 'handOnsetIndicesX_EHnF', 'handOnsetIndicesY_EHF', 'handOnsetIndicesY_EHnF',...
     'handOnsetsX_EHF', 'handOnsetsX_EHnF', 'handOnsetsY_EHF', 'handOnsetsY_EHnF',...
     'radius', 'stdAllConditions', 'stdAllConditionsHand', 'stdAllTargets_EAF', 'stdAllTargets_EAnF', 'stdAllTargets_EHF','stdAllTargets_EHnF','stdAllTargetsHand_EHF', 'stdAllTargetsHand_EHnF',...
     'stdFeedback', 'stdFeedbackHand', 'stdNoFeedback', 'stdNoFeedbackHand', 'subject', 'vt');
 
s = string([subject, 'fixationFilterFigM.fig']);
savefig(f,s)

diary off