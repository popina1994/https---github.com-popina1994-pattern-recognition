function [X] = gausianMultivariateGenerate(Mx, Sx, num_points)
% Generates a matrix whose size is num_points, also it has 
% gausian multivarate distribution with Mx mean and 
% Sx covariance matrix. 

[F, L] = eig(Sx);

n = size(Sx, 1);
X = randn(n, num_points);

for i = 1 : num_points
    X(1:n, i) = F * sqrt(L) * X(1:n, i) + Mx; 
end

end

