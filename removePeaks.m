function peak = removePeaks(time,peak,h)

% This code removes peaks that are too close together

% not sure if r value needs to stay the same or not
for n = h+1:1:length(time)-h
    if peak(n,1) ~= 0
        for i = n-h:1:n-1
            if peak(i,1) < peak(n,1)
                peak(i,1) = 0;
            end
        end
        for ii = n+1:1:n+h
            if peak(ii,1) < peak(n,1)
                peak(ii,1) = 0;
            end
        end
    end
end
end