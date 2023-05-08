% This code computes the error

error_EAF = zeros(size(fixationIndices_EAF));
for i = 1:1:length(fixationIndices_EAF)
    error_EAF(i,1) = sqrt((fixations_EAF(i,1) - fixationTargets_EAF(i,1))^2 + (fixations_EAF(i,2) - fixationTargets_EAF(i,2))^2);
end

error_EAnF = zeros(size(fixationIndices_EAnF));
for i = 1:1:length(fixationIndices_EAnF)
    error_EAnF(i,1) = sqrt((fixations_EAnF(i,1) - fixationTargets_EAnF(i,1))^2 + (fixations_EAnF(i,2) - fixationTargets_EAnF(i,2))^2);
end

error_EHF = zeros(size(fixationIndices_EHF));
for i = 1:1:length(fixationIndices_EHF)
    error_EHF(i,1) = sqrt((fixations_EHF(i,1) - fixationTargets_EHF(i,1))^2 + (fixations_EHF(i,2) - fixationTargets_EHF(i,2))^2);
end

errorHandX_EHF = zeros(size(handOnsetIndicesX_EHF));
for i = 1:1:length(handOnsetIndicesX_EHF)
    errorHandX_EHF(i,1) = sqrt((handOnsetsX_EHF(i,1) - fixationTargetsHandX_EHF(i,1))^2);
end

errorHandY_EHF = zeros(size(handOnsetIndicesY_EHF));
for i = 1:1:length(handOnsetIndicesY_EHF)
    errorHandY_EHF(i,1) = sqrt((handOnsetsY_EHF(i,1) - fixationTargetsHandY_EHF(i,1))^2);
end

error_EHnF = zeros(size(fixationIndices_EHnF));
for i = 1:1:length(fixationIndices_EHnF)
    error_EHnF(i,1) = sqrt((fixations_EHnF(i,1) - fixationTargets_EHnF(i,1))^2 + (fixations_EHnF(i,2) - fixationTargets_EHnF(i,2))^2);
end

errorHandX_EHnF = zeros(size(handOnsetIndicesX_EHnF));
for i = 1:1:length(handOnsetIndicesX_EHnF)
    errorHandX_EHnF(i,1) = sqrt((handOnsetsX_EHnF(i,1) - fixationTargetsHandX_EHnF(i,1))^2);
end

errorHandY_EHnF = zeros(size(handOnsetIndicesY_EHnF));
for i = 1:1:length(handOnsetIndicesY_EHnF)
    errorHandY_EHnF(i,1) = sqrt((handOnsetsY_EHnF(i,1) - fixationTargetsHandY_EHnF(i,1))^2);
end

errorAllTargets_EAF = mean(error_EAF);
errorAllTargets_EAnF = mean(error_EAnF);
errorAllTargets_EHF = mean(error_EHF);
errorAllTargets_EHnF = mean(error_EHnF);
errorAllTargetsHand_EHF = mean([errorHandX_EHF; errorHandY_EHF]);
errorAllTargetsHand_EHnF = mean([errorHandX_EHnF; errorHandY_EHnF]);
errorAllConditions = mean([error_EAF; error_EAnF; error_EHF; error_EHnF]);
errorAllConditionsHand = mean([errorHandX_EHF; errorHandY_EHF; errorHandX_EHnF; errorHandY_EHnF]);
errorFeedback = mean([error_EAF; error_EHF]);
errorFeedbackHand = mean([errorHandX_EHF; errorHandY_EHF]);
errorNoFeedback = mean([error_EAnF; error_EHnF]);
errorNoFeedbackHand = mean([errorHandX_EHnF; errorHandY_EHnF]);

stdAllTargets_EAF = std(error_EAF);
stdAllTargets_EAnF = std(error_EAnF);
stdAllTargets_EHF = std(error_EHF);
stdAllTargets_EHnF = std(error_EHnF);
stdErrorAllTargets_EAF = stdAllTargets_EAF/length(error_EAF);
stdErrorAllTargets_EAnF = stdAllTargets_EAnF/length(error_EAnF);
stdErrorAllTargets_EHF = stdAllTargets_EHF/length(error_EHF);
stdErrorAllTargets_EHnF = stdAllTargets_EHnF/length(error_EHnF);
stdAllTargetsHand_EHF = std([errorHandX_EHF; errorHandY_EHF]);
stdAllTargetsHand_EHnF = std([errorHandX_EHnF; errorHandY_EHnF]);
stdErrorAllTargetsHand_EHF = stdAllTargetsHand_EHF/(length(errorHandX_EHF) + length(errorHandY_EHF));
stdErrorAllTargetsHand_EHnF = stdAllTargetsHand_EHnF/(length(errorHandX_EHnF) + length(errorHandY_EHnF));
stdAllConditions = std([error_EAF; error_EAnF; error_EHF; error_EHnF]);
stdAllConditionsHand = std([errorHandX_EHF; errorHandY_EHF; errorHandX_EHnF; errorHandY_EHnF]);
stdFeedback = std([error_EAF; error_EHF]);
stdFeedbackHand = std([errorHandX_EHF; errorHandY_EHF]);
stdNoFeedback = std([error_EAnF; error_EHnF]);
stdNoFeedbackHand = std([errorHandX_EHnF; errorHandY_EHnF]);