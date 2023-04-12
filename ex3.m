
clear all;
close all;
clc;


% The first class
P11 = 0.6;
M11 = [0.5 -7]';
S11 = [3.5 -1; -1 2.2];

P12 = 0.4;
M12 = [-1 -1]';
S12 = [1.3 -0.9; -0.9 1.2];

% The second class
P21 = 0.45;
M21 = [7.5 -3.5]';
S21 = [4 1.1; 1.1 4];

P22 = 0.55;
M22 = [4 2]';
S22 = [3 -0.8; -0.8 3];

num_points = 500   ;

% Plotting dataset
X1 = gausianMultimodalGenerate(P11, P12, M11, M12, S11, S12, num_points);
X2 = gausianMultimodalGenerate(P21, P22, M21, M22, S21, S22, num_points);

% Calculating probability density functions
step = 0.1;
xIt = -6 : step : 12;


figure;
hold on;    
plot(X1(:, 1), X1(:, 2), 'r.'); 
plot(X2(:, 1), X2(:, 2), 'b.');

legend('Prva klasa', 'Druga klasa');
xlabel('x1');
ylabel('x2');


title('Odbirci svih klasa');

M1Approx = mean(X1)';
M2Approx = mean(X2)';

S1Approx = cov(X1);
S2Approx = cov(X2); 

step = 0.01;

s = 0 : step : 1;

num_s = length(s);
epsilon = zeros(num_s, 1);
V0Min = zeros(num_s, 1);

for i = 1 : num_s
    % TODO: update this to optimize.

    V = (s(i) * S1Approx  + (1 - s(i)) * S2Approx) \ (M2Approx - M1Approx);
    Y1 = X1 * V;
    Y2 = X2 * V;
    
    downLimit = -max(max(Y1), max(Y2));
    upLimit = -min(min(Y1), min(Y2));
    
    V0 = downLimit : step : upLimit;
    
    minError = size(Y1, 1) + size(Y2, 1);
    minIdx = 0;
    
    V0Num = length(V0);
    
    for j = 1 : V0Num
        v0 = V0(j);
        wrongClass1 = nnz(Y1 > -v0);
        wrongClass2 = nnz(Y2 < -v0);
        wrongClass = wrongClass1 + wrongClass2;
        if (wrongClass < minError)
            minError = wrongClass;
            minIdx = j;
        end
    end
    epsilon(i) = minError;
    V0Min(i) = V0(minIdx);
    
end

figure;
plot(s, epsilon);
legend("Zavisnost broja gresaka od s");
xlabel('s');
ylabel('Broj gresaka');

[epsilon, idx] = min(epsilon);

sVal = s(idx);

V = (sVal * S1Approx  + (1 - sVal) * S2Approx) \ (M2Approx - M1Approx)
v0 = V0Min(idx)

xIt = -6 : 0.01 : 14;
yIt = -12 : 0.01 : 6;
h = zeros(length(xIt), length(yIt));
for i = 1 : length(xIt)
    for j = 1 : length(yIt)
        h(i, j) = [xIt(i) yIt(j)] * V + v0;
    end
end
figure;

hold on;    
plot(X1(:, 1), X1(:, 2), 'r.'); 
plot(X2(:, 1), X2(:, 2), 'b.');
contour(xIt,yIt,h',[0 0],'g');

legend('Prva klasa', 'Druga klasa', 'Diskriminaciona funkcija');
xlabel('x1');
ylabel('x2');
title('Klasifikator');

U = zeros(3, num_points * 2);
G= ones(num_points * 2, 1);
for i = 1 : num_points
    U(:, 2 * i - 1) = [-1 -X1(i, :)];
    U(:, 2 * i) = [1 X2(i, :)];
end


W = U * U' \ U * G

xIt = -6 : 0.01 : 14;
yIt = -12 : 0.01 : 6;
hExpectedOutput = zeros(length(xIt), length(yIt));
for i = 1 : length(xIt)
    for j = 1 : length(yIt)
        hExpectedOutput(i, j) = [1 xIt(i) yIt(j)] * W;
    end
end

[e1, e2, e] = errorEstimationEO(U, W, num_points);

fprintf("Exp : Greska %.3f Greska1 : %.3f Greska 2 %.3f\n", e, e1, e2);

figure;
hold on;
plot(X1(:, 1), X1(:, 2), 'r.'); 
plot(X2(:, 1), X2(:, 2), 'b.');
contour(xIt,yIt,hExpectedOutput',[0 0],'g');

xlabel('x1');
ylabel('x2');
title('Klasifikator');

G= ones(num_points * 2, 1);
for i = 1 : num_points
    U(:, 2 * i - 1) = [-1 -X1(i, :)];
    U(:, 2 * i) = [1 X2(i, :)];
    G(2 * i) = 1.2;
end

W = U * U' \ U * G;

xIt = -6 : 0.01 : 14;
yIt = -12 : 0.01 : 6;
hExpectedOutput = zeros(length(xIt), length(yIt));
for i = 1 : length(xIt)
    for j = 1 : length(yIt)
        hExpectedOutput(i, j) = [1 xIt(i) yIt(j)] * W;
    end
end
contour(xIt,yIt,hExpectedOutput',[0 0],'c');
legend('Prva klasa', 'Druga klasa', 'Diskriminaciona funkcija', 'Unapredjena diskriminaciona');
[e1, e2, e] = errorEstimationEO(U, W, num_points);
fprintf("Exp Changed : Greska %.3f Greska1 : %.3f Greska 2 %.3f\n", e, e1, e2);

% dsf jfdaj 


figure;
hold on;
plot(X1(:, 1), X1(:, 2), 'r.'); 
plot(X2(:, 1), X2(:, 2), 'b.');
legend('Prva klasa', 'Druga klasa');
xlabel('x1');
ylabel('x2');
title('Klasifikator');
U = zeros(3, num_points * 2);
G = ones(num_points * 2, 1);
for i = 1 : num_points
    U(:, 2 * i - 1) = [-1 -X1(i, :)];
    U(:, 2 * i) = [1 X2(i, :)];
end
for t = 1 : 10

    W = U * U' \ U * G;
    xIt = -6 : 0.01 : 14;
    yIt = -12 : 0.01 : 6;
    hExpectedOutput = zeros(length(xIt), length(yIt));
    for i = 1 : length(xIt)
        for j = 1 : length(yIt)
            hExpectedOutput(i, j) = [1 xIt(i) yIt(j)] * W;
        end
    end

    [e1, e2, e] = errorEstimationEO(U, W, num_points);

    fprintf("ExpClose : Greska %.3f Greska1 : %.3f Greska 2 %.3f\n", e, e1, e2);
    if (t == 10)
        contour(xIt,yIt,hExpectedOutput',[0 0],'y');
    else
        contour(xIt,yIt,hExpectedOutput',[0 0],'g');
    end
    Y = U' * W;
    idx = find(Y(1:num_points) < 0.1);
    G = ones(num_points * 2, 1);
    for i = 1:length(idx)
        G(idx(i)) = 10;
    end
end








