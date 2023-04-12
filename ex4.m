clear all;
close all;
clc;

M1 =[-4 -4]';
M2 = [4 4]';
M3 =[4 -4]';
M4 = [-4 4]';

S1 = [1.5 1; 1 2.5];
S2 = [2 1; 1 2];
S3 = [1.5 -1; -1 2.5];
S4 = [2 -1; -1 2];

num_points = 500;
test_cases = 10;



for num_classes = 2 : 5
    num_it = 0;
    critFunGl = 0;
    for j = 1 : test_cases
        close all;
        X1 = gausianMultivariateGenerate(M1, S1, num_points)';
        X2 = gausianMultivariateGenerate(M2, S2, num_points)';
        X3 = gausianMultivariateGenerate(M3, S3, num_points)';
        X4 = gausianMultivariateGenerate(M4, S4, num_points)';
        %{
        figure;
        hold on;    
        plot(X1(:, 1), X1(:, 2), 'r.'); 
        plot(X2(:, 1), X2(:, 2), 'b.');
        plot(X3(:, 1), X3(:, 2), 'g.');
        plot(X4(:, 1), X4(:, 2), 'c.');

        legend('Prva klasa', 'Druga klasa', 'Treca klasa', 'Cetvrta klasa');
        xlabel('x1');
        ylabel('x2');   
        %}
        [it, critFun] = cMean(X1, X2, X3, X4, num_points, num_classes, 0, 0);
        num_it = num_it + it;
        critFunGl = critFunGl + critFun;
        
    end
    fprintf("Prosecan broj iteracija za %d je %f kriterijumska %f\n", num_classes, num_it / test_cases, critFunGl/test_cases);

end



num_classes = 4;
for appPer = 0.1 : 0.05 : 1
    num_it = 0;
    for j = 1 : test_cases
        X1 = gausianMultivariateGenerate(M1, S1, num_points)';
        X2 = gausianMultivariateGenerate(M2, S2, num_points)';
        X3 = gausianMultivariateGenerate(M3, S3, num_points)';
        X4 = gausianMultivariateGenerate(M4, S4, num_points)';

        [it, critFun] = cMean(X1, X2, X3, X4, num_points, num_classes, appPer, 0);
        num_it = num_it + it;
        
    end
    fprintf("Prosecan broj iteracija za verovatnocu %f je %f\n", appPer,  num_it / test_cases);

end
