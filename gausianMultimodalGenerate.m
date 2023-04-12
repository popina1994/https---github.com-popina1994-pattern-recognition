function [X] = gausianMultimodalGenerate(P1,P2, M1, M2, S1, S2, num_points)
%GAUSIANMULTIMODAL Summary of this function goes here
%   Detailed explanation goes here
X = zeros(num_points, 2);
for i = 1 : num_points
    probability = rand(1, 1);
    if (probability < P1)
        X(i, :) = gausianMultivariateGenerate(M1, S1, 1);
    else
        X(i, :) = gausianMultivariateGenerate(M2, S2, 1);
    end
end
end

