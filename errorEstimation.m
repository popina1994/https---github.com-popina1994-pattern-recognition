function [epsilon1,epsilon2] = errorEstimation(f1, f2, disFunction, num_rows, num_cols, step)

epsilon1 = 0;
epsilon2 = 0;

for i = 1 : num_rows
    for j = 1 : num_cols
        if (disFunction(i, j) < 0)
            epsilon2 = epsilon2+ f2(i, j) * step^2;
        else 
            epsilon1 = epsilon1 + f1(i, j) * step^2;
        end
    end
end

end

