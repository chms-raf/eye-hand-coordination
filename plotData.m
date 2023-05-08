% Plot Data
f(1) = figure('Name', subject);
subplot(2,1,1)
plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX)
hold on
plot(EyeAloneFeedback.Time, EyeAloneFeedback.TargetX)
plot(EyeAloneFeedback.Time(fixationIndices_EAF), fixations_EAF(:,1),'ko')
title('Eye Alone Feedback Eye X')
ylabel('X-direction (mm)')
legend('Raw Gaze Data', 'Targets', 'Eye Fixations')

subplot(2,1,2)
plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeY)
hold on
plot(EyeAloneFeedback.Time, EyeAloneFeedback.TargetY)
plot(EyeAloneFeedback.Time(fixationIndices_EAF), fixations_EAF(:,2),'ko')
title('Eye Alone Feedback Eye Y')
ylabel('Y-direction (mm)')
xlabel('Time (s)')

f(2) = figure('Name', subject);
subplot(2,1,1)
plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeX)
hold on
plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.TargetX)
plot(EyeAloneNoFeedback.Time(fixationIndices_EAnF), fixations_EAnF(:,1),'ko')
title('Eye Alone No Feedback Eye X')
ylabel('X-direction (mm)')
legend('Raw GazeData', 'Targets', 'Eye Fixations')

subplot(2,1,2)
plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeY)
hold on
plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.TargetY)
plot(EyeAloneNoFeedback.Time(fixationIndices_EAnF), fixations_EAnF(:,2),'ko')
title('Eye Alone No Feedback Eye Y')
ylabel('Y-direction (mm)')
xlabel('Time (s)')

% Eye Hand Feedback
f(3) = figure('Name', subject);
subplot(2,1,1)
plot(EyeHandFeedback.Time, EyeHandFeedback.EyeX)
hold on
plot(EyeHandFeedback.Time, EyeHandFeedback.TargetX)
plot(EyeHandFeedback.Time(fixationIndices_EHF), fixations_EHF(:,1),'ko')
plot(EyeHandFeedback.Time, EyeHandFeedback.HandX)
plot(EyeHandNoFeedback.Time(handOnsetIndicesX_EHnF), handOnsetsX_EHnF,'ro')
title('Eye Hand Feedback Eye X')
ylabel('X-direction (mm)')
legend('Raw Gaze Data', 'Targets', 'Eye Fixations', 'Raw Hand Data', 'Hand Onsets')

subplot(2,1,2)
plot(EyeHandFeedback.Time, EyeHandFeedback.EyeY)
hold on
plot(EyeHandFeedback.Time, EyeHandFeedback.TargetY)
plot(EyeHandFeedback.Time(fixationIndices_EHF), fixations_EHF(:,2),'ko')
plot(EyeHandFeedback.Time, EyeHandFeedback.HandY)
plot(EyeHandNoFeedback.Time(handOnsetIndicesY_EHnF), handOnsetsY_EHnF,'ro')
title('Eye Hand Feedback Eye Y')
ylabel('Y-direction (mm)')
xlabel('Time (s)')

% Eye Hand No Feedback
f(4) = figure('Name', subject);
subplot(2,1,1)
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeX)
hold on
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetX)
plot(EyeHandNoFeedback.Time(fixationIndices_EHnF), fixations_EHnF(:,1),'ko')
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandX)
plot(EyeHandNoFeedback.Time(handOnsetIndicesX_EHF), handOnsetsX_EHF,'ro')
title('Eye Hand No Feedback Eye X')
ylabel('X-direction (mm)')
legend('Raw Gaze Data', 'Targets', 'Eye Fixations', 'Raw Hand Data','Hand Onsets')

subplot(2,1,2)
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeY)
hold on
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.TargetY)
plot(EyeHandNoFeedback.Time(fixationIndices_EHnF), fixations_EHnF(:,2),'ko')
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.HandY)
plot(EyeHandNoFeedback.Time(handOnsetIndicesY_EHF), handOnsetsY_EHF,'ro')
title('Eye Hand No Feedback Eye Y')
ylabel('Y-direction (mm)')
xlabel('Time (s)')