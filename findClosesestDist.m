function [clusterId] = findClosesestDist(elem, center)
%FINDCLOSESESTDIST Summary of this function goes here
%   Detailed explanation goes here
distLen = size(center, 1);
distMinIdx = 0;
distMin = realmax;
for i = 1 : distLen
    curCenter = center(i, :);
    curDist = sqrt(sum((elem - curCenter).^2));
    if (curDist < distMin)
        distMin = curDist;
        distMinIdx = i;
    end
end
clusterId = distMinIdx;

