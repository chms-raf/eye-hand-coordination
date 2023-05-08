function [fixations, fixationIndices] = computeFixations(xData,yData,peakIndices,radius)

% This code computes fixations from gaze data

shortestDistance = 0;
while shortestDistance < radius
    fixationsX = 0;
    fixationsY = 0;
    fixationIndices = 0;
    for n = 2:1:length(peakIndices)
        if fixationsX(1,1) == 0
            fixationsX = median(xData(peakIndices(n-1):peakIndices(n),1));
            fixationIndices = peakIndices(n-1);
        else
            fixationsX = [fixationsX; median(xData(peakIndices(n-1):peakIndices(n),1))];
            fixationIndices = [fixationIndices; peakIndices(n-1)];
        end
        
        if fixationsY(1,1) == 0
            fixationsY = median(yData(peakIndices(n-1):peakIndices(n),1));
            fixationIndices = peakIndices(n-1);
        else
            fixationsY = [fixationsY; median(yData(peakIndices(n-1):peakIndices(n),1))];
            %fixationIndices = [fixationIndices; peakIndices(n-1)];
        end
    end
    
    fixations = [fixationsX, fixationsY];
    
    shortestDistance = inf;
    
    for n = 2:1:length(fixationsX)
        distance = peakIndices(n,1) - peakIndices(n-1,1);
        if distance < shortestDistance
            shortestDistance = distance;
            index = n;
        end
    end
    
    if shortestDistance < radius
        peakIndices(index) = [];
    end
end
end