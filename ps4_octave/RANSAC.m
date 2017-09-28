%RANSAC
clear all; close all;
ps4_sift;

%Translation case

%Find number of trials sample_count

Fb_out(1,:) = Fb_out(1,:) - size(Ia_blur,2);
N = inf; p = 0.99;
threshold = 20; sample_count = 0; e = 1.0;
inlier = [];
while N > sample_count
    perm = randperm(size(matches,2));
    sample = matches(:,perm(1));
    pointTransA = Fa_out(1:2,sample(1));
    pointTransB = Fb_out(1:2,sample(2));
    offset = pointTransB - pointTransA;
    M = [matches(:,1:perm(1)-1) matches(:,perm(1)+1:size(matches,2))];
    pointsA = Fa_out(1:2,M(1,:));
    pointsB = Fb_out(1:2,M(2,:));
    consensus = (pointsB - pointsA) - offset;
    for i = 1:size(consensus,2)
        inlier(i) = norm(consensus(:,i));
    end
    inlier = numel(inlier(inlier < threshold));
    e_zero = 1 - (inlier/size(matches,2));
    if e_zero < e
        e = e_zero;
        N = log(1-p)/log(e);
    end
    sample_count = sample_count + 1;
end

%Randomly select one of the putative matches and return models with inliers, for N trials

inlier = [];
for i = 1:sample_count
    perm = randperm(size(matches,2));
    sample = matches(:,perm(1));
    pointTransA = Fa_out(1:2,sample(1));
    pointTransB = Fb_out(1:2,sample(2));
    offset = pointTransB - pointTransA;
    M = [matches(:,1:perm(1)-1) matches(:,perm(1)+1:size(matches,2))];
    pointsA = Fa_out(1:2,M(1,:));
    pointsB = Fb_out(1:2,M(2,:));
    consensus = (pointsB - pointsA) - offset;
    for k = 1:size(consensus,2)
        inlier(k) = norm(consensus(:,k));
    end
    inlier = numel(inlier(inlier < threshold));
    model(1,i) = inlier;
    model(2:3,i) = offset;
end

%Select the model with the biggest number of inliers

modelInliers = model(1,:);
[indxRow, indxCol] = find(modelInliers == max(modelInliers(:)));
model = model(2:3,indxCol);

%Calculate averge of all distances that agree with the model

linePointsA = Fa_out(1:2,matches(1,:));
linePointsB = Fb_out(1:2,matches(2,:));
offset = (linePointsB - linePointsA) - model;
for k = 1:size(offset,2)
    noiseDelta(k) = norm(offset(:,k));
end
[indxRow, indxCol] = find(noiseDelta < threshold);
finalModel = sum((linePointsB(:,indxCol) - linePointsA(:,indxCol)),2)./length(indxCol);
offset = (linePointsB - linePointsA) - finalModel;
for k = 1:size(offset,2)
    noiseDelta(k) = norm(offset(:,k));
end
[indxRow, indxCol] = find(noiseDelta < threshold);

%Show RANSAC matches, biggest consensus set lines
Fb_out(1,:) = Fb_out(1,:) + size(Ia_blur,2);
linePointsB = Fb_out(1:2,matches(2,:));
imshow(im2double(uint8(joinedImg))); hold on;
for i = 1:size(indxCol,2)
    plot([linePointsA(1,indxCol(i)) linePointsB(1,indxCol(i))],[linePointsA(2,indxCol(i)) linePointsB(2,indxCol(i))],'r');
end
vl_plotframe(joinedFrame);

%Save image
saveas(gcf,'output/transRansac.jpg');
close all;