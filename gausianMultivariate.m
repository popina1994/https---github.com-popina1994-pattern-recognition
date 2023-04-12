function [Y] = gausianMultivariate(X, Mx, Sx)
%GAUSIANMULTIVARIATE Summary of this function goes here
%   Detailed explanation goes here

n = size(Sx, 1);
Y = (1 / ((2 * pi) ^(n / 2)  * sqrt(det(Sx)))) * exp((X - Mx)' * inv(Sx) * (X - Mx) / -2);

end

