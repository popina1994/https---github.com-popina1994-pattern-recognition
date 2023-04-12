function [epsilon1, epsilon2, epsilon] = errorEstimationEO(U, W, num_points)
    Y = U' * W;
    epsilon = numel(Y(Y < 0)) / (2 * num_points);
    epsilon1 = 0;
    epsilon2 = 0;
    for i = 1 : num_points
        epsilon1 =  (Y(2 * i - 1) < 0) + epsilon1;
        epsilon2 = (Y(2 * i) < 0) + epsilon2;
    end
    epsilon1 = epsilon1 / num_points;
    epsilon2 = epsilon2 / num_points;
end

