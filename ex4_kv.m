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
M21 = [12 -3.5]';
S21 = [1.5 1.1; 1.1 1.5];

P22 = 0.55;
M22 = [-10 2]';
S22 = [3 -0.8; -0.8 3];



num_points = 500;
test_cases = 1;


for num_classes = 2 : 5
    num_it = 0;
    critFunGl = 0;
    for j = 1 : test_cases
        X1 = gausianMultimodalGenerate(P11, P12, M11, M12, S11, S12, num_points);
        X2 = gausianMultimodalGenerate(P21, P22, M21, M22, S21, S22, num_points);
       
        
        [it, critFun] = quadratic(X1, X2, num_points, num_classes, 0, 0);
        num_it = num_it + it;
        critFunGl = critFunGl + critFun;
        
    end
    fprintf("Prosecan broj iteracija za %d je %f kriterijumska %f\n", num_classes, num_it / test_cases, critFunGl/test_cases);

end


num_classes = 2;
for appPer = 0.1 : 0.05 : 1
    num_it = 0;
    for j = 1 : test_cases
        X1 = gausianMultimodalGenerate(P11, P12, M11, M12, S11, S12, num_points);
        X2 = gausianMultimodalGenerate(P21, P22, M21, M22, S21, S22, num_points);

        [it, critFun] = quadratic(X1, X2, num_points, num_classes, appPer, 0);
        num_it = num_it + it;
        
    end
    fprintf("Prosecan broj iteracija za verovatnocu %f je %f\n", appPer,  num_it / test_cases);

end

%{
% Plotting dataset
X1 = gausianMultimodalGenerate(P11, P12, M11, M12, S11, S12, num_points);
X2 = gausianMultimodalGenerate(P21, P22, M21, M22, S21, S22, num_points);

figure;
hold on;    
plot(X1(:, 1), X1(:, 2), 'r.'); 
plot(X2(:, 1), X2(:, 2), 'b.');


legend('Prva klasa', 'Druga klasa');
xlabel('x1');
ylabel('x2');

num_classes = 2;

Z = [X1; X2;];

appProbability = 0.8;

idx = randperm(num_classes * num_points);
Y1 = Z(idx(1 : num_points), :);
Y2 = Z(idx(num_points + 1:2 * num_points), :);

figure;
hold on;
legend('Prva klasa', 'Druga klasa');
plot(Y1(:, 1), Y1(:, 2), 'r.');
plot(Y2(:, 1), Y2(:, 2), 'b.');

xlabel('x1');
ylabel('x2');
title('Inicijalna klasterizacija');

run = 1;

it = 0;


while (run && it < 50)
    it = it + 1;
    run = 0;
    M1 = mean(Y1);
    M2 = mean(Y2);
    S1 = cov(Y1);
    S2 = cov(Y2);
    P1 = size(Y1, 1);
    P2 = size(Y2, 1);

    
    if (size(M1, 2) == 1)
        M1 = [realmax realmax];
    end 
    if (size(M2, 2) == 1)
        M2 = [realmax realmax];
    end 

    clear X1 X2;
    X1 = [];
    X2 = [];
    
    M = [M1; M2;];
    
    for i = 1 : size(Y1, 1)
        j1 = (Y1(i, :) - M1) * inv(S1) * (Y1(i, :) - M1)' + log(det(S1)) - log(P1);
        j2 = (Y1(i, :) - M2) * inv(S2) * (Y1(i, :) - M2)' + log(det(S2)) - log(P2);
        
        if (j1 < j2)
            X1 = [X1; Y1(i, :)];
        else
            X2 = [X2; Y1(i,:)];
            run = 1;
        end
    end

     for i = 1 : size(Y2, 1)
        j1 = (Y2(i, :) - M1) * inv(S1) * (Y2(i, :) - M1)' + log(det(S1)) - log(P1);
        j2 = (Y2(i, :) - M2) * inv(S2) * (Y2(i, :) - M2)' + log(det(S2)) - log(P2);
        
        if (j1 < j2)
            X1 = [X1; Y2(i, :)];
            run = 1;
        else
            X2 = [X2; Y2(i,:)];
        end
    end

    Y1 = X1;
    Y2 = X2; 
end

fprintf("Broj iteracija je %d\n", it);

figure;
hold on;
legend('Prva klasa', 'Druga klasa');
if (size(Y1, 2) == 2)
    plot(Y1(:, 1), Y1(:, 2), 'r.');
end
if (size(Y2, 2) == 2)
    plot(Y2(:, 1), Y2(:, 2), 'b.');
end

xlabel('x1');
ylabel('x2');
title('Krajnja klasterizacija');
%}

