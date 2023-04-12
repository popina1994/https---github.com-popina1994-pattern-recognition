function [X1, X2, X3, X4, X5, changed] = reClusterQuadr(Y, M, S, P, curId)
%RECLUSTTER Summary of this function goes here
%   Detailed explanation goes here
changed = 0;
X1 = [];
X2 = [];
X3 = [];
X4 = [];
X5 = [];
 for i = 1 : size(Y, 1)
        clusterId = findClosesestDistQuadr(Y(i, :), M, S, P);
        if clusterId ~= curId
            changed = 1;
        end
        switch clusterId
            case 1
                X1 = [X1; Y(i, :)];
            case 2
                X2 = [X2; Y(i, :)];
             case 3
                X3 = [X3; Y(i, :)];
             case 4
                X4 = [X4; Y(i, :)];
            case 5
                X5 = [X5;  Y(i, :)];
        end
    end
end

