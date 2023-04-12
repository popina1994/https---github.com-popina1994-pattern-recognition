function [center] = calculateCenter(X)
    [numRow, numCol] = size(X);
    centerX = 0;
    centerY = 0;
    for row = 1 : numRow
        for col = 1 : numCol
           val = floor(double(X(row, col)));
           centerX = centerX + val * (row - floor(numRow / 2));
           centerY = centerY + val * (col - floor(numCol / 2));
        end
    end
    center = [centerX; centerY] / (numRow * numCol);
end

