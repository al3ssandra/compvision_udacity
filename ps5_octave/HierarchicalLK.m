clear all, close all, clc;
pkg load image;
pkg load signal;

N_levels = 4

R1{1} = im2double(imread('input/TestSeq/Shift0.png'));
R2{1} = im2double(imread('input/TestSeq/ShiftR5U5.png'));
for i = 2:N_levels
    R1{i} = Reduce(R1{i-1});
    R2{i} = Reduce(R2{i-1});
end

u_exp = zeros(size(R1{N_levels}));
v_exp = zeros(size(R1{N_levels}));
[x,y] = meshgrid(1:size(u_exp,2),1:size(u_exp,1));

for i = flip(1:N_levels)
 
    XI = x - u_exp;
    YI = y - v_exp;
    warped = imremap(R1{i},XI,YI);
    [u,v] = LKopticFlow(warped,R2{i});
    u_exp = u_exp + u;
    v_exp = v_exp + v;
    u_out = u_exp;
    v_out = v_exp;
    [x_out,y_out] = meshgrid(1:size(u_out,2),1:size(u_out,1));
    [xq,yq] = meshgrid(1:0.5:size(u,2)+0.5,1:0.5:size(u,1)+0.5);
    u_exp = 2*interp2(x,y,u_exp,xq,yq);
    v_exp = 2*interp2(x,y,v_exp,xq,yq);
    [x,y] = meshgrid(1:size(u_exp,2),1:size(u_exp,1));
    
end

u_deci = u_out(1:10:end, 1:10:end);
v_deci = v_out(1:10:end, 1:10:end);
X_deci = x_out(1:10:end, 1:10:end);
Y_deci = y_out(1:10:end, 1:10:end);
imshow(R1{1});hold on;
quiver(X_deci, Y_deci, u_deci,v_deci, 'y')

XI = x - u_out;
YI = y - v_out;
warped = imremap(R1{i},XI,YI);
imshow(warped);saveas(gcf,'output/warpedR5U5.jpg')