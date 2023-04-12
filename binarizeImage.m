function [binImage] = binarizeImage(image, ratio)
    val = 255 - double(image);
    val(val < ratio * max(max(val))) = 0;
    val(val >= ratio * max(max(val))) = 255;
    binImage = uint8(255 - val);
end

