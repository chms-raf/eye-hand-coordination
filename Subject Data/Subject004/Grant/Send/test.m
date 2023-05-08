%% Reaching Function

load Data.mat

handP = f(EyeX, EyeXdot, EyeXddot);

h = figure('units','normalized','outerposition',[0 0 1 1]);
ax = gca;
ay = gcf;
ay.Color = 'w';
plot(1000*time - 1000*time(1), TargetX, 'LineWidth', 3)
hold on
plot(1000*time - 1000*time(1), EyeX, 'LineWidth', 3)
plot(1000*time - 1000*time(1), HandX, '--', 'LineWidth', 3)
xlabel('Time (ms)', 'FontSize', 30)
ax.FontSize = 26;
axis([0 8000 -20 140])
ylabel('Position (mm)', 'FontSize', 30)
legend('Target', 'Eye', 'Hand', 'FontSize', 24)

%orient(h,'landscape')
%print('FillPageFigure','-dpdf','-fillpage')
saveas(h,'test.pdf')


RMSE = sqrt(mean((handP - HandX).^2));
% fprintf('RMSE: %f\n', RMSE)

function y = f(x, xDot, xDDot)

    a = .001;
    b = -.05;
    c = 1;
    
    y = a*xDDot+ b*xDot + c*x;

end