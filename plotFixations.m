% This code plots data with fixations

% Plot 2D
% str0 = sprintf('Filter Parameters');
% str1 = sprintf('r:             %0.0f',r);
% str2 = sprintf('h:            %0.0f',h);
% str3 = sprintf('th:           %0.0f',threshold);
% str4 = sprintf('radius:    %0.0f',radius);
str = sprintf('Fixations: %0.0f', length(fixations_EAF));

f(2) = figure;
set(gcf, 'Name',subject)

subplot(2,2,1)
plot(EyeAloneFeedback.EyeX, EyeAloneFeedback.EyeY,'r')
set(gca, 'YDir','reverse')
text(200, 150, str, 'FontSize', 10);
% figText0 = text(200, 100, str0, 'FontSize', 12);
% figText1 = text(200, 130, str1, 'FontSize', 12);
% figText2 = text(200, 160, str2, 'FontSize', 12);
% figText3 = text(200, 190, str3, 'FontSize', 12);
% figText4 = text(200, 220, str4, 'FontSize', 12);
% figText5 = text(200, 250, str5, 'FontSize', 12);
hold on
plot(fixations_EAF(:,1),fixations_EAF(:,2),'x','MarkerSize',12,'LineWidth',2)
drawTargets
axis([100 1110 100 651])
%axis('equal')
title('Gaze Data with Fixations: Eye Alone Feedback')
xlabel('x-direction')
ylabel('y-direction')

subplot(2,2,2)
plot(EyeAloneNoFeedback.EyeX, EyeAloneNoFeedback.EyeY,'r')
set(gca, 'YDir','reverse')
str = sprintf('Fixations: %0.0f', length(fixations_EAnF));
text(200, 150, str, 'FontSize', 10);
hold on
plot(fixations_EAnF(:,1),fixations_EAnF(:,2),'x','MarkerSize',12,'LineWidth',2)
drawTargets
axis([100 1110 100 651])
%axis('equal')
title('Gaze Data with Fixations: Eye Alone No Feedback')
xlabel('x-direction')
ylabel('y-direction')
legend('Gaze Data','Estimated Fixations','Targets')

subplot(2,2,3)
plot(EyeHandFeedback.EyeX, EyeHandFeedback.EyeY,'r')
set(gca, 'YDir','reverse')
str = sprintf('Fixations: %0.0f', length(fixations_EHF));
text(200, 150, str, 'FontSize', 10);
hold on
plot(fixations_EHF(:,1),fixations_EHF(:,2),'x','MarkerSize',12,'LineWidth',2)
drawTargets
axis([100 1110 100 651])
title('Gaze Data with Fixations: Eye Hand Feedback')
xlabel('x-direction')
ylabel('y-direction')

subplot(2,2,4)
plot(EyeHandNoFeedback.EyeX, EyeHandNoFeedback.EyeY,'r')
set(gca, 'YDir','reverse')
str = sprintf('Fixations: %0.0f', length(fixations_EHnF));
text(200, 150, str, 'FontSize', 10);
hold on
plot(fixations_EHnF(:,1),fixations_EHnF(:,2),'x','MarkerSize',12,'LineWidth',2)
drawTargets
axis([100 1110 100 651])
title('Gaze Data with Fixations: Eye Hand No Feedback')
xlabel('x-direction')
ylabel('y-direction')

% Plot 1D
f(3) = figure;
set(gcf, 'Name',subject)

subplot(4,2,1)
plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeX,'r')
hold on
plot(EyeAloneFeedback.Time(peakIndices_EAF), EyeAloneFeedback.EyeX(peakIndices_EAF), 'ko', 'MarkerSize', 4)
title('Gaze Data with fixations: Eye Alone Feedback')
ylabel('X-direction')

subplot(4,2,3)
plot(EyeAloneFeedback.Time, EyeAloneFeedback.EyeY,'r')
hold on
plot(EyeAloneFeedback.Time(peakIndices_EAF), EyeAloneFeedback.EyeY(peakIndices_EAF), 'ko', 'MarkerSize', 4)
xlabel('Time (s)')
ylabel('Y-direction')

subplot(4,2,2)
plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeX,'r')
hold on
plot(EyeAloneNoFeedback.Time(peakIndices_EAnF), EyeAloneNoFeedback.EyeX(peakIndices_EAnF), 'ko', 'MarkerSize', 4)
title('Gaze Data with fixations: Eye Alone No Feedback')
legend('Gaze Data','Estimated Fixations')
ylabel('X-direction')

subplot(4,2,4)
plot(EyeAloneNoFeedback.Time, EyeAloneNoFeedback.EyeY,'r')
hold on
plot(EyeAloneNoFeedback.Time(peakIndices_EAnF), EyeAloneNoFeedback.EyeY(peakIndices_EAnF), 'ko', 'MarkerSize', 4)
xlabel('Time (s)')
ylabel('Y-direction')

subplot(4,2,5)
plot(EyeHandFeedback.Time, EyeHandFeedback.EyeX,'r')
hold on
plot(EyeHandFeedback.Time(peakIndices_EHF), EyeHandFeedback.EyeX(peakIndices_EHF), 'ko', 'MarkerSize', 4)
title('Gaze Data with fixations: Eye Hand Feedback')
ylabel('X-direction')

subplot(4,2,7)
plot(EyeHandFeedback.Time, EyeHandFeedback.EyeY,'r')
hold on
plot(EyeHandFeedback.Time(peakIndices_EHF), EyeHandFeedback.EyeY(peakIndices_EHF), 'ko', 'MarkerSize', 4)
xlabel('Time (s)')
ylabel('Y-direction')

subplot(4,2,6)
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeX,'r')
hold on
plot(EyeHandNoFeedback.Time(peakIndices_EHnF), EyeHandNoFeedback.EyeX(peakIndices_EHnF), 'ko', 'MarkerSize', 4)
title('Gaze Data with fixations: Eye Hand No Feedback')
ylabel('X-direction')

subplot(4,2,8)
plot(EyeHandNoFeedback.Time, EyeHandNoFeedback.EyeY,'r')
hold on
plot(EyeHandNoFeedback.Time(peakIndices_EHnF), EyeHandNoFeedback.EyeY(peakIndices_EHnF), 'ko', 'MarkerSize', 4)
xlabel('Time (s)')
ylabel('Y-direction')