%Confusion Matrix

%load('ps7.mat')

%Generate Confusion Matrix using Central Moments 
ModelCM = [modelA1_CM; modelA2_CM; modelA3_CM];
DataCM(:,:,1) = CM_dataA1;
DataCM(:,:,2) = CM_dataA2;
DataCM(:,:,3) = CM_dataA3;
DataSize = size(CM_dataA1,1);

for i = 1:3
    for j = 1:3
        dif = bsxfun(@minus, DataCM(:,:,i), ModelCM(j,:));
        EucDist(:,j) = sqrt(sum(dif.^2,2));
    end
        [M,I] = min(EucDist,[],2);
        CMatrix_CM(i,1) = numel(I(I == 1))/DataSize; 
        CMatrix_CM(i,2) = numel(I(I == 2))/DataSize;
        CMatrix_CM(i,3) = numel(I(I == 3))/DataSize;
end

%Generate Confusion Matrix using Scale Invariant Moments 
ModelSI = [modelA1_SI; modelA2_SI; modelA3_SI];
DataSI(:,:,1) = SI_dataA1;
DataSI(:,:,2) = SI_dataA2;
DataSI(:,:,3) = SI_dataA3;

for i = 1:3
    for j = 1:3
        dif = bsxfun(@minus, DataSI(:,:,i), ModelSI(j,:));
        EucDist(:,j) = sqrt(sum(dif.^2,2));
    end
        [M,I] = min(EucDist,[],2);
        CMatrix_SI(i,1) = numel(I(I == 1))/DataSize; 
        CMatrix_SI(i,2) = numel(I(I == 2))/DataSize;
        CMatrix_SI(i,3) = numel(I(I == 3))/DataSize;
end

%imagesc(CMatrix_CM); colormap('Gray');
%saveas(gcf,'output/CM_ConfMatrix.jpg');
%close all;
%imagesc(CMatrix_SI); colormap('Gray');
%saveas(gcf,'output/SI_ConfMatrix.jpg');
%close all;