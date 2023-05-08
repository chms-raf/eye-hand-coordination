% This file calculates the accuracy of reaches

n = 50;

%% Eye Alone Feedback: (Eye X)

bounds = zeros(n,2);
TargetX = zeros(n,1);

fprintf('Eye Alone Feedback (EyeX): \n\n')

for i = 1:1:n
    idx = find(EyeAloneFeedback.ReachNumber == i);
    
    if i == 5 || i == 7 || i == 8 || i == 18 || i == 22 || i == 27 || i == 35 || i == 42 || i == 48
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeAloneFeedback.EyeXavg(i,1) = NaN;
        EyeAloneFeedback.EyeXerror(i,1) = NaN;
        TargetX(i,1) = NaN;
        fprintf('    Skip reach #%i (blink trial)\n', i)
        continue
    elseif EyeAloneFeedback.TargetX(round(median(idx)) - 50) == 604.8285
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeAloneFeedback.EyeXavg(i,1) = NaN;
        EyeAloneFeedback.EyeXerror(i,1) = NaN;
        TargetX(i,1) = NaN;
        fprintf('    Skip reach #%i (y-direction trial)\n', i)
        continue
    else
        figure
        plot(EyeAloneFeedback.Time(idx), EyeAloneFeedback.EyeX_F_NBT(idx))
        hold on
        plot(EyeAloneFeedback.Time(idx), EyeAloneFeedback.TargetX_NBT(idx))
        title(['EyeAloneFeedback (Eye X): Reach # ',num2str(i)])
        
        temp = ginput(2);
        
        bounds(i,1) = temp(1,1);
        bounds(i,2) = temp(2,1);
        idx2 = find(EyeAloneFeedback.Time <= bounds(i,2) & EyeAloneFeedback.Time >= bounds(i,1));
        EyeAloneFeedback.EyeXavg(i,1) = mean(EyeAloneFeedback.EyeX_F_NBT(idx2));
        TargetX(i,1) = mode(EyeAloneFeedback.TargetX(idx2));
        EyeAloneFeedback.EyeXerror(i,1) = EyeAloneFeedback.EyeXavg(i,1) - TargetX(i,1);

        close
    end
    fprintf('Reach #%i: avg: %f, Target: %f, error: %f\n', i, EyeAloneFeedback.EyeXavg(i,1), TargetX(i,1), EyeAloneFeedback.EyeXerror(i,1))
end

temp = isfinite(EyeAloneFeedback.EyeXerror);
EyeAloneFeedback.RMSE_EyeX = sqrt(mean(EyeAloneFeedback.EyeXerror(temp).^2));
fprintf('\nEyeX RMSE: %f (mm)\n\n', EyeAloneFeedback.RMSE_EyeX)

%% Eye Alone Feedback: (Eye Y)

bounds = zeros(n,2);
TargetY = zeros(n,1);

fprintf('Eye Alone Feedback (EyeY): \n\n')

for i = 1:1:n
    idx = find(EyeAloneFeedback.ReachNumber == i);
    
    if i == 5 || i == 7 || i == 8 || i == 18 || i == 22 || i == 27 || i == 35 || i == 42 || i == 48
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeAloneFeedback.EyeYavg(i,1) = NaN;
        EyeAloneFeedback.EyeYerror(i,1) = NaN;
        TargetY(i,1) = NaN;
        fprintf('    Skip reach #%i (blink trial)\n', i)
        continue
    elseif EyeAloneFeedback.TargetY(round(median(idx)) - 50) >= 455.6 && EyeAloneFeedback.TargetY(round(median(idx)) - 50) <= 455.7
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeAloneFeedback.EyeYavg(i,1) = NaN;
        EyeAloneFeedback.EyeYerror(i,1) = NaN;
        TargetY(i,1) = NaN;
        fprintf('    Skip reach #%i (x-direction trial)\n', i)
        continue
    else
        figure
        plot(EyeAloneFeedback.Time(idx), EyeAloneFeedback.EyeY_F_NBT(idx))
        hold on
        plot(EyeAloneFeedback.Time(idx), EyeAloneFeedback.TargetY_NBT(idx))
        title(['EyeAloneFeedback (Eye Y): Reach # ',num2str(i)])
        
        temp = ginput(2);
        
        bounds(i,1) = temp(1,1);
        bounds(i,2) = temp(2,1);
        idx2 = find(EyeAloneFeedback.Time <= bounds(i,2) & EyeAloneFeedback.Time >= bounds(i,1));
        EyeAloneFeedback.EyeYavg(i,1) = mean(EyeAloneFeedback.EyeY_F_NBT(idx2));
        TargetY(i,1) = mode(EyeAloneFeedback.TargetY(idx2));
        EyeAloneFeedback.EyeYerror(i,1) = EyeAloneFeedback.EyeYavg(i,1) - TargetY(i,1);
        
        close
    end
    fprintf('Reach #%i: avg: %f, Target: %f, error: %f\n', i, EyeAloneFeedback.EyeYavg(i,1), TargetY(i,1), EyeAloneFeedback.EyeYerror(i,1))
end

temp = isfinite(EyeAloneFeedback.EyeYerror);
EyeAloneFeedback.RMSE_EyeY = sqrt(mean(EyeAloneFeedback.EyeYerror(temp).^2));
fprintf('\nEyeY RMSE: %f (mm)\n\n', EyeAloneFeedback.RMSE_EyeY)

%% Eye Alone No Feedback: (Eye X)

bounds = zeros(n,2);
TargetX = zeros(n,1);

fprintf('Eye Alone No Feedback (EyeX): \n\n')

for i = 1:1:n
    idx = find(EyeAloneNoFeedback.ReachNumber == i);
    
    if i == 29 || i == 44 || i == 45
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeAloneNoFeedback.EyeXavg(i,1) = NaN;
        EyeAloneNoFeedback.EyeXerror(i,1) = NaN;
        TargetX(i,1) = NaN;
        fprintf('    Skip reach #%i (blink trial)\n', i)
        continue
    elseif EyeAloneNoFeedback.TargetX(round(median(idx)) - 50) == 604.8285
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeAloneNoFeedback.EyeXavg(i,1) = NaN;
        EyeAloneNoFeedback.EyeXerror(i,1) = NaN;
        TargetX(i,1) = NaN;
        fprintf('    Skip reach #%i (y-direction trial)\n', i)
        continue
    else
        figure
        plot(EyeAloneNoFeedback.Time(idx), EyeAloneNoFeedback.EyeX_F_NBT(idx))
        hold on
        plot(EyeAloneNoFeedback.Time(idx), EyeAloneNoFeedback.TargetX_NBT(idx))
        title(['EyeAloneNoFeedback (Eye X): Reach # ',num2str(i)])
        
        temp = ginput(2);
        
        bounds(i,1) = temp(1,1);
        bounds(i,2) = temp(2,1);
        idx2 = find(EyeAloneNoFeedback.Time <= bounds(i,2) & EyeAloneNoFeedback.Time >= bounds(i,1));
        EyeAloneNoFeedback.EyeXavg(i,1) = mean(EyeAloneNoFeedback.EyeX_F_NBT(idx2));
        TargetX(i,1) = mode(EyeAloneNoFeedback.TargetX(idx2));
        EyeAloneNoFeedback.EyeXerror(i,1) = EyeAloneNoFeedback.EyeXavg(i,1) - TargetX(i,1);

        close
    end
    fprintf('Reach #%i: avg: %f, Target: %f, error: %f\n', i, EyeAloneNoFeedback.EyeXavg(i,1), TargetX(i,1), EyeAloneNoFeedback.EyeXerror(i,1))
end

temp = isfinite(EyeAloneNoFeedback.EyeXerror);
EyeAloneNoFeedback.RMSE_EyeX = sqrt(mean(EyeAloneNoFeedback.EyeXerror(temp).^2));
fprintf('\nEyeX RMSE: %f (mm)\n\n', EyeAloneNoFeedback.RMSE_EyeX)

%% Eye Alone No Feedback: (Eye Y)

bounds = zeros(n,2);
TargetY = zeros(n,1);

fprintf('Eye Alone No Feedback (EyeY): \n\n')

for i = 1:1:n
    idx = find(EyeAloneNoFeedback.ReachNumber == i);
    
    if i == 29 || i == 44 || i == 45
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeAloneNoFeedback.EyeYavg(i,1) = NaN;
        EyeAloneNoFeedback.EyeYerror(i,1) = NaN;
        TargetY(i,1) = NaN;
        fprintf('    Skip reach #%i (blink trial)\n', i)
        continue
    elseif EyeAloneNoFeedback.TargetY(round(median(idx)) - 50) >= 455.6 && EyeAloneNoFeedback.TargetY(round(median(idx)) - 50) <= 455.7
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeAloneNoFeedback.EyeYavg(i,1) = NaN;
        EyeAloneNoFeedback.EyeYerror(i,1) = NaN;
        TargetY(i,1) = NaN;
        fprintf('    Skip reach #%i (x-direction trial)\n', i)
        continue
    else
        figure
        plot(EyeAloneNoFeedback.Time(idx), EyeAloneNoFeedback.EyeY_F_NBT(idx))
        hold on
        plot(EyeAloneNoFeedback.Time(idx), EyeAloneNoFeedback.TargetY_NBT(idx))
        title(['EyeAloneNoFeedback (Eye Y): Reach # ',num2str(i)])
        
        temp = ginput(2);
        
        bounds(i,1) = temp(1,1);
        bounds(i,2) = temp(2,1);
        idx2 = find(EyeAloneNoFeedback.Time <= bounds(i,2) & EyeAloneNoFeedback.Time >= bounds(i,1));
        EyeAloneNoFeedback.EyeYavg(i,1) = mean(EyeAloneFeedback.EyeY_F_NBT(idx2));
        TargetY(i,1) = mode(EyeAloneNoFeedback.TargetY(idx2));
        EyeAloneNoFeedback.EyeYerror(i,1) = EyeAloneNoFeedback.EyeYavg(i,1) - TargetY(i,1);
        
        close
    end
    fprintf('Reach #%i: avg: %f, Target: %f, error: %f\n', i, EyeAloneNoFeedback.EyeYavg(i,1), TargetY(i,1), EyeAloneNoFeedback.EyeYerror(i,1))
end

temp = isfinite(EyeAloneNoFeedback.EyeYerror);
EyeAloneNoFeedback.RMSE_EyeY = sqrt(mean(EyeAloneNoFeedback.EyeYerror(temp).^2));
fprintf('\nEyeY RMSE: %f (mm)\n\n', EyeAloneNoFeedback.RMSE_EyeY)

%% Eye Hand Feedback: (Eye X)

bounds = zeros(n,2);
TargetX = zeros(n,1);

fprintf('Eye Hand Feedback (EyeX): \n\n')

for i = 1:1:n
    idx = find(EyeHandFeedback.ReachNumber == i);
    
    if i == 13 || i == 34 || i == 45
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandFeedback.EyeXavg(i,1) = NaN;
        EyeHandFeedback.EyeXerror(i,1) = NaN;
        TargetX(i,1) = NaN;
        fprintf('    Skip reach #%i (blink trial)\n', i)
        continue
    elseif EyeHandFeedback.TargetX(round(median(idx)) - 50) == 604.8285
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandFeedback.EyeXavg(i,1) = NaN;
        EyeHandFeedback.EyeXerror(i,1) = NaN;
        TargetX(i,1) = NaN;
        fprintf('    Skip reach #%i (y-direction trial)\n', i)
        continue
    else
        figure
        plot(EyeHandFeedback.Time(idx), EyeHandFeedback.EyeX_F_NBT(idx))
        hold on
        plot(EyeHandFeedback.Time(idx), EyeHandFeedback.TargetX_NBT(idx))
        title(['EyeHandFeedback (Eye X): Reach # ',num2str(i)])
        
        temp = ginput(2);
        
        bounds(i,1) = temp(1,1);
        bounds(i,2) = temp(2,1);
        idx2 = find(EyeHandFeedback.Time <= bounds(i,2) & EyeHandFeedback.Time >= bounds(i,1));
        EyeHandFeedback.EyeXavg(i,1) = mean(EyeHandFeedback.EyeX_F_NBT(idx2));
        TargetX(i,1) = mode(EyeHandFeedback.TargetX(idx2));
        EyeHandFeedback.EyeXerror(i,1) = EyeHandFeedback.EyeXavg(i,1) - TargetX(i,1);

        close
    end
    fprintf('Reach #%i: avg: %f, Target: %f, error: %f\n', i, EyeHandFeedback.EyeXavg(i,1), TargetX(i,1), EyeHandFeedback.EyeXerror(i,1))
end

temp = isfinite(EyeHandFeedback.EyeXerror);
EyeHandFeedback.RMSE_EyeX = sqrt(mean(EyeHandFeedback.EyeXerror(temp).^2));
fprintf('\nEyeX RMSE: %f (mm)\n\n', EyeHandFeedback.RMSE_EyeX)

%% Eye Hand Feedback: (Eye Y)

bounds = zeros(n,2);
TargetY = zeros(n,1);

fprintf('Eye Hand Feedback (EyeY): \n\n')

for i = 1:1:n
    idx = find(EyeHandFeedback.ReachNumber == i);
    
    if i == 13 || i == 34 || i == 45
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandFeedback.EyeYavg(i,1) = NaN;
        EyeHandFeedback.EyeYerror(i,1) = NaN;
        TargetY(i,1) = NaN;
        fprintf('    Skip reach #%i (blink trial)\n', i)
        continue
    elseif EyeHandFeedback.TargetY(round(median(idx)) - 50) >= 455.6 && EyeHandFeedback.TargetY(round(median(idx)) - 50) <= 455.7
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandFeedback.EyeYavg(i,1) = NaN;
        EyeHandFeedback.EyeYerror(i,1) = NaN;
        TargetY(i,1) = NaN;
        fprintf('    Skip reach #%i (x-direction trial)\n', i)
        continue
    else
        figure
        plot(EyeHandFeedback.Time(idx), EyeHandFeedback.EyeY_F_NBT(idx))
        hold on
        plot(EyeHandFeedback.Time(idx), EyeHandFeedback.TargetY_NBT(idx))
        title(['EyeHandFeedback (Eye Y): Reach # ',num2str(i)])
        
        temp = ginput(2);
        
        bounds(i,1) = temp(1,1);
        bounds(i,2) = temp(2,1);
        idx2 = find(EyeHandFeedback.Time <= bounds(i,2) & EyeHandFeedback.Time >= bounds(i,1));
        EyeHandFeedback.EyeYavg(i,1) = mean(EyeAloneFeedback.EyeY_F_NBT(idx2));
        TargetY(i,1) = mode(EyeHandFeedback.TargetY(idx2));
        EyeHandFeedback.EyeYerror(i,1) = EyeHandFeedback.EyeYavg(i,1) - TargetY(i,1);
        
        close
    end
    fprintf('Reach #%i: avg: %f, Target: %f, error: %f\n', i, EyeHandFeedback.EyeYavg(i,1), TargetY(i,1), EyeHandFeedback.EyeYerror(i,1))
end

temp = isfinite(EyeHandFeedback.EyeYerror);
EyeHandFeedback.RMSE_EyeY = sqrt(mean(EyeHandFeedback.EyeYerror(temp).^2));
fprintf('\nEyeY RMSE: %f (mm)\n\n', EyeHandFeedback.RMSE_EyeY)

%% Eye Hand Feedback: (Hand X)

bounds = zeros(n,2);
TargetX = zeros(n,1);

fprintf('Eye Hand Feedback (HandX): \n\n')

for i = 1:1:n
    idx = find(EyeHandFeedback.ReachNumber == i);
    
    if i == 13 || i == 34 || i == 45
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandFeedback.HandXavg(i,1) = NaN;
        EyeHandFeedback.HandXerror(i,1) = NaN;
        TargetX(i,1) = NaN;
        fprintf('    Skip reach #%i (blink trial)\n', i)
        continue
    elseif EyeHandFeedback.TargetX(round(median(idx)) - 50) == 604.8285
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandFeedback.HandXavg(i,1) = NaN;
        EyeHandFeedback.HandXerror(i,1) = NaN;
        TargetX(i,1) = NaN;
        fprintf('    Skip reach #%i (y-direction trial)\n', i)
        continue
    else
        figure
        plot(EyeHandFeedback.Time(idx), EyeHandFeedback.HandX_NBT(idx))
        hold on
        plot(EyeHandFeedback.Time(idx), EyeHandFeedback.TargetX_NBT(idx))
        title(['EyeHandFeedback (Hand X): Reach # ',num2str(i)])
        
        temp = ginput(2);
        
        bounds(i,1) = temp(1,1);
        bounds(i,2) = temp(2,1);
        idx2 = find(EyeHandFeedback.Time <= bounds(i,2) & EyeHandFeedback.Time >= bounds(i,1));
        EyeHandFeedback.HandXavg(i,1) = mean(EyeHandFeedback.HandX_NBT(idx2));
        TargetX(i,1) = mode(EyeHandFeedback.TargetX(idx2));
        EyeHandFeedback.HandXerror(i,1) = EyeHandFeedback.HandXavg(i,1) - TargetX(i,1);

        close
    end
    fprintf('Reach #%i: avg: %f, Target: %f, error: %f\n', i, EyeHandFeedback.HandXavg(i,1), TargetX(i,1), EyeHandFeedback.HandXerror(i,1))
end

temp = isfinite(EyeHandFeedback.HandXerror);
EyeHandFeedback.RMSE_HandX = sqrt(mean(EyeHandFeedback.HandXerror(temp).^2));
fprintf('\nHandX RMSE: %f (mm)\n\n', EyeHandFeedback.RMSE_HandX)

%% Eye Hand Feedback: (Hand Y)

bounds = zeros(n,2);
TargetY = zeros(n,1);

fprintf('Eye Hand Feedback (HandY): \n\n')

for i = 1:1:n
    idx = find(EyeHandFeedback.ReachNumber == i);
    
    if i == 13 || i == 34 || i == 45
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandFeedback.HandYavg(i,1) = NaN;
        EyeHandFeedback.HandYerror(i,1) = NaN;
        TargetY(i,1) = NaN;
        fprintf('    Skip reach #%i (blink trial)\n', i)
        continue
    elseif EyeHandFeedback.TargetY(round(median(idx)) - 50) >= 455.6 && EyeHandFeedback.TargetY(round(median(idx)) - 50) <= 455.7
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandFeedback.HandYavg(i,1) = NaN;
        EyeHandFeedback.HandYerror(i,1) = NaN;
        TargetY(i,1) = NaN;
        fprintf('    Skip reach #%i (y-direction trial)\n', i)
        continue
    else
        figure
        plot(EyeHandFeedback.Time(idx), EyeHandFeedback.HandY_NBT(idx))
        hold on
        plot(EyeHandFeedback.Time(idx), EyeHandFeedback.TargetY_NBT(idx))
        title(['EyeHandFeedback (Hand Y): Reach # ',num2str(i)])
        
        temp = ginput(2);
        
        bounds(i,1) = temp(1,1);
        bounds(i,2) = temp(2,1);
        idx2 = find(EyeHandFeedback.Time <= bounds(i,2) & EyeHandFeedback.Time >= bounds(i,1));
        EyeHandFeedback.HandYavg(i,1) = mean(EyeHandFeedback.HandY_NBT(idx2));
        TargetY(i,1) = mode(EyeHandFeedback.TargetY(idx2));
        EyeHandFeedback.HandYerror(i,1) = EyeHandFeedback.HandYavg(i,1) - TargetY(i,1);

        close
    end
    fprintf('Reach #%i: avg: %f, Target: %f, error: %f\n', i, EyeHandFeedback.HandYavg(i,1), TargetY(i,1), EyeHandFeedback.HandYerror(i,1))
end

temp = isfinite(EyeHandFeedback.HandYerror);
EyeHandFeedback.RMSE_HandY = sqrt(mean(EyeHandFeedback.HandYerror(temp).^2));
fprintf('\nHandY RMSE: %f (mm)\n\n', EyeHandFeedback.RMSE_HandY)


%% Eye Hand No Feedback: (Eye X)

bounds = zeros(n,2);
TargetX = zeros(n,1);

fprintf('Eye Hand No Feedback (EyeX): \n\n')

for i = 1:1:n
    idx = find(EyeHandNoFeedback.ReachNumber == i);
    
    if i == 25 || i == 39 || i == 45
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandNoFeedback.EyeXavg(i,1) = NaN;
        EyeHandNoFeedback.EyeXerror(i,1) = NaN;
        TargetX(i,1) = NaN;
        fprintf('    Skip reach #%i (blink trial)\n', i)
        continue
    elseif EyeHandNoFeedback.TargetX(round(median(idx)) - 50) == 604.8285
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandNoFeedback.EyeXavg(i,1) = NaN;
        EyeHandNoFeedback.EyeXerror(i,1) = NaN;
        TargetX(i,1) = NaN;
        fprintf('    Skip reach #%i (y-direction trial)\n', i)
        continue
    else
        figure
        plot(EyeHandNoFeedback.Time(idx), EyeHandNoFeedback.EyeX_F_NBT(idx))
        hold on
        plot(EyeHandNoFeedback.Time(idx), EyeHandNoFeedback.TargetX_NBT(idx))
        title(['EyeHandNoFeedback (Eye X): Reach # ',num2str(i)])
        
        temp = ginput(2);
        
        bounds(i,1) = temp(1,1);
        bounds(i,2) = temp(2,1);
        idx2 = find(EyeHandNoFeedback.Time <= bounds(i,2) & EyeHandNoFeedback.Time >= bounds(i,1));
        EyeHandNoFeedback.EyeXavg(i,1) = mean(EyeHandNoFeedback.EyeX_F_NBT(idx2));
        TargetX(i,1) = mode(EyeHandNoFeedback.TargetX(idx2));
        EyeHandNoFeedback.EyeXerror(i,1) = EyeHandNoFeedback.EyeXavg(i,1) - TargetX(i,1);

        close
    end
    fprintf('Reach #%i: avg: %f, Target: %f, error: %f\n', i, EyeHandNoFeedback.EyeXavg(i,1), TargetX(i,1), EyeHandNoFeedback.EyeXerror(i,1))
end

temp = isfinite(EyeHandNoFeedback.EyeXerror);
EyeHandNoFeedback.RMSE_EyeX = sqrt(mean(EyeHandNoFeedback.EyeXerror(temp).^2));
fprintf('\nEyeX RMSE: %f (mm)\n\n', EyeHandNoFeedback.RMSE_EyeX)

%% Eye Hand No Feedback: (Eye Y)

bounds = zeros(n,2);
TargetY = zeros(n,1);

fprintf('Eye Hand No Feedback (EyeY): \n\n')

for i = 1:1:n
    idx = find(EyeHandNoFeedback.ReachNumber == i);
    
    if i == 25 || i == 39 || i == 45
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandNoFeedback.EyeYavg(i,1) = NaN;
        EyeHandNoFeedback.EyeYerror(i,1) = NaN;
        TargetY(i,1) = NaN;
        fprintf('    Skip reach #%i (blink trial)\n', i)
        continue
    elseif EyeHandNoFeedback.TargetY(round(median(idx)) - 50) >= 455.6 && EyeHandNoFeedback.TargetY(round(median(idx)) - 50) <= 455.7
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandNoFeedback.EyeYavg(i,1) = NaN;
        EyeHandNoFeedback.EyeYerror(i,1) = NaN;
        TargetY(i,1) = NaN;
        fprintf('    Skip reach #%i (x-direction trial)\n', i)
        continue
    else
        figure
        plot(EyeHandNoFeedback.Time(idx), EyeHandNoFeedback.EyeY_F_NBT(idx))
        hold on
        plot(EyeHandNoFeedback.Time(idx), EyeHandNoFeedback.TargetY_NBT(idx))
        title(['EyeHandNoFeedback (Eye Y): Reach # ',num2str(i)])
        
        temp = ginput(2);
        
        bounds(i,1) = temp(1,1);
        bounds(i,2) = temp(2,1);
        idx2 = find(EyeHandNoFeedback.Time <= bounds(i,2) & EyeHandNoFeedback.Time >= bounds(i,1));
        EyeHandNoFeedback.EyeYavg(i,1) = mean(EyeAloneFeedback.EyeY_F_NBT(idx2));
        TargetY(i,1) = mode(EyeHandNoFeedback.TargetY(idx2));
        EyeHandNoFeedback.EyeYerror(i,1) = EyeHandNoFeedback.EyeYavg(i,1) - TargetY(i,1);
        
        close
    end
    fprintf('Reach #%i: avg: %f, Target: %f, error: %f\n', i, EyeHandNoFeedback.EyeYavg(i,1), TargetY(i,1), EyeHandNoFeedback.EyeYerror(i,1))
end

temp = isfinite(EyeHandNoFeedback.EyeYerror);
EyeHandNoFeedback.RMSE_EyeY = sqrt(mean(EyeHandNoFeedback.EyeYerror(temp).^2));
fprintf('\nEyeY RMSE: %f (mm)\n\n', EyeHandNoFeedback.RMSE_EyeY)

%% Eye Hand No Feedback: (Hand X)

bounds = zeros(n,2);
TargetX = zeros(n,1);

fprintf('Eye Hand No Feedback (HandX): \n\n')

for i = 1:1:n
    idx = find(EyeHandNoFeedback.ReachNumber == i);
    
    if i == 25 || i == 39 || i == 45
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandNoFeedback.HandXavg(i,1) = NaN;
        EyeHandNoFeedback.HandXerror(i,1) = NaN;
        TargetX(i,1) = NaN;
        fprintf('    Skip reach #%i (blink trial)\n', i)
        continue
    elseif EyeHandNoFeedback.TargetX(round(median(idx)) - 50) == 604.8285
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandNoFeedback.HandXavg(i,1) = NaN;
        EyeHandNoFeedback.HandXerror(i,1) = NaN;
        TargetX(i,1) = NaN;
        fprintf('    Skip reach #%i (y-direction trial)\n', i)
        continue
    else
        figure
        plot(EyeHandNoFeedback.Time(idx), EyeHandNoFeedback.HandX_NBT(idx))
        hold on
        plot(EyeHandNoFeedback.Time(idx), EyeHandNoFeedback.TargetX_NBT(idx))
        title(['EyeHandNoFeedback (Hand X): Reach # ',num2str(i)])
        
        temp = ginput(2);
        
        bounds(i,1) = temp(1,1);
        bounds(i,2) = temp(2,1);
        idx2 = find(EyeHandNoFeedback.Time <= bounds(i,2) & EyeHandNoFeedback.Time >= bounds(i,1));
        EyeHandNoFeedback.HandXavg(i,1) = mean(EyeHandNoFeedback.HandX_NBT(idx2));
        TargetX(i,1) = mode(EyeHandNoFeedback.TargetX(idx2));
        EyeHandNoFeedback.HandXerror(i,1) = EyeHandNoFeedback.HandXavg(i,1) - TargetX(i,1);

        close
    end
    fprintf('Reach #%i: avg: %f, Target: %f, error: %f\n', i, EyeHandNoFeedback.HandXavg(i,1), TargetX(i,1), EyeHandNoFeedback.HandXerror(i,1))
end

temp = isfinite(EyeHandNoFeedback.HandXerror);
EyeHandNoFeedback.RMSE_HandX = sqrt(mean(EyeHandNoFeedback.HandXerror(temp).^2));
fprintf('\nHandX RMSE: %f (mm)\n\n', EyeHandNoFeedback.RMSE_HandX)

%% Eye Hand No Feedback: (Hand Y)

bounds = zeros(n,2);
TargetY = zeros(n,1);

fprintf('Eye Hand No Feedback (HandY): \n\n')

for i = 1:1:n
    idx = find(EyeHandNoFeedback.ReachNumber == i);
    
    if i == 25 || i == 39 || i == 45
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandNoFeedback.HandYavg(i,1) = NaN;
        EyeHandNoFeedback.HandYerror(i,1) = NaN;
        TargetY(i,1) = NaN;
        fprintf('    Skip reach #%i (blink trial)\n', i)
        continue
    elseif EyeHandNoFeedback.TargetY(round(median(idx)) - 50) >= 455.6 && EyeHandNoFeedback.TargetY(round(median(idx)) - 50) <= 455.7
        bounds(i,1) = NaN;
        bounds(i,2) = NaN;
        EyeHandNoFeedback.HandYavg(i,1) = NaN;
        EyeHandNoFeedback.HandYerror(i,1) = NaN;
        TargetY(i,1) = NaN;
        fprintf('    Skip reach #%i (y-direction trial)\n', i)
        continue
    else
        figure
        plot(EyeHandNoFeedback.Time(idx), EyeHandNoFeedback.HandY_NBT(idx))
        hold on
        plot(EyeHandNoFeedback.Time(idx), EyeHandNoFeedback.TargetY_NBT(idx))
        title(['EyeHandNoFeedback (Hand Y): Reach # ',num2str(i)])
        
        temp = ginput(2);
        
        bounds(i,1) = temp(1,1);
        bounds(i,2) = temp(2,1);
        idx2 = find(EyeHandNoFeedback.Time <= bounds(i,2) & EyeHandNoFeedback.Time >= bounds(i,1));
        EyeHandNoFeedback.HandYavg(i,1) = mean(EyeHandNoFeedback.HandY_NBT(idx2));
        TargetY(i,1) = mode(EyeHandNoFeedback.TargetY(idx2));
        EyeHandNoFeedback.HandYerror(i,1) = EyeHandNoFeedback.HandYavg(i,1) - TargetY(i,1);

        close
    end
    fprintf('Reach #%i: avg: %f, Target: %f, error: %f\n', i, EyeHandNoFeedback.HandYavg(i,1), TargetY(i,1), EyeHandNoFeedback.HandYerror(i,1))
end

temp = isfinite(EyeHandNoFeedback.HandYerror);
EyeHandNoFeedback.RMSE_HandY = sqrt(mean(EyeHandNoFeedback.HandYerror(temp).^2));
fprintf('\nHandY RMSE: %f (mm)\n\n', EyeHandNoFeedback.RMSE_HandY)
