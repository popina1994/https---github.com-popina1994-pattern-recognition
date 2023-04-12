clear all
close all
clc

N = 100;
for i = 1 : N
    name = ['BazaCifara6/baza6' num2str(i, '%03d')];
    X = imread(name, 'bmp');    
    nameCropped = ['BazaCifaraCropped6/baza6' num2str(i, '%03d') '.bmp'];
    croppedImage = cropImage(X);
    imwrite(croppedImage, nameCropped, 'bmp');
    features6(:, i) = calculateCenter(croppedImage);
    
    name = ['BazaCifara8/baza8' num2str(i, '%03d')];
    X = imread(name, 'bmp');  
    nameCropped = ['BazaCifaraCropped8/baza8' num2str(i, '%03d') '.bmp'];
    croppedImage = cropImage(X);
    imwrite(croppedImage, nameCropped, 'bmp');
    features8(:, i) = calculateCenter(croppedImage);
    
    name = ['BazaCifara9/baza9' num2str(i, '%03d')];
    X = imread(name, 'bmp');  
    nameCropped = ['BazaCifaraCropped9/baza9' num2str(i, '%03d') '.bmp'];
    croppedImage = cropImage(X);
    imwrite(croppedImage, nameCropped, 'bmp');
    features9(:, i) = calculateCenter(croppedImage);
end

figure;
hold on
plot(features6(1, :), features6(2, :), 'sb');
plot(features8(1, :), features8(2, :), 'hg');
plot(features9(1, :), features9(2, :), 'ro');
legend('Sest', 'Osam', 'Devet');
title('Skup za obucavanje');

for i = N + 1 : 120
    name = ['BazaCifara6/baza6' num2str(i, '%03d')];
    X = imread(name, 'bmp');
    nameCropped = ['BazaCifaraCroppedTest6/baza6' num2str(i, '%03d') '.bmp'];
    croppedImage = cropImage(X);
    imwrite(croppedImage, nameCropped, 'bmp');
    featuresTest6(:, i - N) = calculateCenter(croppedImage);
    
    name = ['BazaCifara8/baza8' num2str(i, '%03d')];
    X = imread(name, 'bmp');
    nameCropped = ['BazaCifaraCroppedTest8/baza8' num2str(i, '%03d') '.bmp'];
    croppedImage = cropImage(X);
    imwrite(croppedImage, nameCropped, 'bmp');
    featuresTest8(:, i - N) = calculateCenter(croppedImage);
    

    name = ['BazaCifara9/baza9' num2str(i, '%03d')];
    X = imread(name, 'bmp');
    nameCropped = ['BazaCifaraCroppedTest9/baza9' num2str(i, '%03d') '.bmp'];
    croppedImage = cropImage(X);
    imwrite(croppedImage, nameCropped, 'bmp');
    featuresTest9(:, i - N) = calculateCenter(croppedImage);
end
 
M1 = mean(features6')'; 
S1 = cov(features6');
M2 = mean(features8')'; 
S2 = cov(features8');
M3 = mean(features9')'; 
S3 = cov(features9');
CM = zeros(3,3); 

for k = 1:3
    if k == 1
        T = featuresTest6;
    elseif k == 2
        T = featuresTest8;
    else
        T = featuresTest9;
    end
    
    for i = 1 : size(T, 2)
        f1 = gausianMultivariate(T(:, i), M1, S1);
        f2 = gausianMultivariate(T(:, i), M2, S2);
        f3 = gausianMultivariate(T(:, i), M3, S3);
        if (f1 > f2) && (f1 > f3)
            CM(1, k) = CM(1, k) + 1;
            if (k ~= 1)
                fprintf("Predicted: 1 Actual: %d %d\n", k, i + N);
            end
        elseif f2 > f1 && f2 > f3
            CM(2, k) = CM(2, k) + 1;
            if (k ~= 2)
                fprintf("Predicted: 2 Actual: %d %d\n", k, i + N);
            end
        elseif f3 > f2 && f3 > f1
            CM(3, k) = CM(3, k) + 1;
            if (k ~= 3)
                fprintf("Predicted: 3 Actual: %d %d\n", k, i + N);
            end
        end
    end
end

figure;
hold on
plot(featuresTest6(1, :), featuresTest6(2, :), 'sb');
plot(featuresTest8(1, :), featuresTest8(2, :), 'hg');
plot(featuresTest9(1, :), featuresTest9(2, :), 'ro');
legend('Sest', 'Osam', 'Devet');
title('Skup za testiranje');

fprintf('Preciznost %d',sum(diag(CM)) / sum(sum(CM)) * 100);