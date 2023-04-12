function [f] = gausianMultimodal(X, P1, P2, M1, M2, S1, S2)
%GAUSIANMULTIMODAL Calculates multimodal probability density function.
% 
f = P1 * gausianMultivariate(X, M1, S1) + P2 * gausianMultivariate(X, M2, S2); 
end

