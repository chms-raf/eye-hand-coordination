% This code manually removes excess hand Onsets
% Should be 156 X onsets and 44 Y onsets

if strcmp(subject, 'Subject002') == 1
    % Eye Hand Feedback
    remove = [37,38,39,48,64,94,95,104,109,114,115,116,121,138,139,140,141,150,151,152,157]';
    handOnsetsX_EHF(remove) = [];
    handOnsetIndicesX_EHF(remove) = [];
%     targetChangesX_EHF([19,20,55,56]') = [];
    
    remove = [1,2,3,4,5,6,7,10,13,14,15,16,17,18,19,20,21,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,43,44,45,50,51,52,57,62,63,64,65,66,67,68,69,74,75,76,77,78,79,80,89,90,91,92,101,102,107,108,109,110,111,112]';
    handOnsetsY_EHF(remove) = [];
    handOnsetIndicesY_EHF(remove) = [];
    
    % Eye Hand No Feedback
    remove = [14,22,51,104,121,138,147,148,149]';
    handOnsetsX_EHnF(remove) = [];
    handOnsetIndicesX_EHnF(remove) = [];
    
    remove = [1,2,3,4,5,6,7,8,13,14,15,16,17,18,19,20,21,22,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,51,52,57,62,63,64,65,70,71,72,73,74,75,84,85,94,95,100,101,102,103,104]';
    handOnsetsY_EHnF(remove) = [];
    handOnsetIndicesY_EHnF(remove) = [];
end

if strcmp(subject, 'Subject003') == 1
    % Eye Hand Feedback
    remove = [21,50,71,72,73,98,107,108,125,142,151,156]';
    handOnsetsX_EHF(remove) = [];
    handOnsetIndicesX_EHF(remove) = [];
    
    remove = [1,2,3,4,5,6,11,12,13,14,15,16,21,22,23,24,25,26,27,28,29,30,31,32,33,34,39,40,41,50,51,52,53,54,55,56,57,58,59,68,69,78,79,84,85,86,87,88,89]';
    handOnsetsY_EHF(remove) = [];
    handOnsetIndicesY_EHF(remove) = [];
%     targetChangesY_EHF([11,12]') = [];
    
    % Eye Hand No Feedback
    remove = [16,50,51,52,97,98,107,108,113,142,143,152,157]';
    handOnsetsX_EHnF(remove) = [];
    handOnsetIndicesX_EHnF(remove) = [];
    
    remove = [1,2,3,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,30,31,36,41,42,43,44,49,50,51,52,53,54,55,56,65,66,75,76,81,82,83,84,85,86]';
    handOnsetsY_EHnF(remove) = [];
    handOnsetIndicesY_EHnF(remove) = [];
%     targetChangesY_EHnF([3,4]') = [];
end

if strcmp(subject, 'Subject004') == 1
    % Eye Hand Feedback
    remove = [21,118,135,144,145]';
    handOnsetsX_EHF(remove) = [];
    handOnsetIndicesX_EHF(remove) = [];
    
    remove = [1,2,3,8,9,10,11,16,17,18,19,20,21,22,23,24,25,30,31,40,41,46,47,48,49,66,67,72,73,74]';
    handOnsetsY_EHF(remove) = [];
    handOnsetIndicesY_EHF(remove) = [];
    
    % Eye Hand No Feedback
    remove = [49,102,103,136,137]';
    handOnsetsX_EHnF(remove) = [];
    handOnsetIndicesX_EHnF(remove) = [];
    
    remove = [1,2,3,4,5,6,11,16,17,18,19,20,21,22,23,24,25,30,31,32,33,38,39,40,45,46,47,56,65,66,71,72,73,74,75]';
    handOnsetsY_EHnF(remove) = [];
    handOnsetIndicesY_EHnF(remove) = [];
%     targetChangesY_EHnF([7,8]') = [];
end

if strcmp(subject, 'Subject005') == 1
    % Eye Hand Feedback
    remove = [1,6,11,12,13,18,27,32,33,34,51,52,57,58]';
    handOnsetsY_EHF(remove) = [];
    handOnsetIndicesY_EHF(remove) = [];
    
    % Eye Hand No Feedback
    remove = 49;
    handOnsetsX_EHnF(remove) = [];
    handOnsetIndicesX_EHnF(remove) = [];
    
    remove = [1,2,7,12,13,14,15,16,17,18,19,24,33,38,39,40,61,62,63]';
    handOnsetsY_EHnF(remove) = [];
    handOnsetIndicesY_EHnF(remove) = [];
end

if strcmp(subject, 'Subject006') == 1
    % Eye Hand Feedback
    remove = 49;
    handOnsetsX_EHF(remove) = [];
    handOnsetIndicesX_EHF(remove) = [];
    
    remove = 45;
    handOnsetsY_EHF(remove) = [];
    handOnsetIndicesY_EHF(remove) = [];
    
    % Eye Hand No Feedback
    remove = [37,38,39]';
    handOnsetsX_EHnF(remove) = [];
    handOnsetIndicesX_EHnF(remove) = [];
%     targetChangesX_EHnF([19,20]') = [];
    
    remove = [9,10,11,12,13,14,15,16,17,22,35,36,37,54,55,60,61]';
    handOnsetsY_EHnF(remove) = [];
    handOnsetIndicesY_EHnF(remove) = [];
end

if strcmp(subject, 'Subject007') == 1
    % Eye Hand Feedback
    remove = [29,30,31,32,33,46,47,92,93,97,103,108,121,127,139,148,153,154]';
    handOnsetsX_EHF(remove) = [];
    handOnsetIndicesX_EHF(remove) = [];
    
    remove = [1,2,3,4,5,6,11,12,13,14,15,16,17,18,19,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,48,49,50,51,52,57,58,63,64,65,66,67,72,73,74,75,76,77,78,79,88,89,98,99,104,105,106,107,108]';
    handOnsetsY_EHF(remove) = [];
    handOnsetIndicesY_EHF(remove) = [];
    
    % Eye Hand No Feedback
    remove = [49,118,135,136,145,146,147,152]';
    handOnsetsX_EHnF(remove) = [];
    handOnsetIndicesX_EHnF(remove) = [];
    
    remove = [1,2,3,4,5,6,7,12,13,14,15,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,42,43,52,53,54,55,60,61,62,63,64,65,74,75,84,85,90,91,92,93,94]';
    handOnsetsY_EHnF(remove) = [];
    handOnsetIndicesY_EHnF(remove) = [];
end

if strcmp(subject, 'Subject008') == 1
    % Eye Hand Feedback
    remove = [69,70,71,72,73,74,75,84,85,86,87,88,89,90,91,92,101,102,103,104,105,118,126,136,145,146]';
    handOnsetsX_EHF(remove) = [];
    handOnsetIndicesX_EHF(remove) = [];
    
    remove = [1,2,3,4,5,6,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,39,44,49,54,55,56,57,58,59,68,69,78,79,84,85,86,87]';
    handOnsetsY_EHF(remove) = [];
    handOnsetIndicesY_EHF(remove) = [];
    
    % Eye Hand No Feedback
    remove = [21,50,51,96,105,110,123,124,149]';
    handOnsetsX_EHnF(remove) = [];
    handOnsetIndicesX_EHnF(remove) = [];
    
    remove = [1,2,3,4,5,6,7,12,13,14,15,16,17,18,19,20,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,49,50,55,60,61,62,67,68,69,70,71,72,81,82,83,92,93,98,99,100,101,102]';
    handOnsetsY_EHnF(remove) = [];
    handOnsetIndicesY_EHnF(remove) = [];
end

% Remove onsets (odd numbers) and keep reach endpoints (even numbers)
for i = 1:1:length(handOnsetIndicesX_EHF)
    if mod(i,2) == 1
        handOnsetIndicesX_EHF(i) = 0;
        handOnsetsX_EHF(i) = 0;
    end
end
handOnsetIndicesX_EHF(handOnsetIndicesX_EHF == 0) = [];
handOnsetsX_EHF(handOnsetsX_EHF == 0) = [];

for i = 1:1:length(handOnsetIndicesY_EHF)
    if mod(i,2) == 1
        handOnsetIndicesY_EHF(i) = 0;
        handOnsetsY_EHF(i) = 0;
    end
end
handOnsetIndicesY_EHF(handOnsetIndicesY_EHF == 0) = [];
handOnsetsY_EHF(handOnsetsY_EHF == 0) = [];

for i = 1:1:length(handOnsetIndicesX_EHnF)
    if mod(i,2) == 1
        handOnsetIndicesX_EHnF(i) = 0;
        handOnsetsX_EHnF(i) = 0;
    end
end
handOnsetIndicesX_EHnF(handOnsetIndicesX_EHnF == 0) = [];
handOnsetsX_EHnF(handOnsetsX_EHnF == 0) = [];

for i = 1:1:length(handOnsetIndicesY_EHnF)
    if mod(i,2) == 1
        handOnsetIndicesY_EHnF(i) = 0;
        handOnsetsY_EHnF(i) = 0;
    end
end
handOnsetIndicesY_EHnF(handOnsetIndicesY_EHnF == 0) = [];
handOnsetsY_EHnF(handOnsetsY_EHnF == 0) = [];