%% Reaching Function

load Data.mat

handP = f(EyeX, EyeXdot, EyeXddot);

h = figure('units','normalized','outerposition',[0 0 1 1]);
ax = gca;
ay = gcf;
ay.Color = 'w';
plot(time - time(1), TargetX, 'LineWidth', 3)
hold on
plot(time - time(1), EyeX, 'LineWidth', 3)
plot(time - time(1),HandX, 'LineWidth', 3)
plot(time - time(1) + delay, handP, 'k', 'LineWidth', 3)
xlabel('Time (s)', 'FontSize', 26)
ax.FontSize = 20;
axis([0 8 -20 140])
ylabel('Position (mm)', 'FontSize', 26)
legend('Target', 'Eye', 'Hand', 'Predicted Hand', 'FontSize', 22)

%orient(h,'landscape')
%print('FillPageFigure','-dpdf','-fillpage')
saveas(h,'ReachFunctionFig.pdf')


RMSE = sqrt(mean((handP - HandX).^2));
% fprintf('RMSE: %f\n', RMSE)

function y = f(x, xDot, xDDot)

    a = .001;
    b = -.05;
    c = 1;
    
    y = a*xDDot+ b*xDot + c*x;

end