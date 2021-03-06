%Binary sequence
clear all; close all; clc;
readerobj = VideoReader('input/PS7A1P1T1.avi');
vidFrames = read(readerobj);
numFrames = get(readerobj, 'NumberOfFrames');
H = fspecial('gaussian',15,3);
for i = 1:numFrames
    blurFrames(:,:,:,i) = imfilter(vidFrames(:,:,:,i),H);
end
for i = 2:numFrames
    B(:,:,i-1) = rgb2gray(abs(blurFrames(:,:,:,i)- blurFrames(:,:,:,i-1)));
    %B(:,:,i-1) = rgb2gray(abs(vidFrames(:,:,:,i)- vidFrames(:,:,:,i-1)));
end
BW = B > 15;
 for j=1:numFrames - 1
     se = strel('disk',5);
     afterOpening(:,:,j) = imopen(BW(:,:,j),se);
     %imshow(afterOpening(:,:,j))
     %imshow(BW(:,:,j));
     %M(j) = getframe;
 end
 close all;
       
%v = VideoWriter('output/binaryA1.avi');
%open(v)
%writeVideo(v,M);
%close(v)
       
%Motion History Images

%Action 1 settings
t = 60;
actionStop = 100;

%Action 2 settings
%t = 50;
%actionStop = 70;

%Action 3 settings
%t = 80;
%actionStop = 100;

rows = readerobj.Height;
cols = readerobj.width;
MHI_previous = ones(rows,cols);
MHI = ones(rows,cols);
for i = actionStop - t + 1:actionStop
    MHI(MHI_previous > 0) = MHI(MHI_previous > 0) - 1;
    MHI(afterOpening(:,:,i)) = t;
    MHI_previous = MHI;
end
MHI_scaled = MHI./max(MHI(:));
%imshow(MHI_scaled);
%imwrite(MHI_scaled,'output/MHIA1.jpeg')