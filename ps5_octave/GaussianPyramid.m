clear all; close all; clc;
pkg load image
pkg load signal

%Reduce image 4 levels
img = im2double(imread('input/DataSeq1/yos_img_01.jpg'));
N_levels = 4;
R_0 = img;
R_1 = Reduce(R_0);
R_2 = Reduce(R_1);
R_3 = Reduce(R_2);

%R{1} = img;
%imwrite(R{1},'output/Level_0.jpg');
%for i = 2:N_levels 
    %R{i} = Reduce(R{i-1});
    %j = i-1;
    %j = int2str(j);
    %level = strcat('output/Level_',j,'.jpg');
    %imwrite(R{i},level)
%end 

%Expand 4 levels to size of level 0
E_0 = img;
E_1 = Expand(R_1);
imwrite(E_1,'output/GaussianLevel_1.jpg');
E_2 = Expand(Expand(R_2));
imwrite(E_2,'output/GaussianLevel_2.jpg');
E_3 = Expand(Expand(Expand(R_3)(1:end-1,1:end-1)));
imwrite(E_3,'output/GaussianLevel_3.jpg');

%Laplaciam Pyramid
L_0 = E_0 - E_1;
imwrite(L_0,'output/LaplacianLevel_0.jpg');
L_1 = E_1 - E_2;
imwrite(L_1,'output/LaplacianLevel_1.jpg');
L_2 = E_2 - E_3;
imwrite(L_2,'output/LaplacianLevel_2.jpg');
L_3 = E_3;