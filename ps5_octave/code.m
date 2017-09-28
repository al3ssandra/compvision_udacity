%kernel = conv2([1 4 6 4 1]'/16,[1 4 6 4 1]/16);
%I_base = imfilter(im2double(imread('input/TestSeq/Shift0.png')),kernel);
%I_motion = imfilter(im2double(imread('input/TestSeq/ShiftR2.png')),kernel);
I_base = imfilter(im2double(imread('input/TestSeq/Shift0.png')),fspecial('gaussian',7,1));
I_motion = imfilter(im2double(imread('input/TestSeq/ShiftR2.png')),fspecial('gaussian',7,1));
%[Ix,Iy] = imgradientxy(I_base);
%Ix = Ix/8;
%Iy = Iy/8;
kernel = [-1 8 0 -8 1]/12;
Ix = conv2(I_base,kernel,'same');
Iy = conv2(I_base,kernel','same');
h = ones(9,9);
%h = conv2([1 4 6 4 1]'/16,[1 4 6 4 1]/16); %This is the 5-tap filter
sumIxIx = imfilter(Ix.*Ix,h);
sumIyIy = imfilter(Iy.*Iy,h);
sumIxIy = imfilter(Ix.*Iy,h);

[x,y] = meshgrid(1:size(I_base,2),1:size(I_base,1));
u0 = 0; v0 = 0;
d_previous = 0;

while 1
    XI = x - u0;
    YI = y - v0;
    warped = imremap(I_base,XI,YI);

    It = I_motion - warped;
    %[Gmag, Gdir] = imgradient(Ix, Iy);

    %kernel = conv2([1 4 6 4 1]'/16,[1 4 6 4 1]/16);
    %Ix = conv2(Ix,kernel,'same');
    %Iy = conv2(Iy,kernel,'same');
    %It = conv2(It,kernel,'same');

    sumIxIt = imfilter(Ix.*It,h);
    sumIyIt = imfilter(Iy.*It,h);

    %kernel = conv2([1 4 6 4 1]'/16,[1 4 6 4 1]/16);
    %sumIxIx = conv2(sumIxIx,kernel,'same');
    %sumIyIy = conv2(sumIyIy,kernel,'same');
    %sumIxIy = conv2(sumIxIy,kernel,'same');
    %sumIxIt = conv2(sumIxIt,kernel,'same');
    %sumIyIt = conv2(sumIyIt,kernel,'same');

    %normIx = Ix./Gmag;
    %normIy = Iy./Gmag;
    %speed = -It./Gmag;
    %u_norm = speed.*normIx;
    %v_norm = speed.*normIy; 
    detA = (sumIxIx.*sumIyIy) - (sumIxIy.*sumIxIy);
    detB1 = (-sumIxIt.*sumIyIy) - (sumIxIy.*(-sumIyIt));
    detB2 = (sumIxIx.*(-sumIyIt)) - (-sumIxIt.*sumIxIy);
    u = detB1./detA;
    v = detB2./detA;
    threshold = 0.0039;
    lamda1 = (sumIxIx + sumIyIy)/2 + sqrt(4*sumIxIy.^2 + (sumIxIx - sumIyIy).^2)/2;
    lamda2 = (sumIxIx + sumIyIy)/2 - sqrt(4*sumIxIy.^2 + (sumIxIx - sumIyIy).^2)/2;
    u(lamda1 < threshold & lamda2 < threshold) = 0;
    v(lamda1 < threshold & lamda2 < threshold) = 0;

    displacement = sqrt(u.^2 + v.^2);
    displacement = sum(displacement(:))/numel(displacement);
    u0 = u0 + u;
    v0 = v0 + v;

    if abs(d_previous - displacement) < 0.01
        break
    end
    d_previous = displacement;

end

%[row1,col1] = find(lamda1 >= threshold & lamda2 < threshold);
%[row2,col2] = find(lamda1 < threshold & lamda2 >= threshold);

%for i = 1:length(row1)
    %A = [sumIxIx(row1(i),col1(i)) sumIxIy(row1(i),col1(i));sumIxIy(row1(i),col1(i)) sumIyIy(row1(i),col1(i))];
    %b = -[sumIxIt(row1(i),col1(i));sumIyIt(row1(i),col1(i))];
    %solution = pinv(A)*b;    
    %u(row1(i),col1(i)) = solution(1);
    %v(row1(i),col1(i)) = solution(2);
%end

%for i = 1:length(row2)
    %A = [sumIxIx(row2(i),col2(i)) sumIxIy(row2(i),col2(i));sumIxIy(row2(i),col2(i)) sumIyIy(row2(i),col2(i))];
    %b = -[sumIxIt(row2(i),col2(i));sumIyIt(row2(i),col2(i))];
    %solution = pinv(A)*b;    
    %u(row2(i),col2(i)) = solution(1);
    %v(row2(i),col2(i)) = solution(2);
%end

u = u0; v = v0; 
%quiver(x,y,u,v,10);

u_deci = u(1:10:end, 1:10:end);
v_deci = v(1:10:end, 1:10:end);
X_deci = x(1:10:end, 1:10:end);
Y_deci = y(1:10:end, 1:10:end);
imshow(I_base);hold on;
quiver(X_deci, Y_deci, u_deci,v_deci, 'y')

I_base = imfilter(im2double(imread('input/TestSeq/Shift0.png')),fspecial('gaussian',7,1));
I_motion = imfilter(im2double(imread('input/TestSeq/ShiftR2.png')),fspecial('gaussian',7,1));
[u,v] = LKopticFlow(I_base,I_motion);
[x,y] = meshgrid(1:size(I_base,2),1:size(I_base,1));
u_deci = u(1:10:end, 1:10:end);
v_deci = v(1:10:end, 1:10:end);
X_deci = x(1:10:end, 1:10:end);
Y_deci = y(1:10:end, 1:10:end);
imshow(I_base);hold on;
quiver(X_deci, Y_deci, u_deci,v_deci, 'y')


















clear all, close all, clc;
pkg load image;
pkg load signal;

N_levels = 3
R1{1} = im2double(imread('input/TestSeq/Shift0.png'));
R2{1} = im2double(imread('input/TestSeq/ShiftR2.png'));
for i = 2:N_levels
    R1{i} = Reduce(R1{i-1});
    R2{i} = Reduce(R2{i-1});
end

%Coarser level (3)
L3_img1 = R1{end}; L3_img2 = R2{end};
[u,v] = LKopticFlow(L3_img1,L3_img2);
[x,y] = meshgrid(1:size(u,2),1:size(u,1));
[xq,yq] = meshgrid(1:0.5:size(u,2)+0.5,1:0.5:size(u,1)+0.5);
u_exp = 2*interp2(x,y,u,xq,yq);
v_exp = 2*interp2(x,y,v,xq,yq);

%Next level (2)
L2_img1 = R1{end-1}; L2_img2 = R2{end-1};
[x,y] = meshgrid(1:size(u_exp,2),1:size(u_exp,1));
XI = x - u_exp;
YI = y - v_exp;
warped = imremap(L2_img1,XI,YI);
[u,v] = LKopticFlow(warped,L2_img2);
u_exp = u_exp + u;
v_exp = v_exp + v;

%Next level (1)
[x,y] = meshgrid(1:size(u_exp,2),1:size(u_exp,1));
[xq,yq] = meshgrid(1:0.5:size(u_exp,2)+0.5,1:0.5:size(u_exp,1)+0.5);
u_exp = 2*interp2(x,y,u_exp,xq,yq);
v_exp = 2*interp2(x,y,v_exp,xq,yq);

L1_img1 = R1{end-2}; L1_img2 = R2{end-2};
[x,y] = meshgrid(1:size(u_exp,2),1:size(u_exp,1));
XI = x - u_exp;
YI = y - v_exp;
warped = imremap(L1_img1,XI,YI);
[u,v] = LKopticFlow(warped,L1_img2);
u_exp = u_exp + u;
v_exp = v_exp + v;

u_deci = u_exp(1:10:end, 1:10:end);
v_deci = v_exp(1:10:end, 1:10:end);
X_deci = x(1:10:end, 1:10:end);
Y_deci = y(1:10:end, 1:10:end);
imshow(L1_img1);hold on;
quiver(X_deci, Y_deci, u_deci,v_deci, 'y')

