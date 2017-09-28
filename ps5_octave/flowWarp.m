clear all, close all, clc;
pkg load image;
pkg load signal;

I_base = im2double(imread('input/DataSeq1/yos_img_01.jpg'));
I_motion = im2double(imread('input/DataSeq1/yos_img_02.jpg'));
%I_base = im2double(rgb2gray(imread('input/DataSeq2/0.png')));
%I_motion = im2double(rgb2gray(imread('input/DataSeq2/1.png')));

%Level 1 of pyramid (levels start from 0: 0,1,2,3)
I1_GaussianL1 = Reduce(I_base);
I2_GaussianL1 = Reduce(I_motion); 
%I1_GaussianL1 = Reduce(Reduce(I_base));
%I2_GaussianL1 = Reduce(Reduce(I_motion)); 

[u,v] = LKopticFlow(I1_GaussianL1,I2_GaussianL1);
[x,y] = meshgrid(1:size(I1_GaussianL1,2),1:size(I1_GaussianL1,1));

XI = x + u;
YI = y + v;
warped = imremap(I2_GaussianL1,XI,YI);
difference = I1_GaussianL1 - warped;
%imwrite(difference,'output/difference2.jpg')
%imshow(I2_GaussianL1);saveas(gcf,'output/warped1.jpg');close all;
%imshow(warped);saveas(gcf,'output/warped2.jpg');close all;

u_deci = u(1:10:end, 1:10:end);
v_deci = v(1:10:end, 1:10:end);
X_deci = x(1:10:end, 1:10:end);
Y_deci = y(1:10:end, 1:10:end);
imshow(I2_GaussianL1);hold on;
quiver(X_deci, Y_deci, u_deci,v_deci, 'y')