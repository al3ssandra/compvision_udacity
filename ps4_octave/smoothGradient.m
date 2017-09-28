function [Gx,Gy] = smoothGradient(I)
    sobelX = [1 0 -1;2 0 -2;1 0 -1]*1/8;
    sobelY = [1 2 1;0 0 0;-1 -2 -1]*1/8;
    h_x = conv2(fspecial('gaussian'),sobelX);
    h_y = conv2(fspecial('gaussian'),sobelY);
    Gx = imfilter(I,h_x);
    Gy = imfilter(I,h_y);
end