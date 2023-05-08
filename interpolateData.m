% This code interpolates missing data

% Screen Coordinates................X: [ 0 1920]
%                                   Y: [ 0 1032]
% iSCAN Coordinates.................X: [18  511]
%                                   Y: [18  467]
% Optotrak Coordinates..............X: [ 0 1210]
%                                   Y: [ 0  651]

last_known_positionEyeX = 604.8285;
last_known_positionEyeY = 455.6125;
last_known_positionHandX = 604.8285;
last_known_positionHandY = 455.6125;

% Eye-Alone Feedback
for n = 1:1:length(EyeAloneFeedback.Time)
    if EyeAloneFeedback.EyeX(n) == 0 || EyeAloneFeedback.EyeX(n) >= 1000
        EyeAloneFeedback.EyeX(n) = last_known_positionEyeX;
        
    else
        last_known_positionEyeX = EyeAloneFeedback.EyeX(n);
    end
    
    if EyeAloneFeedback.EyeY(n) == 0  || EyeAloneFeedback.EyeY(n) >= 640
        EyeAloneFeedback.EyeY(n) = last_known_positionEyeY;
    else
        last_known_positionEyeY = EyeAloneFeedback.EyeY(n);
    end
end

% Eye-Alone No Feedback
for n = 1:1:length(EyeAloneNoFeedback.Time)
    if EyeAloneNoFeedback.EyeX(n) == 0 || EyeAloneNoFeedback.EyeX(n) >= 1000
        EyeAloneNoFeedback.EyeX(n) = last_known_positionX;
        
    else
        last_known_positionX = EyeAloneNoFeedback.EyeX(n);
    end
    
    if EyeAloneNoFeedback.EyeY(n) == 0 || EyeAloneNoFeedback.EyeY(n) >= 640
        EyeAloneNoFeedback.EyeY(n) = last_known_positionY;
    else
        last_known_positionY = EyeAloneNoFeedback.EyeY(n);
    end
end

% Eye-Hand Feedback
for n = 1:1:length(EyeHandFeedback.Time)
    if EyeHandFeedback.EyeX(n) == 0 || EyeHandFeedback.EyeX(n) >= 1000
        EyeHandFeedback.EyeX(n) = last_known_positionEyeX;
        
    else
        last_known_positionEyeX = EyeHandFeedback.EyeX(n);
    end
    
    if EyeHandFeedback.EyeY(n) == 0 || EyeHandFeedback.EyeY(n) >= 640
        EyeHandFeedback.EyeY(n) = last_known_positionEyeY;
    else
        last_known_positionEyeY = EyeHandFeedback.EyeY(n);
    end
    
    if EyeHandFeedback.HandX(n) == 0 || EyeHandFeedback.HandX(n) >= 1000
        EyeHandFeedback.HandX(n) = last_known_positionHandX;
        
    else
        last_known_positionHandX = EyeHandFeedback.HandX(n);
    end
    
    if EyeHandFeedback.HandY(n) == 0 || EyeHandFeedback.HandY(n) >= 640
        EyeHandFeedback.HandY(n) = last_known_positionHandY;
    else
        last_known_positionHandY = EyeHandFeedback.HandY(n);
    end
end

% Eye-Hand No Feedback
for n = 1:1:length(EyeHandNoFeedback.Time)
    if EyeHandNoFeedback.EyeX(n) == 0 || EyeHandNoFeedback.EyeX(n) >= 1000
        EyeHandNoFeedback.EyeX(n) = last_known_positionEyeX;
        
    else
        last_known_positionEyeX = EyeHandNoFeedback.EyeX(n);
    end
    
    if EyeHandNoFeedback.EyeY(n) == 0 || EyeHandNoFeedback.EyeY(n) >= 640
        EyeHandNoFeedback.EyeY(n) = last_known_positionEyeY;
    else
        last_known_positionEyeY = EyeHandNoFeedback.EyeY(n);
    end
    
    if EyeHandNoFeedback.HandX(n) == 0 || EyeHandNoFeedback.HandX(n) >= 1000
        EyeHandNoFeedback.HandX(n) = last_known_positionHandX;
        
    else
        last_known_positionHandX = EyeHandNoFeedback.HandX(n);
    end
    
    if EyeHandNoFeedback.HandY(n) == 0 || EyeHandNoFeedback.HandY(n) >= 640
        EyeHandNoFeedback.HandY(n) = last_known_positionHandY;
    else
        last_known_positionHandY = EyeHandNoFeedback.HandY(n);
    end
end