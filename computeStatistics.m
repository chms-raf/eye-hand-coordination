% This code performs 3-way ANOVA

clear; clc; close all; close all hidden

load statVars

varnames = {'Condition';'Target';'Subject'};

% Create individual error vectors
for i = 1:1:length(TRIALCONDITION)
    temp(i,1) = strcmp(TRIALCONDITION(i,:),'EAF ');
end
error_EAF = ERROR(temp);
clear temp

for i = 1:1:length(TRIALCONDITION)
    temp(i,1) = strcmp(TRIALCONDITION(i,:),'EAnF');
end
error_EAnF = ERROR(temp);
clear temp

for i = 1:1:length(TRIALCONDITION)
    temp(i,1) = strcmp(TRIALCONDITION(i,:),'EHF ');
end
error_EHF = ERROR(temp);
clear temp

for i = 1:1:length(TRIALCONDITIONHAND)
    temp(i,1) = strcmp(TRIALCONDITIONHAND(i,:),'EHF ');
end
errorHand_EHF = ERRORHAND(temp);
clear temp

for i = 1:1:length(TRIALCONDITION)
    temp(i,1) = strcmp(TRIALCONDITION(i,:),'EHnF');
end
error_EHnF = ERROR(temp);
clear temp

for i = 1:1:length(TRIALCONDITIONHAND)
    temp(i,1) = strcmp(TRIALCONDITIONHAND(i,:),'EHnF');
end
errorHand_EHnF = ERRORHAND(temp);
clear temp

error_F = [error_EAF; error_EHF];
error_nF = [error_EAnF; error_EHnF];
errorHand_F = errorHand_EHF;
errorHand_nF = errorHand_EHnF;
error_AllConditions = [error_EAF; error_EAnF; error_EHF; error_EHnF];
errorHand_AllConditions = [errorHand_EHF; errorHand_EHnF];

% Individual error means and standard deviations
mean_error_EAF = mean(error_EAF);
mean_error_EAnF = mean(error_EAnF);
mean_error_EHF = mean(error_EHF);
mean_error_EHnF = mean(error_EHnF);
mean_errorHand_EHF = mean(errorHand_EHF);
mean_errorHand_EHnF = mean(errorHand_EHnF);
mean_error_F = mean(error_F);
mean_error_nF = mean(error_nF);
mean_errorHand_F = mean(errorHand_F);
mean_errorHand_nF = mean(errorHand_nF);
mean_error_AllConditions = mean(error_AllConditions);
mean_errorHand_AllConditions = mean(errorHand_AllConditions);

std_error_EAF = std(error_EAF)/sqrt(length(error_EAF));
std_error_EAnF = std(error_EAnF)/sqrt(length(error_EAnF));
std_error_EHF = std(error_EHF)/sqrt(length(error_EHF));
std_error_EHnF = std(error_EHnF)/sqrt(length(error_EHnF));
std_errorHand_EHF = std(errorHand_EHF)/sqrt(length(errorHand_EHF));
std_errorHand_EHnF = std(errorHand_EHnF)/sqrt(length(errorHand_EHnF));
std_error_F = std(error_F)/sqrt(length(error_F));
std_error_nF = std(error_nF)/sqrt(length(error_nF));
std_errorHand_F = std(errorHand_F)/sqrt(length(errorHand_F));
std_errorHand_nF = std(errorHand_nF)/sqrt(length(errorHand_nF));
std_error_AllConditions = std(error_AllConditions)/sqrt(length(error_AllConditions));
std_errorHand_AllConditions = std(errorHand_AllConditions)/sqrt(length(errorHand_AllConditions));

%% Three way ANOVA to test interactions between Eye Fixation Error and:
%   - Condition
%   - Target
%   - Subject

% Fit the full model, requesting up to three-way interactions and Type 3 sums-of-squares
[p,tbl2,stats,terms] = anovan(ERROR,{TRIALCONDITION TARGETS SUBJECT},3,3,varnames);

% Perform multiple comparisons for Trial Condition and Targets.
figure
[c,m,h,nms] = multcompare(stats,'Dimension',1);
title('Condition')

[nms num2cell(m)]

% figure
% multcompare(stats,'Dimension',2);
% title('Target')
% 
% figure
% multcompare(stats,'Dimension',3);
% title('Subject')
% 
% figure
% multcompare(stats,'Dimension',[1,2]);
% title('Condition * Target')
% 
% figure
% multcompare(stats,'Dimension',[1,3]);
% title('Condition * Subject')
% 
% figure
% multcompare(stats,'Dimension',[2,3]);
% title('Target * Subject')
% 
% figure
% multcompare(stats,'Dimension',[1,2,3]);
% title('Condition * Target * Subject')

%% Three way ANOVA to test interactions between Hand Fixation Error and:
%   - Condition
%   - Target
%   - Subject

% Fit the full model, requesting up to three-way interactions and Type 3 sums-of-squares
[p,tbl2,stats,terms] = anovan(ERRORHAND,{TRIALCONDITIONHAND TARGETSHAND SUBJECTHAND},3,3,varnames);

% Perform multiple comparisons for Trial Condition and Targets.
figure
[c,m,h,nms] = multcompare(stats,'Dimension',1);
title('Condition')

[nms num2cell(m)]

% figure
% multcompare(stats,'Dimension',2);
% title('Target')
% 
% figure
% multcompare(stats,'Dimension',3);
% title('Subject')
% 
% figure
% multcompare(stats,'Dimension',[1,2]);
% title('Condition * Target')
% 
% figure
% multcompare(stats,'Dimension',[1,3]);
% title('Condition * Subject')
% 
% figure
% multcompare(stats,'Dimension',[2,3]);
% title('Target * Subject')
% 
% figure
% multcompare(stats,'Dimension',[1,2,3]);
% title('Condition * Target * Subject')

%% One way Anova for Trial Condition
[p,t,stats] = anova1(ERROR,TRIALCONDITION,'off');
[c2,m2,h2,nms2] = multcompare(stats);

[nms2 num2cell(m2)]

%% Don't need to do below here anymore because all interactions are full rank
% ------------------------------------------------------------------------
% [tbl,chi2,p,factorvals] = crosstab(TRIALCONDITION, TARGETS, SUBJECT);
% disp(tbl)
% 
% % Notes:
% %   - Right now, there are zeros in tbl(2,6,6) and (4,6,6), meaning there
% %     are no fixations corresponding to target 2 for subject006 in both the
% %     EAnF and EHnF trial conditions. If you plot the fixations, this does
% %     seem to be the case. Changing filter parameters could solve this.
% 
% % Examine only two-way interactions
% [p,tbl2,stats,terms] = anovan(ERROR,{TRIALCONDITION TARGETS SUBJECT},2,3,varnames);
% % Condition*Target and Target*Subject iteractions are not significant,
% % we can omit them and pool their effects into the error term.
% terms([4 6],:) = [];
% [~,~,stats] = anovan(ERROR,{TRIALCONDITION TARGETS SUBJECT},terms,3,varnames);
% 
% % Now these results indicate that fixation error is related to all three
% % factors, and that the effect of the subject depends on the target number.
% 
% % Perform multiple comparisons for Trial Condition and Targets.
% results1 = multcompare(stats,'Dimension',[1,2]);
% results2 = multcompare(stats,'Dimension',[1,3]);
% results3 = multcompare(stats,'Dimension',[2,3]);