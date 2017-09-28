clear all; close all; clc;
load('ps4_transA.mat')
%cd ../../installs/vlfeat-0.9.20/toolbox
%vl_setup verbose
%imshow(I);hold on;
%quiver(featCols,featRows,diag(I_x(featRows,featCols)),diag(I_y(featRows,featCols)));
%saveas(gcf,'orientedP_transB.jpg')

I = imread('input/transA.jpg');
Ia_blur = single(imfilter(I,fspecial('gaussian')));
Fa_in = [featCols';featRows';ones(1,length(featCols));zeros(1,length(featCols))];
[Fa_out, Da_out] = vl_sift(Ia_blur, 'frames', Fa_in,'orientations');

load('ps4_transB.mat')
I = imread('input/transB.jpg');
Ib_blur = single(imfilter(I,fspecial('gaussian')));
Fb_in = [featCols';featRows';ones(1,length(featCols));zeros(1,length(featCols))];
[Fb_out, Db_out] = vl_sift(Ib_blur, 'frames', Fb_in,'orientations');

matches = vl_ubcmatch(Da_out, Db_out);
joinedImg = cat(2,Ia_blur,Ib_blur);
Fb_out(1,:) = Fb_out(1,:) + size(Ia_blur,2);
joinedFrame = [Fa_out Fb_out];
linePointsA = Fa_out(1:2,matches(1,:));
linePointsB = Fb_out(1:2,matches(2,:));
%imshow(im2double(uint8(joinedImg))); hold on;
%for i = 1:size(linePointsA,2)
    %plot([linePointsA(1,i) linePointsB(1,i)],[linePointsA(2,i) linePointsB(2,i)],'r');
%end
%vl_plotframe(joinedFrame);
%saveas(gcf,'output/transMatches.jpg');
%close all;