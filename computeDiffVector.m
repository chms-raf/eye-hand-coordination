function d = computeDiffVector(time, xData, yData, r)
% This code calculates the difference vector

d = zeros(length(time),1);

for n = r+1:1:length(time)-r
    mubx = 0;       % x mean before
    muby = 0;       % y mean before
    muax = 0;       % x mean after
    muay = 0;       % y mean after
    
    for i = 1:1:r
        mubx = mubx+xData(n-r)/r;
        muby = muby+yData(n-r)/r;
        muax = muax+xData(n+r)/r;
        muay = muay+yData(n+r)/r;
    end
    d(n,1) = sqrt((muax - mubx)^2 + (muay - muby)^2);
end
end