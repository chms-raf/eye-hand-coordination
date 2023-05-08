% This code plots the peaks in the difference vector

f = figure;
set(gcf, 'Name',subject)

subplot(2,2,1)
plot(d_EAF)
hold on
plot(peak_EAF, 'o')
title([str, 'Eye Alone Feedback'])
xlabel('Time (s)')
ylabel('Spacial Distance (mm)')
axis([0 4e4 0 700])

subplot(2,2,2)
plot(d_EAnF)
hold on
plot(peak_EAnF, 'o')
title([str, 'Eye Alone No Feedback'])
xlabel('Time (s)')
ylabel('Spacial Distance (mm)')
axis([0 4e4 0 700])

subplot(2,2,3)
plot(d_EHF)
hold on
plot(peak_EHF, 'o')
title([str, 'Eye Hand Feedback'])
xlabel('Time (s)')
ylabel('Spacial Distance (mm)')
axis([0 4e4 0 700])

subplot(2,2,4)
plot(d_EHnF)
hold on
plot(peak_EHnF, 'o')
title([str, 'Eye Hand No Feedback'])
xlabel('Time (s)')
ylabel('Spacial Distance (mm)')
axis([0 4e4 0 700])