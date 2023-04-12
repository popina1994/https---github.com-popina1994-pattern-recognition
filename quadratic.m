function [num_it, critFun] = quadratic(X1, X2, num_points, num_classes, apPer, drawFigure)

chunkRand = floor((1 - apPer) * num_points);
chunkApp = num_points - chunkRand;

Z = [X1(1 : chunkRand, :); X2(1 : chunkRand, :);];

num_points_all = 2 * chunkRand;

idx = randperm(num_points_all);
chunk_size = floor(num_points_all / num_classes);

Y1 = Z(idx(1 : chunk_size), :);
Y1App = X1(chunkRand + 1 : num_points, :);
Y1 = [Y1App; Y1];
Y2 = Z(idx(chunk_size + 1:2 * chunk_size), :);
Y2App = X2(chunkRand + 1 : num_points, :);
Y2 = [Y2App; Y2];
Y3 = [];
Y3App = [];
Y4 =[];
Y4App = [];
Y5 =[];
Y5App = [];
if (num_classes > 2)
    Y3 = Z(idx(2 * chunk_size + 1:3 * chunk_size), :);
end 
if (num_classes > 3)
    Y4 = Z(idx(3 * chunk_size + 1:4 * chunk_size), :);
end
if (num_classes > 4)
    Y5 = Z(idx(4 * chunk_size + 1:5 * chunk_size), :);
end

if (drawFigure)
    figure;
    hold on;

    plot(Y1(:, 1), Y1(:, 2), 'r.');
    plot(Y2(:, 1), Y2(:, 2), 'b.');
    if (num_classes > 2)
        plot(Y3(:, 1), Y3(:, 2), 'g.');
    end
    if (num_classes > 3)
        plot(Y4(:, 1), Y4(:, 2), 'c.');
    end
     if (num_classes > 4)
        plot(Y5(:, 1), Y5(:, 2), 'y.');
    end
    if (num_classes == 2)
        legend('Prva klasa', 'Druga klasa');
    elseif (num_classes == 3)
        legend('Prva klasa', 'Druga klasa', 'Treca klasa');
    elseif (num_classes == 4)
        legend('Prva klasa', 'Druga klasa', 'Treca klasa', 'Cetvrta klasa');
    else
        legend('Prva klasa', 'Druga klasa', 'Treca klasa', 'Cetvrta klasa', 'Peta klasa');
    end
    xlabel('x1');
    ylabel('x2');
    title('Inicijalna klasterizacija');
end 
run = 1;

it = 0;

while (run && it < 50)
    it = it + 1;
    M1 = mean(Y1);
    M2 = mean(Y2);
    M3 = mean(Y3);
    M4 = mean(Y4);
    M5 = mean(Y5);
    
    S1 = cov(Y1);
    S2 = cov(Y2);
    S3 = cov(Y3);
    S4 = cov(Y4);
    S5 = cov(Y5);
    P1 = size(Y1, 1) / (2 * num_points);
    P2 = size(Y2, 1) / (2 * num_points);
    P3 = size(Y3, 1) / (2 * num_points);
    P4 = size(Y4, 1) / (2 * num_points);
    P5 = size(Y5, 1) / (2 * num_points);
    
    if (size(M1, 2) == 1)
        M1 = [realmax realmax];
        S1 = [realmax realmax; realmax realmax];
    end 
    if (size(M2, 2) == 1)
        M2 = [realmax realmax];
        S2 = [realmax realmax; realmax realmax];
    end 
    if (size(M3, 2) == 1)
        M3 = [realmax realmax];
        S3 = [realmax realmax; realmax realmax];
    end 
    if (size(M4, 2) == 1)
        M4 = [realmax realmax];
        S4 = [realmax realmax; realmax realmax];
    end 
    if (size(M5, 2) == 1)
        M5 = [realmax realmax];
        S5 = [realmax realmax; realmax realmax];
    end 
    clear X1 X2 X3 X4;
    
    M = [M1; M2; M3; M4; M5];
    S = [S1; S2; S3; S4; S5];
    P = [P1; P2; P3; P4; P5];
    
    [X11, X21, X31, X41, X51, changed1] = reClusterQuadr(Y1(chunkApp + 1: end, :), M, S, P, 1);
    [X12, X22, X32, X42, X52, changed2] = reClusterQuadr(Y2(chunkApp + 1: end, :), M, S, P, 2);
    [X13, X23, X33, X43, X53, changed3] = reClusterQuadr(Y3(chunkApp + 1: end, :), M, S, P, 3);
    [X14, X24, X34, X44, X54, changed4] = reClusterQuadr(Y4(chunkApp + 1: end, :), M, S, P, 4);
    [X15, X25, X35, X45, X55, changed5] = reClusterQuadr(Y5(chunkApp + 1: end, :), M, S, P, 5);
    run = changed1 | changed2 | changed3 | changed4 | changed5;
    Y1 = [Y1App; X11; X12; X13; X14; X15];
    Y2 = [Y2App; X21; X22; X23; X24; X25];
    Y3 = [Y3App; X31; X32; X33; X34; X35];
    Y4 = [Y4App; X41; X42; X43; X44; X45];
    Y5 = [Y5App; X51; X52; X53; X54; X55];
end

num_it = it;
critFun = 0;

for i = 1 : size(Y1, 1)
    elem = Y1(i, :); curM = M1; curS = S1; curP = P1;
    j = (elem - curM) * inv(curS) * (elem - curM)' + log(det(curS)) - log(curP);
    critFun = critFun + j;
end
for i = 1 : size(Y2, 1)
    elem = Y2(i, :); curM = M2; curS = S2; curP = P2;
    j = (elem - curM) * inv(curS) * (elem - curM)' + log(det(curS)) - log(curP);
    critFun = critFun + j;
end
for i = 1 : size(Y3, 1)
    elem = Y3(i, :); curM = M3; curS = S3; curP = P3;
    j = (elem - curM) * inv(curS) * (elem - curM)' + log(det(curS)) - log(curP);
    critFun = critFun + j;
end
for i = 1 : size(Y4, 1)
    elem = Y4(i, :); curM = M4; curS = S4; curP = P4;
    j = (elem - curM) * inv(curS) * (elem - curM)' + log(det(curS)) - log(curP);
    critFun = critFun + j;
end
for i = 1 : size(Y5, 1)
    elem = Y5(i, :); curM = M5; curS = S5; curP = P5;
    j = (elem - curM) * inv(curS) * (elem - curM)' + log(det(curS)) - log(curP);
    critFun = critFun + j;
end

critFun = critFun / (num_points * 2)  + 3 * log(num_classes);

if (drawFigure)
    figure;
    hold on;

    if (size(Y1, 2) == 2)
        plot(Y1(:, 1), Y1(:, 2), 'r.');
    end
    if (size(Y2, 2) == 2)
        plot(Y2(:, 1), Y2(:, 2), 'b.');
    end
    if (size(Y3, 2) == 2)
        plot(Y3(:, 1), Y3(:, 2), 'g.');
    end
    if (size(Y4, 2) == 2)
        plot(Y4(:, 1), Y4(:, 2), 'c.');
    end
    if (size(Y5, 2) == 2)
        plot(Y5(:, 1), Y5(:, 2), 'y.');
    end
    xlabel('x1');
    ylabel('x2');
    title('Krajnja klasterizacija');
    if (num_classes == 2)
        legend('Prva klasa', 'Druga klasa');
    elseif (num_classes == 3)
        legend('Prva klasa', 'Druga klasa', 'Treca klasa');
    elseif (num_classes == 4)
        legend('Prva klasa', 'Druga klasa', 'Treca klasa', 'Cetvrta klasa');
    else
        legend('Prva klasa', 'Druga klasa', 'Treca klasa', 'Cetvrta klasa', 'Peta klasa');
    end
end

end

