function [classIdx, i] = waldosTest(X, epsilon1, epsilon2, P11, P12, P21, P22, ...
                                        M11, M12, M21, M22, S11, S12, S21, S22)
%WALDOSTEST Summary of this function goes here
%   Detailed explanation goes here

a = -log((1 - epsilon1) / epsilon2);
b = -log(epsilon1 / ( 1 - epsilon2));

num_points = size(X, 1);
testCases = 25;
sumI = 0;

for testIdx = 1 : testCases
    idx = randperm(num_points);

    i = 1;

    s = -log(gausianMultimodal(X(idx(i), :)', P11, P12, M11, M12, S11, S12)) + ...
           log(gausianMultimodal(X(idx(i), :)', P21, P22, M21, M22, S21, S22)) ;
    
    while ((i + 1 <= num_points) && (s < b) && (s > a))
        i = i + 1;
        s = s + -log(gausianMultimodal(X(idx(i), :)', P11, P12, M11, M12, S11, S12)) + ...
           log(gausianMultimodal(X(idx(i), :)', P21, P22, M21, M22, S21, S22));
    end

    sumI = sumI + i;

    if (s <= a)
        classIdx = 1;
    elseif (s >= b)
        classIdx = 2;
    else 
        classIdx = 0;
    end

end
i = sumI / testCases;

end

