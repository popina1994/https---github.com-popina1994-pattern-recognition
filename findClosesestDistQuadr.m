function [clusterId] = findClosesestDistQuadr(elem, M, S, P)
%FINDCLOSESESTDIST Summary of this function goes here
%   Detailed explanation goes here
distLen = size(M, 1);
distMinIdx = 0;
distMin = realmax;
for i = 1 : distLen
    curM = M(i, :);
    curS = S(2 * i - 1 : 2 * i, :);
    curP = P(i, :);
    if (S(2*i - 1, 1) > 10000)
        j = realmax;
    else
        j = (elem - curM) * inv(curS) * (elem - curM)' + log(det(curS)) - log(curP);
    end
    if (j < distMin)
        distMin = j;
        distMinIdx = i;
    end
end
clusterId = distMinIdx;

