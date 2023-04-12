function [X] = cropImage(image)
    ratio = 0.20;
    X = binarizeImage(image, ratio);
    
    [numRow, numCol] = size(X);
    begin = 1;
    while (begin < numRow) && (sum(X(begin, 1 : numCol)) / numCol > 250 ||...
            sum(X(begin + 1, 1 : numCol)) / numCol > 250 ||...
            sum(X(begin + 2, 1 : numCol)) / numCol > 250 ||...
            sum(X(begin + 3, 1 : numCol)) / numCol > 250 ||...
            sum(X(begin + 4, 1 : numCol)) / numCol > 250 ||...
            sum(X(begin + 5, 1 : numCol)) / numCol > 250)
        begin = begin + 1;
    end

    endV = numRow;
    while(endV > begin)&&...
            (sum(X(endV, 1 : numCol)) / numCol > 250 ||...
            sum(X(endV - 1, 1 : numCol)) / numCol > 250 ||...
            sum(X(endV - 2, 1 : numCol)) / numCol > 250 ||...
            sum(X(endV - 3, 1 : numCol)) / numCol > 250 ||...
            sum(X(endV - 4, 1 : numCol)) / numCol > 250 ||...
            sum(X(endV - 5, 1 : numCol)) / numCol > 250)
        endV = endV - 1;
    end

    left = 1;
    while (left < numCol)&&...
            (sum(X(1 : numRow, left)) / numRow > 250 ||...
            sum(X(1 : numRow, left + 1)) / numRow > 250 ||...
            sum(X(1 : numRow, left + 2)) / numRow > 250 ||...
            sum(X(1 : numRow, left + 3)) / numRow > 250 ||...
            sum(X(1 : numRow, left + 4)) / numRow > 250 ||...
            sum(X(1 : numRow, left + 5)) / numRow > 250)
        left = left + 1;
    end

    right = numCol;
    while (right>1)&&...
            (sum(X(1 : numRow,right)) / numRow > 250 ||...
            sum(X(1 : numRow, right - 1)) / numRow > 250 ||...
            sum(X(1 : numRow, right - 2)) / numRow > 250 ||...
            sum(X(1 : numRow, right - 3)) / numRow > 250 ||...
            sum(X(1 : numRow, right - 4)) / numRow > 250 ||...
            sum(X(1 : numRow, right - 5)) / numRow > 250)
        right = right - 1;
    end

    X = X(begin : endV, left : right);
end

