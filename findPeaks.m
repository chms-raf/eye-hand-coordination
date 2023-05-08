function peak = findPeaks(time,d)
% This code find peaks in data

peak = zeros(length(time),1);
for n = 2:1:length(time)-1
    if d(n,1) > d(n-1,1) && d(n,1) > d(n+1)
        peak(n,1) = d(n,1);
    end
end
end