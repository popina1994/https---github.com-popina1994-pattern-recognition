
clear all;
close all;
clc;


% The first class
P11 = 0.6;
M11 = [0.5 -7]';
S11 = [3.5 -1; -1 2.2];

P12 = 0.4;
M12 = [12 6]';
S12 = [1.3 -0.9; -0.9 1.2];

% The second class
P21 = 0.45;
M21 = [7.5 -3.5]';
S21 = [4 1.1; 1.1 4];

P22 = 0.55;
M22 = [4 2]';
S22 = [3 -0.8; -0.8 3];

num_points = 500;

% Plotting dataset
X1 = gausianMultimodalGenerate(P11, P12, M11, M12, S11, S12, num_points);
X2 = gausianMultimodalGenerate(P21, P22, M21, M22, S21, S22, num_points);

% Ocekivani izlaz

U = zeros(6, num_points * 2);

for i = 1 : num_points
    U(:, 2 * i - 1) = -[1 X1(i, 1) X1(i, 2) X1(i, 1) * X1(i, 2) X1(i, 1)^2 X1(i, 2)^2];
    U(:, 2 * i) = [1 X2(i, 1) X2(i, 2) X2(i, 1) * X2(i, 2) X2(i, 1)^2 X2(i, 2)^2];
end

G= ones(num_points * 2, 1);

W = U * U' \ U * G;

xIt = -6 : 0.01 : 15;
yIt = -12 : 0.01 : 8;
hExpectedOutput = zeros(length(xIt), length(yIt));
for i = 1 : length(xIt)
    for j = 1 : length(yIt)
        r = xIt(i) ;
        u = yIt(j);
        m = [1 xIt(i) yIt(j) xIt(i) * yIt(j) xIt(i)^2 yIt(j)^2 ] * W;
        hExpectedOutput(i, j) = [1 xIt(i) yIt(j) xIt(i) * yIt(j) xIt(i)^2 yIt(j)^2 ] * W;
    end
end

figure;
hold on;
plot(X1(:, 1), X1(:, 2), 'r.'); 
plot(X2(:, 1), X2(:, 2), 'b.');
contour(xIt,yIt,hExpectedOutput',[0 0],'g');

legend('Prva klasa', 'Druga klasa', 'Diskriminaciona funkcija');
xlabel('x1');
ylabel('x2');
title('Klasifikator');

 [e1, e2, e] = errorEstimationEO(U, W, num_points);

    fprintf("ExpClose : Greska %.3f Greska1 : %.3f Greska 2 %.3f\n", e, e1, e2);
