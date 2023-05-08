% This code manually removes blink trials
if strcmp(subject, 'Subject002') == 1
    % Eye Alone Feedback
    remove = 46;
    for i = 1:1:length(remove)
        fixationIndices_EAF(remove(i)) = [];
        fixations_EAF(remove(i),:) = [];
    end
end

if strcmp(subject, 'Subject003') == 1
    % Eye Alone No Feedback
    remove = [30, 97-1];
    for i = 1:1:length(remove)
        fixationIndices_EAnF(remove(i)) = [];
        fixations_EAnF(remove(i),:) = [];
    end
    
    % Eye Hand No Feedback
    remove = [51, 62-1];
    for i = 1:1:length(remove)
        fixationIndices_EHnF(remove(i)) = [];
        fixations_EHnF(remove(i),:) = [];
    end
end

if strcmp(subject, 'Subject004') == 1
    % Eye Alone No Feedback
    remove = 87;
    for i = 1:1:length(remove)
        fixationIndices_EAnF(remove(i)) = [];
        fixations_EAnF(remove(i),:) = [];
    end
    
    % Eye Hand Feedback
    remove = 87;
    for i = 1:1:length(remove)
        fixationIndices_EHF(remove(i)) = [];
        fixations_EHF(remove(i),:) = [];
    end
    
    % Eye Hand No Feedback
    remove = [21, 75-1, 88-2];
    for i = 1:1:length(remove)
        fixationIndices_EHnF(remove(i)) = [];
        fixations_EHnF(remove(i),:) = [];
    end
end

if strcmp(subject, 'Subject006') == 1
    % Eye Alone Feedback
    remove = [23, 32-1, 53-2, 69-3];
    for i = 1:1:length(remove)
        fixationIndices_EAF(remove(i)) = [];
        fixations_EAF(remove(i),:) = [];
    end
    
    % Eye Hand Feedback
    remove = 1;
    for i = 1:1:length(remove)
        fixationIndices_EHF(remove(i)) = [];
        fixations_EHF(remove(i),:) = [];
    end
end

if strcmp(subject, 'Subject007') == 1
    % Eye Alone Feedback
    remove = 32;
    for i = 1:1:length(remove)
        fixationIndices_EAF(remove(i)) = [];
        fixations_EAF(remove(i),:) = [];
    end
    
    % Eye Alone No Feedback
    remove = [87, 89-1];
    for i = 1:1:length(remove)
        fixationIndices_EAnF(remove(i)) = [];
        fixations_EAnF(remove(i),:) = [];
    end
    
    % Eye Hand Feedback
    remove = 66;
    for i = 1:1:length(remove)
        fixationIndices_EHF(remove(i)) = [];
        fixations_EHF(remove(i),:) = [];
    end
    
    % Eye Hand No Feedback
    remove = [17, 19-1, 62-2, 63-3, 68-4, 81-5];
    for i = 1:1:length(remove)
        fixationIndices_EHnF(remove(i)) = [];
        fixations_EHnF(remove(i),:) = [];
    end
end

if strcmp(subject, 'Subject008') == 1    
    % Eye Alone No Feedback
    remove = [23, 37-1, 44-2, 48-3, 52-4, 60-5, 71-6];
    for i = 1:1:length(remove)
        fixationIndices_EAnF(remove(i)) = [];
        fixations_EAnF(remove(i),:) = [];
    end
    
    % Eye Hand No Feedback
    remove = [48, 87-1];
    for i = 1:1:length(remove)
        fixationIndices_EHnF(remove(i)) = [];
        fixations_EHnF(remove(i),:) = [];
    end
end