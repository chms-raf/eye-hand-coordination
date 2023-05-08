function [handOnsetsX, handOnsetsY, handOnsetIndicesX, handOnsetIndicesY] = computeHandOnsets(time, Xdata, Ydata, vt)

% This code computes hand onsets using a velocity threshold

% Filter Parameters
Fs = 240;
Fcutoff = 10;

fnorm = Fcutoff/(Fs/2);
[b,a] = butter(2,fnorm);

%EyeHandNoFeedback
Xdata_unfiltered = Xdata;
Xdata = filtfilt(b,a,Xdata_unfiltered);

Ydata_unfiltered = Ydata;
Ydata = filtfilt(b,a,Ydata_unfiltered);

% figure
% subplot(2,1,1)
% plot(time, Xdata_unfiltered)
% hold on
% plot(time, Xdata)
% 
% subplot(2,1,2)
% plot(time, Ydata_unfiltered)
% hold on
% plot(time, Ydata)

% Calculate Hand Onsets based on velocity threshold (~10 cm/s)
vx = zeros(length(time)-1,1) ;
vy = zeros(length(time)-1,1) ;
handOnsetIndicesX = 0;
handOnsetIndicesY = 0;
for i = 2:length(time)
    vx(i) = .1*(Xdata(i)-Xdata(i-1))/(time(i)-time(i-1));
    if abs(vx(i-1)) < vt && abs(vx(i)) >= vt
        if handOnsetIndicesX == 0
            handOnsetIndicesX = i;
        else
            handOnsetIndicesX = [handOnsetIndicesX; i];
        end
    elseif abs(vx(i)) < vt && abs(vx(i-1)) >= vt
        if handOnsetIndicesX == 0
            handOnsetIndicesX = i;
        else
            handOnsetIndicesX = [handOnsetIndicesX; i];
        end
    end
    
    vy(i) = .1*(Ydata(i)-Ydata(i-1))/(time(i)-time(i-1));
    if abs(vy(i-1)) < vt && abs(vy(i)) >= vt
        if handOnsetIndicesY == 0
            handOnsetIndicesY = i;
        else
            handOnsetIndicesY = [handOnsetIndicesY; i];
        end
    elseif abs(vy(i)) < 10 && abs(vy(i-1)) > 10
        if handOnsetIndicesY == 0
            handOnsetIndicesY = i;
        else
            handOnsetIndicesY = [handOnsetIndicesY; i];
        end
    end
end

handOnsetsX = [time(handOnsetIndicesX) Xdata(handOnsetIndicesX)];
handOnsetsY = [time(handOnsetIndicesY) Ydata(handOnsetIndicesY)];

rt = 1.25; % Time threshold (~2s)
rr = 75; % Reach threshold (~100mm)

for i = 2:1:length(handOnsetsX)
    if handOnsetsX(i,1) - handOnsetsX(i-1,1) < rt && abs(handOnsetsX(i,2) - handOnsetsX(i-1,2)) < rr
        handOnsetsX(i,1) = mean([handOnsetsX(i,1), handOnsetsX(i-1,1)]);
        handOnsetsX(i,2) = mean([handOnsetsX(i,2), handOnsetsX(i-1,2)]);
        handOnsetIndicesX(i,1) = round(mean([handOnsetIndicesX(i,1), handOnsetIndicesX(i-1,1)]));
        handOnsetsX(i-1,1) = 0;
        handOnsetsX(i-1,2) = 0;
        handOnsetIndicesX(i-1,1) = 0;
    end
end

for i = 2:1:length(handOnsetsY)
    if handOnsetsY(i,1) - handOnsetsY(i-1,1) < rt && abs(handOnsetsY(i,2) - handOnsetsY(i-1,2)) < rr
        handOnsetsY(i,1) = mean([handOnsetsY(i,1), handOnsetsY(i-1,1)]);
        handOnsetsY(i,2) = mean([handOnsetsY(i,2), handOnsetsY(i-1,2)]);
        handOnsetIndicesY(i,1) = round(mean([handOnsetIndicesY(i,1), handOnsetIndicesY(i-1,1)]));
        handOnsetsY(i-1,1) = 0;
        handOnsetsY(i-1,2) = 0;
        handOnsetIndicesY(i-1,1) = 0;
    end
end

temp = find(handOnsetsX(:,1) == 0);
handOnsetsX(temp,:) = [];

temp = find(handOnsetsY(:,1) == 0);
handOnsetsY(temp,:) = [];

temp = find(handOnsetIndicesX == 0);
handOnsetIndicesX(temp) = [];

temp = find(handOnsetIndicesY == 0);
handOnsetIndicesY(temp) = [];

handOnsetsX = handOnsetsX(:,2);
handOnsetsY = handOnsetsY(:,2);

% Should be 156 X onsets and 44 Y onsets

end