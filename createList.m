function peakIndices = createList(time,threshold,peak)

% This code creates a list with peak indices

peakIndices = 0;

for n = 1:1:length(time)
    if peak(n,1) >= threshold
        if peakIndices == 0
            peakIndices = n;
        else
            peakIndices = [peakIndices; n];
        end
    end
end
end