figure
ax = gca;
ay = gcf;
ay.Color = 'w';
ax.FontSize = 20;
plot(EyeHandFeedback.EyeX*.1, EyeHandFeedback.EyeY*.1,'r', 'LineWidth',2)
set(gca, 'YDir','reverse')
hold on
plot(fixations_EHF(:,1)*.1,fixations_EHF(:,2)*.1,'x','MarkerSize',20,'LineWidth',1.5)

drawCircle(604.8285*.1, 455.6125*.1, 0, 25*.1, 100)
drawCircle(362.8971*.1, 455.6125*.1, 0, 25*.1, 100)
drawCircle(483.8628*.1, 455.6125*.1, 0, 25*.1, 100)
drawCircle(725.7942*.1, 455.6125*.1, 0, 25*.1, 100)
drawCircle(846.7599*.1, 455.6125*.1, 0, 25*.1, 100)
drawCircle(604.8285*.1, 325.4375*.1, 0, 25*.1, 100)
drawCircle(604.8285*.1, 195.2625*.1, 0, 25*.1, 100)

axis([250*.1 1000*.1 150*.1 550*.1])
title('Gaze Data with Fixations: Eye Hand Feedback')
xlabel('x-direction (cm)', 'FontSize', 26)
ylabel('y-direction (cm)', 'FontSize', 26)
legend('Raw Gaze Data', 'Estimated Fixations', 'Targets')