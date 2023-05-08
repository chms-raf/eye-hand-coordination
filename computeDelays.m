% This code computes the eye and hand delays
handDelayX_EHF = EyeHandFeedback.Time(handOnsetIndicesX_EHF) - handOnsetTargetsX_EHF;
handDelayY_EHF = EyeHandFeedback.Time(handOnsetIndicesY_EHF) - handOnsetTargetsY_EHF;
handDelayX_EHnF = EyeHandNoFeedback.Time(handOnsetIndicesX_EHnF) - handOnsetTargetsX_EHnF;
handDelayY_EHnF = EyeHandNoFeedback.Time(handOnsetIndicesY_EHnF) - handOnsetTargetsY_EHnF;

% Eye Hand Feedback
for i = 1:2:length(handDelayX_EHF)
    if i == 1
        handOnsetAverageX_EHF = handDelayX_EHF(i,1);
        handOffsetAverageX_EHF = handDelayX_EHF(i+1);
    else
        handOnsetAverageX_EHF = [handOnsetAverageX_EHF; handDelayX_EHF(i,1)];
        handOffsetAverageX_EHF = [handOffsetAverageX_EHF; handDelayX_EHF(i+1,1)];
    end
end

handOnsetStdX_EHF = std(handOnsetAverageX_EHF);
handOffsetStdX_EHF = std(handOffsetAverageX_EHF);
handOnsetAverageX_EHF = mean(handOnsetAverageX_EHF);
handOffsetAverageX_EHF = mean(handOffsetAverageX_EHF);

for i = 1:2:length(handDelayY_EHF)
    if i == 1
        handOnsetAverageY_EHF = handDelayY_EHF(i,1);
        handOffsetAverageY_EHF = handDelayY_EHF(i+1);
    else
        handOnsetAverageY_EHF = [handOnsetAverageY_EHF; handDelayY_EHF(i,1)];
        handOffsetAverageY_EHF = [handOffsetAverageY_EHF; handDelayY_EHF(i+1,1)];
    end
end

handOnsetStdY_EHF = std(handOnsetAverageY_EHF);
handOffsetStdY_EHF = std(handOffsetAverageY_EHF);
handOnsetAverageY_EHF = mean(handOnsetAverageY_EHF);
handOffsetAverageY_EHF = mean(handOffsetAverageY_EHF);

% Eye Hand No Feedback
for i = 1:2:length(handDelayX_EHnF)
    if i == 1
        handOnsetAverageX_EHnF = handDelayX_EHnF(i,1);
        handOffsetAverageX_EHnF = handDelayX_EHnF(i+1);
    else
        handOnsetAverageX_EHnF = [handOnsetAverageX_EHnF; handDelayX_EHnF(i,1)];
        handOffsetAverageX_EHnF = [handOffsetAverageX_EHnF; handDelayX_EHnF(i+1,1)];
    end
end

handOnsetStdX_EHnF = std(handOnsetAverageX_EHnF);
handOffsetStdX_EHnF = std(handOffsetAverageX_EHnF);
handOnsetAverageX_EHnF = mean(handOnsetAverageX_EHnF);
handOffsetAverageX_EHnF = mean(handOffsetAverageX_EHnF);

for i = 1:2:length(handDelayY_EHnF)
    if i == 1
        handOnsetAverageY_EHnF = handDelayY_EHnF(i,1);
        handOffsetAverageY_EHnF = handDelayY_EHnF(i+1);
    else
        handOnsetAverageY_EHnF = [handOnsetAverageY_EHnF; handDelayY_EHnF(i,1)];
        handOffsetAverageY_EHnF = [handOffsetAverageY_EHnF; handDelayY_EHnF(i+1,1)];
    end
end

handOnsetStdY_EHnF = std(handOnsetAverageY_EHnF);
handOffsetStdY_EHnF = std(handOffsetAverageY_EHnF);
handOnsetAverageY_EHnF = mean(handOnsetAverageY_EHnF);
handOffsetAverageY_EHnF = mean(handOffsetAverageY_EHnF);