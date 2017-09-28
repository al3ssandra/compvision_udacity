%RANSAC
clear all; close all;
ps4_sift; %Load similarity pair case

%Similarity case

%Find number of trials sample_count

Fb_out(1,:) = Fb_out(1,:) - size(Ia_blur,2);
N = inf; p = 0.99;
threshold = 20; sample_count = 0; e = 1.0;
inlier = [];
while N > sample_count
    perm = randperm(size(matches,2));
    sample = matches(:,perm(1:2));
    pointSimA = Fa_out(1:2,sample(1,:));
    pointSimB = Fb_out(1:2,sample(2,:));
    A = [pointSimA(1,1) -pointSimA(2,1) 1 0;pointSimA(2,1) pointSimA(1,1) 0 1;pointSimA(1,2) -pointSimA(2,2) 1 0;pointSimA(2,2) pointSimA(1,2) 0 1]; 
    b = [pointSimB(:,1);pointSimB(:,2)];
    X_solution = inv(A)*b;
    X_solution = [X_solution(1) -X_solution(2) X_solution(3);X_solution(2) X_solution(1) X_solution(4)];
    M = matches;
    M(:,perm(1:2)) = [];
    pointsA = Fa_out(1:2,M(1,:));
    pointsB = Fb_out(1:2,M(2,:));
    for i = 1:size(pointsA,2)
        consensus(:,i) = X_solution*[pointsA(:,i);1];
    end
    offset = consensus - pointsB;
    for k = 1:size(offset,2)
        inlier(k) = norm(offset(:,k));
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
    sample = matches(:,perm(1:2));
    pointSimA = Fa_out(1:2,sample(1,:));
    pointSimB = Fb_out(1:2,sample(2,:));
    A = [pointSimA(1,1) -pointSimA(2,1) 1 0;pointSimA(2,1) pointSimA(1,1) 0 1;pointSimA(1,2) -pointSimA(2,2) 1 0;pointSimA(2,2) pointSimA(1,2) 0 1]; 
    b = [pointSimB(:,1);pointSimB(:,2)];
    X_solution = inv(A)*b;
    X_solution = [X_solution(1) -X_solution(2) X_solution(3);X_solution(2) X_solution(1) X_solution(4)];
    M = matches;
    M(:,perm(1:2)) = [];
    pointsA = Fa_out(1:2,M(1,:));
    pointsB = Fb_out(1:2,M(2,:));
    for k = 1:size(pointsA,2)
        consensus(:,k) = X_solution*[pointsA(:,k);1];
    end
    offset = consensus - pointsB;
    for k = 1:size(offset,2)
        inlier(k) = norm(offset(:,k));
    end
    inlier = numel(inlier(inlier < threshold));
    model(1,i) = inlier;
    model(2:7,i) = X_solution(:);
end

%Select the model with the biggest number of inliers

modelInliers = model(1,:);
[indxRow, indxCol] = find(modelInliers == max(modelInliers(:)));
model = model(2:7,indxCol(1));
model = reshape(model,[2,3]);

%Take points that agree with the model (corregir sacar modelo promedio)

linePointsA = Fa_out(1:2,matches(1,:));
linePointsB = Fb_out(1:2,matches(2,:));
for k = 1:size(linePointsA,2)
    consensus(:,k) = model*[linePointsA(:,k);1];
end
offset = consensus - linePointsB;
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
saveas(gcf,'output/simRansac.jpg');
close all;