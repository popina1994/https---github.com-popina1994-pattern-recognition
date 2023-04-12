clear all;
close all;
clc;


% The first class
P11 = 0.6;
M11 = [1.5 -4.5]';
S11 = [3.5 -1; -1 2.2];

P12 = 0.4;
M12 = [-0.5 0.5]';
S12 = [1.3 0.9; 0.9 2];

% The second class
P21 = 0.45;
M21 = [7.5 -3.5]';
S21 = [1.5 1.1; 1.1 1.5];

P22 = 0.55;
M22 = [4 2]';
S22 = [3 -0.8; -0.8 3];



num_points = 500 ;

% Plotting dataset
X1 = gausianMultimodalGenerate(P11, P12, M11, M12, S11, S12, num_points);
X2 = gausianMultimodalGenerate(P21, P22, M21, M22, S21, S22, num_points);

% Calculating probability density functions
step = 0.1;
xIt = -6 : step : 12;
yIt = -10 : step : 8;

m = length(xIt);
n = length(yIt);

f1 = zeros(m, n);
f2 = zeros(m, n);
h = zeros(m, n);
hMinPrice = zeros(m, n);
hMinPrice2 = zeros(m, n);

[XItGrid, YItGrid] = meshgrid(xIt, yIt);

c11 = 0;
c12 = 3;
c21  = c12/3;
c22 = 0;


for i = 1 : m
    for j = 1 : n
        tempInput = [XItGrid(i, j) YItGrid(i, j)]';
        f1(i, j) = gausianMultimodal(tempInput, P11, P12, M11, M12, S11, S12);
        f2(i, j) = gausianMultimodal(tempInput, P21, P22, M21, M22, S21, S22);
        h(i, j) = log(f2(i, j)) - log(f1(i, j));
        hMinPrice(i, j) = log(f2(i, j)*(c12 - c22)) - ...
                          log(f1(i, j) * (c21 - c11));
        hMinPrice2(i, j) = log(f2(i, j)*(c21 - c22)) - ...
                          log(f1(i, j) * (c12 - c11));
    end
end


% Generating contours. 
f1Max = max(max(f1));
f2Max = max(max(f2));

figure(1);
hold on;    
plot(X1(:, 1), X1(:, 2), 'r.'); 
plot(X2(:, 1), X2(:, 2), 'b.');

xlabel('x1');
ylabel('x2');

title('Odbirci svih klasa');


contour(XItGrid, YItGrid, h, [0 0], 'g');
contour(XItGrid, YItGrid, f1, [0.8 * f1Max f1Max * 0.6 f1Max * 0.4 f1Max * 0.2]);
contour(XItGrid, YItGrid, f2, [0.8 * f2Max f2Max * 0.6 f2Max * 0.4 f2Max * 0.2]);

legend('Odbirci prve klase', 'Odbirci druge klase', 'Diskriminaciona funkcija',...
        'Geometrijska mesta tacaka prve klase', 'Geometrijska mesta tacaka druge klase');

figure(2);
hold on;
xlabel('x1');
ylabel('x2');
surf(XItGrid, YItGrid, f1, 'EdgeColor', 'r');



surf(XItGrid, YItGrid, f2, 'EdgeColor', 'b');

legend('Prva klasa', 'Druga klasa');


[epsilon1, epsilon2] = errorEstimation(f1, f2, h, m, n, step);
[epsilonMinPrice1, epsilonMinPrice2] = errorEstimation(f1, f2, hMinPrice, m, n, step);
[epsilonMinPrice3, epsilonMinPrice4] = errorEstimation(f1, f2, hMinPrice2, m, n, step);

fprintf('Vrednost epsilon1 : %.3f, vrednost epsilon2 %.3f\n', epsilon1, epsilon2); 
fprintf('Vrednost epsilonMinPrice1 : %.3f, vrednost epsilonMinPrice2 %.3f\n', ...
         epsilonMinPrice1, epsilonMinPrice2); 
 fprintf('Vrednost epsilonMinPrice3 : %.3f, vrednost epsilonMinPrice4 %.3f\n', ...
         epsilonMinPrice3, epsilonMinPrice4); 

figure(4);
hold on;    
plot(X1(:, 1), X1(:, 2), 'r.'); 
plot(X2(:, 1), X2(:, 2), 'b.');

xlabel('x1');
ylabel('x2');

title('Odbirci svih klasa')

contour(XItGrid, YItGrid, hMinPrice, [0 0], 'g');
contour(XItGrid, YItGrid, h, [0 0], 'c');
contour(XItGrid, YItGrid, hMinPrice2, [0 0], 'y');
contour(XItGrid, YItGrid, f1, [ 0.8 * f1Max f1Max * 0.6 f1Max * 0.4 f1Max * 0.2]);
contour(XItGrid, YItGrid, f2, [0.8 * f2Max f2Max * 0.6 f2Max * 0.4 f2Max * 0.2]);

legend('Odbirci prve klase', 'Odbirci druge klase', 'Diskriminaciona funkcija c21  = c12/3;', 'Diskriminaciona funkcija c21  = c12', ...
        'Diskriminaciona funkcija c21/3  = c12;','Geometrijska mesta tacaka prve klase', 'Geometrijska mesta tacaka druge klase');

epsilon1Const = 10e-20;
epsilon2Const = 10e-20;
epsilon1 = logspace(-20, -1);
epsilon2 = logspace(-20, -1);

numEpsilon = length(epsilon1);
numItEps1ConstMeasured = zeros(numEpsilon, 1);
numItEps2ConstMeasured = zeros(numEpsilon, 1);



for i = 1 : numEpsilon
    [classId, numItEps1ConstMeasured(i)] = waldosTest(X1, epsilon1Const, epsilon2(i), P11, P12, P21, P22,...
                        M11, M12, M21, M22, S11, S12, S21, S22);

    [classId, numItEps2ConstMeasured(i)] = waldosTest(X1, epsilon1(i), epsilon2Const, P11, P12, P21, P22,...
                        M11, M12, M21, M22, S11, S12, S21, S22);
end

[expValCond, hApprox] = condProbDiscApprox(P11, P12, P21, P22, M11, M12, M21, M22, S11,...
                                                    S12, S21, S22);

numItEps1ConstCalculated = ((1 - epsilon1Const) .* log(epsilon2./(1 - epsilon1Const)) + ... 
                            epsilon1Const .* log((1 - epsilon2) ./ epsilon1Const)) / expValCond;  

numItEps2ConstCalculated = ((1 - epsilon1) .* log(epsilon2Const ./(1 - epsilon1)) + ... 
                    epsilon1 .* log( (1 - epsilon2Const) ./ epsilon1)) / expValCond;    

figure;
hold on;
plot(epsilon2, numItEps1ConstMeasured);
plot(epsilon2, numItEps1ConstCalculated);
title("E(m|w1)");
xlabel('eps2');
set(gca,'xscale','log');
legend('Mereni', 'Teorijski');
figure;
hold on;
plot(epsilon1, numItEps2ConstMeasured);
plot(epsilon1, numItEps2ConstCalculated);
set(gca,'xscale','log');
title("E(m|w1)");
legend('Mereni', 'Teorijski');
xlabel('eps1');                                                
figure;
histogram(hApprox, 100, 'Normalization', 'pdf');

fprintf("Ocekivana vrednost E(h(X)|w) %.3f\n", expValCond);


