function [expValCond, hApprox] = condProbDiscApprox(P11, P12, P21, P22, M11, M12, M21, M22, S11,...
                                                    S12, S21, S22)
num_points = 10000;
X1Approx = gausianMultimodalGenerate(P11, P12, M11, M12, S11, S12, num_points);
m = size(X1Approx, 1);
hApprox = zeros(m, 1);

for i = 1 : m
    tempInput = X1Approx(i, :)';
    f1Approx = gausianMultimodal(tempInput, P11, P12, M11, M12, S11, S12);
    f2Approx = gausianMultimodal(tempInput, P21, P22, M21, M22, S21, S22);
    hApprox(i) = log(f2Approx) - log(f1Approx);
end

[condProb, bins] = histcounts(hApprox, 100, 'Normalization', 'pdf');

expValCond = 0;
step = bins(2) - bins(1);
for i = 1 :  length(condProb)
    x = (bins(i) + bins(i + 1)) /2;
    expValCond = expValCond + x * condProb(i) * step;
end

end

