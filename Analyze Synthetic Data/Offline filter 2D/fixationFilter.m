% This code demonstrates the Offline Fixation Filter.
% Based on Pontus Olsson paper (2007).
% Created by Jack Schultz, March 27th 2020

clear; clc; close all

% Signal mean changes
% changeX = [0 10 10 -10   0  10 -10  0 -10 0]';
% changeY = [0  0 10  10 -10 -10   0 10 -10 0]';

changeX = 10*randn(10,1);
changeY = 10*randn(10,1);
n = length(changeX);

% Time vector
fs = 100;
t = (1/fs:1/fs:n)';

% Initialize signal means
mux = inf;
muy = inf;

for i = 1:1:n
    if mux == inf
        mux = changeX(i)*ones(length(t)/n,1);
    else
        mux = [mux; changeX(i)*ones(length(t)/n,1)];
    end
end

for i = 1:1:n
    if muy == inf
        muy = changeY(i)*ones(length(t)/n,1);
    else
        muy = [muy; changeY(i)*ones(length(t)/n,1)];
    end
end

% Create signal with noise
sigmaX = .55;
sigmaY = .9;
x = mux + sigmaX*randn(length(t),1);
y = muy + sigmaY*randn(length(t),1);

% figure
% plot(t, x)
% hold on
% plot(t, mux)
% xlabel('Time (s)')
% ylabel('X-direction')
% 
% figure
% plot(t, y)
% hold on
% plot(t, muy)
% xlabel('Time (s)')
% ylabel('Y-direction')
% 
% figure
% plot(mux, muy, 'o')
% hold on
% plot(x, y)
% axis([-15 15 -15 15])
% xlabel('X-direction')
% ylabel('Y-direction')

%% Fixation Filter Algorithm

% Step 1: Interpolate missing data

    % Will need this for actual gaze data
    % If data is missing (blink, marker invisible, etc), set it 
    % equal to the last known data point available. In our case, if
    % the data is missing, it is set to zero.

    % pseudo code for this step -->

    %     for n = 1:1:length(t)
    %         if x(n) == 0
    %             last_known_position = x(n);
    %         else
    %             x(n) = last_known_position;
    %         end
    %         
    %         if y(n) == 0
    %             last_known_position = y(n);
    %         else
    %             y(n) = last_known_position;
    %         end
    %     end

% Step 2: Calculate the difference vector
r = 4;
d = zeros(length(t),1);

for n = r+1:1:length(t)-r
    mubx = 0;       % x mean before
    muby = 0;       % y mean before
    muax = 0;       % x mean after
    muay = 0;       % y mean after
    
    for i = 1:1:r
        mubx = mubx+x(n-r)/r;
        muby = muby+y(n-r)/r;
        muax = muax+x(n+r)/r;
        muay = muay+y(n+r)/r;
    end
    d(n,1) = sqrt((muax - mubx)^2 + (muay - muby)^2);
end

% Step 3: Find peaks in the difference vector
peak = zeros(length(t),1);

for n = 2:1:length(t)-1
    if d(n,1) > d(n-1,1) && d(n,1) > d(n+1)
        peak(n,1) = d(n,1);
    end
end

figure
plot(d)
hold on
plot(peak, 'o')
title('All Peaks Plotted')
xlabel('Time (s)')
ylabel('Spacial Distance')

% Step 4: Remove peaks that are too close to each other in time domain
r = 8; % not sure if this r value needs to stay the same or not
for n = r+1:1:length(t)-r
    if peak(n,1) ~= 0
        for i = n-r:1:n-1
            if peak(i,1) < peak(n,1)
                peak(i,1) = 0;
            end
        end
        for ii = n+1:1:n+r
            if peak(ii,1) < peak(n,1)
                peak(ii,1) = 0;
            end
        end
    end
end

figure
plot(d)
hold on
plot(peak, 'o')
title('Peaks removed that were too close together')
xlabel('Time (s)')
ylabel('Spacial Distance')

% Step 5: Create a list with peak indices
threshold = 5; % This should be based on typical saccade amplitude I think
peakIndices = 0;

for n = 1:1:length(t)
    if peak(n,1) >= threshold
        if peakIndices == 0
            peakIndices = n;
        else
            peakIndices = [peakIndices; n];
        end
    end
end

% Step 6: Estimate the spatial positions of the fixations
shortestDistance = 0;
radius = 2;
while shortestDistance < radius
    fixationsX = 0;
    fixationsY = 0;
    for n = 2:1:length(peakIndices)
        if fixationsX(1,1) == 0
            fixationsX = median(x(peakIndices(n-1):peakIndices(n),1));
        else
            fixationsX = [fixationsX; median(x(peakIndices(n-1):peakIndices(n),1))];
        end
        
         if fixationsY(1,1) == 0
            fixationsY = median(y(peakIndices(n-1):peakIndices(n),1));
        else
            fixationsY = [fixationsY; median(y(peakIndices(n-1):peakIndices(n),1))];
        end
    end
    
    fixations = [fixationsX, fixationsY];
    
    shortestDistance = inf;
    
    for n = 2:1:length(fixationsX)
        distance = norm(fixations(n,:) - fixations(n-1,:));
        if distance < shortestDistance
            shortestDistance = distance;
            index = n;
        end
    end
    
    if shortestDistance < radius
        peakIndices(index) = [];
    end
end

figure
plot(x,y,'r')
hold on
plot(changeX,changeY,'gx','MarkerSize',12,'LineWidth',2)
plot(fixations(:,1),fixations(:,2),'o','MarkerSize',12,'LineWidth',2)
title('2D Gaze Data with plotted fixation estimates')
xlabel('x-direction')
ylabel('y-direction')
legend('Gaze Data','Actual Fixations','Estimated Fixations')


%% Filter data

% This code high pass filters the data

fn = fs/2;
fc = 2.5;

[z,p] = butter(2,fc/fn,'high');
x_f = filtfilt(z,p,x);
y_f = filtfilt(z,p,y);

figure
norm = histfit(x_f);
[muHat, sigmaHat] = normfit(x_f);
% % Plot bounds at +- 3 * sigma.
% lowBound = muHat - 3 * sigmaHat;
% highBound = muHat + 3 * sigmaHat;
% yl = ylim;
% line([lowBound, lowBound], yl, 'Color', [0, .6, 0], 'LineWidth', 3);
% line([highBound, highBound], yl, 'Color', [0, .6, 0], 'LineWidth', 3);
% line([muHat, muHat], yl, 'Color', [0, .6, 0], 'LineWidth', 3);
% grid on;
% 
% figure
% subplot(1,2,1)
% histogram(x)
% 
% subplot(1,2,2)
% histogram(y)