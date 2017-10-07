%Motion history
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
     imshow(afterOpening(:,:,j))
     %imshow(BW(:,:,j));
     M(j) = getframe;
 end
 
  % Create a figure
       %hf = figure; 
       
       % Resize figure based on the video's width and height
       %set(hf, 'position', [150 150 readerobj.Width readerobj.Height])
 
       % Playback movie once at the video's frame rate
       %movie(hf, M, 1, readerobj.FrameRate);
       
       v = VideoWriter('binary.avi');
       open(v)
       writeVideo(v,M);
       close(v)