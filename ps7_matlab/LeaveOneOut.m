%Confusion Matrix Removing Test Subject

load('ps7.mat')

%Feature Scaling (Central Moments)

dataSize = size(CM_dataA1,1);

meanNorm = bsxfun(@minus, CM_dataA1, mean(CM_dataA1)); 
DataCM(:,:,1)= bsxfun(@rdivide, meanNorm, range(CM_dataA1));

meanNorm = bsxfun(@minus, CM_dataA2, mean(CM_dataA2)); 
DataCM(:,:,2)= bsxfun(@rdivide, meanNorm, range(CM_dataA2));

meanNorm = bsxfun(@minus, CM_dataA3, mean(CM_dataA3)); 
DataCM(:,:,3)= bsxfun(@rdivide, meanNorm, range(CM_dataA3));

%Remove Test Subect 1 from all the three actions

D1= DataCM(4:dataSize,:,1);
D2= DataCM(4:dataSize,:,2);
D3= DataCM(4:dataSize,:,3);

crossValidation(:,:,1) = D1;
crossValidation(:,:,2) = D2;
crossValidation(:,:,3) = D3;
dataSize = size(crossValidation,1);

P1(1,:) = mean(DataCM(1:3,:,1));
P1(2,:) = mean(DataCM(1:3,:,2));
P1(3,:) = mean(DataCM(1:3,:,3));

%Confusion Matrix for test subject 1 using scaled central moments(P1)

for i = 1:3
    for j = 1:3
        dif = bsxfun(@minus, crossValidation(:,:,i), P1(j,:));
        EucDist(:,j) = sqrt(sum(dif.^2,2));
    end
        [M,I] = min(EucDist,[],2);
        crossCMatrix_CM(i,1) = numel(I(I == 1))/dataSize; 
        crossCMatrix_CM(i,2) = numel(I(I == 2))/dataSize;
        crossCMatrix_CM(i,3) = numel(I(I == 3))/dataSize;
end

imagesc(crossCMatrix_CM); colormap('Gray');
%saveas(gcf,'output/CM_ConfMatrix.jpg');