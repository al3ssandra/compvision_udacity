%Confusion Matrix

%Run Recognition.m
%Recognition

%Generate Confusion Matrix using Central Moments 
EucDist_11 = bsxfun(@minus, CM_dataA1, modelA1_CM);
EucDist_11 = sqrt(sum(EucDist_11.^2,2));

EucDist_12 = bsxfun(@minus, CM_dataA1, modelA2_CM);
EucDist_12 = sqrt(sum(EucDist_12.^2,2));

EucDist_13 = bsxfun(@minus, CM_dataA1, modelA3_CM);
EucDist_13 = sqrt(sum(EucDist_13.^2,2));

[M,I] = min([EucDist_11 EucDist_12 EucDist_13],[],2);
CMatrix_11 = 100*numel(I(I == 1))/size(CM_dataA1,1); 
CMatrix_12 = 100*numel(I(I == 2))/size(CM_dataA1,1);
CMatrix_13 = 100*numel(I(I == 3))/size(CM_dataA1,1);

EucDist_21 = bsxfun(@minus, CM_dataA2, modelA1_CM);
EucDist_21 = sqrt(sum(EucDist_21.^2,2));

EucDist_22 = bsxfun(@minus, CM_dataA2, modelA2_CM);
EucDist_22 = sqrt(sum(EucDist_22.^2,2));

EucDist_23 = bsxfun(@minus, CM_dataA2, modelA3_CM);
EucDist_23 = sqrt(sum(EucDist_23.^2,2));

[M,I] = min([EucDist_21 EucDist_22 EucDist_23],[],2);
CMatrix_21 = 100*numel(I(I == 1))/size(CM_dataA1,1); 
CMatrix_22 = 100*numel(I(I == 2))/size(CM_dataA1,1);
CMatrix_23 = 100*numel(I(I == 3))/size(CM_dataA1,1);

EucDist_31 = bsxfun(@minus, CM_dataA3, modelA1_CM);
EucDist_31 = sqrt(sum(EucDist_31.^2,2));

EucDist_32 = bsxfun(@minus, CM_dataA3, modelA2_CM);
EucDist_32 = sqrt(sum(EucDist_32.^2,2));

EucDist_33 = bsxfun(@minus, CM_dataA3, modelA3_CM);
EucDist_33 = sqrt(sum(EucDist_33.^2,2));

[M,I] = min([EucDist_31 EucDist_32 EucDist_33],[],2);
CMatrix_31 = 100*numel(I(I == 1))/size(CM_dataA1,1); 
CMatrix_32 = 100*numel(I(I == 2))/size(CM_dataA1,1);
CMatrix_33 = 100*numel(I(I == 3))/size(CM_dataA1,1);

CMatrix = [CMatrix_11 CMatrix_12 CMatrix_13;CMatrix_21 CMatrix_22 CMatrix_23;CMatrix_31 CMatrix_32 CMatrix_33];