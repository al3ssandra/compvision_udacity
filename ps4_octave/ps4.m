pkg load image
clear all; clc;

%Calculating image gradient
I = im2double(imread('input/transB.jpg'));
sobelX = [-1 0 1;-2 0 2;-1 0 1]*1/8; %positive x right
sobelY = [-1 -2 -1;0 0 0;1 2 1]*1/8; %positive y is down
h_x = conv2(fspecial('gaussian'),sobelX);
h_y = conv2(fspecial('gaussian'),sobelY);
I_x = imfilter(I,h_x);
I_y = imfilter(I,h_y);
I_x_norm = (I_x - min(I_x(:)))./max((I_x - min(I_x(:)))(:));
I_y_norm = (I_y - min(I_y(:)))./max((I_y - min(I_y(:)))(:));
joinedImg = cat(2,I_x_norm,I_y_norm);
%imwrite(joinedImg,'output/simA_Gpair.jpg')

%Calculating R image
Ix_squared = I_x.*I_x;
Iy_squared = I_y.*I_y;
IxIy = I_x.*I_y;
window = fspecial('gaussian',21,3);
window = window./max(window(:));
[winRows,winCols] = size(window);
winHalf = floor(winRows/2);
Ix_aug = padarray(Ix_squared,[winHalf winHalf]);
Iy_aug = padarray(Iy_squared,[winHalf winHalf]);
Ixy_aug = padarray(IxIy,[winHalf winHalf]);
[rows,cols] = size(I);

for i = winHalf+1:winHalf+rows
    for j = winHalf+1:winHalf+cols
    
        M11 = Ix_aug(i-winHalf:i+winHalf,j-winHalf:j+winHalf).*window;
        M11 = sum(M11(:));
        M12 = Ixy_aug(i-winHalf:i+winHalf,j-winHalf:j+winHalf).*window; 
        M12 = sum(M12(:));
        M22 = Iy_aug(i-winHalf:i+winHalf,j-winHalf:j+winHalf).*window;
        M22 = sum(M22(:));
        M = [M11 M12;M12 M22];
        R(i - winHalf,j - winHalf) = det(M) - 0.05*trace(M)*trace(M);
    end
end
R_scaled = (R-min(R(:)))./max((R-min(R(:)))(:));

%Saving R image
imagesc(R_scaled); saveas(gcf,'output/transB_HarrisIm.jpg');
close all
R_scaled = R_scaled*255;

%Thresholding and Non-maximum supression
[r,c] = find(R_scaled > 0.3*max(R_scaled(:)));
R_scaled(R_scaled <= 0.3*max(R_scaled(:))) = 0;
nbhood = 10;
r = r + nbhood;
c = c + nbhood;
R_scaled = padarray(R_scaled,[nbhood nbhood]);

for i = 1:length(r)
    neighbors = R_scaled(r(i)-nbhood:r(i)+nbhood,c(i)-nbhood:c(i)+nbhood);
    neighbors(neighbors < max(neighbors(:))) = 0;
    R_scaled(r(i)-nbhood:r(i)+nbhood,c(i)-nbhood:c(i)+nbhood) = neighbors;
end

R_scaled = R_scaled(nbhood+1:nbhood+size(R,1),nbhood+1:nbhood+size(R,2));
R_scaled(R_scaled > 0) = 1;
[featRows,featCols] = find(R_scaled == 1);

%Saving image with interest points
imshow(I); hold on; plot(featCols,featRows,'+','markersize',10,'color','r','linewidth',1);
saveas(gcf,'output/transB_points.jpg')
close all;
save('ps4_transB.mat')