function h = drawCircle(x, y, z, Radius, numberOfSides, color)

slopeX = 1.0 * (1920 - 0) / (1210 - 0);
x = slopeX * (x - 0);

slopeY = 1.0 * (1032 - 0) / (651 - 0);
y = slopeY * (y - 0);

numberOfVertices = numberOfSides + 2;
    
twicePi = 2 * pi;
    
circleVerticesX = zeros(numberOfVertices,1);
circleVerticesY = zeros(numberOfVertices,1);
circleVerticesZ = zeros(numberOfVertices,1);
    
circleVerticesX(1) = x;
circleVerticesY(1) = y;
circleVerticesZ(1) = z;
    
for i = 2:1:numberOfVertices
    circleVerticesX(i) = x + (Radius * cos(i * twicePi / numberOfSides));
    circleVerticesY(i) = y + (Radius * sin(i * twicePi / numberOfSides));
    circleVerticesZ(i) = z;
end
    
allCircleVertices = zeros(numberOfVertices*3,1);
    
for i = 1:1:numberOfVertices
    allCircleVertices(i * 3) = circleVerticesX(i);
    allCircleVertices(( i * 3 ) + 1) = circleVerticesY(i);
    allCircleVertices(( i * 3 ) + 2) = circleVerticesZ(i);
end

slopeX = 1.0 * (1210 - 0) / (1920 - 0);
circleVerticesX_mm = slopeX * (circleVerticesX - 0);

slopeY = 1.0 * (651 - 0) / (1032 - 0);
circleVerticesY_mm = slopeY * (circleVerticesY - 0);

h = plot(circleVerticesX_mm(2:end), circleVerticesY_mm(2:end), color, 'LineWidth', 2);

end