function plotReach_EAFB(reachNumber, direction)

global EyeAloneFeedback EyeAloneNoFeedback EyeHandFeedback EyeHandNoFeedback

    idx = find(EyeAloneFeedback.ReachNumber == reachNumber | EyeAloneFeedback.ReachNumber == reachNumber-1);
    
    if direction == 'X'
        plot(EyeAloneFeedback.Time(idx), EyeAloneFeedback.EyeX(idx))
        hold on
        plot(EyeAloneFeedback.Time(idx), EyeAloneFeedback.TargetX(idx))
        plot(EyeAloneFeedback.Time(idx), 604.8285*ones(length(idx),1), 'r--', 'LineWidth', 2)
    elseif direction == 'Y'
        plot(EyeAloneFeedback.Time(idx), EyeAloneFeedback.EyeY(idx))
        hold on
        plot(EyeAloneFeedback.Time(idx), EyeAloneFeedback.TargetY(idx))
        plot(EyeAloneFeedback.Time(idx), 455.6125*ones(length(idx),1), 'r--', 'LineWidth', 2)

    elseif direction == 'XY'
        plot(EyeAloneFeedback.EyeX(idx), EyeAloneFeedback.EyeY(idx))
    else
        disp('Invalid syntax')
    end
end