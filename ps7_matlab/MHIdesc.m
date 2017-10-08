function descriptor = MHIdesc(readerobj,tao,actionStop)
    vidFrames = read(readerobj);
    numFrames = get(readerobj, 'NumberOfFrames');
    H = fspecial('gaussian',15,3);

    for i = 1:numFrames
        blurFrames(:,:,:,i) = imfilter(vidFrames(:,:,:,i),H);
    end

    for i = 2:numFrames
        B(:,:,i-1) = rgb2gray(abs(blurFrames(:,:,:,i)- blurFrames(:,:,:,i-1)));
    end
    BW = B > 15;

    for j=1:numFrames - 1
        se = strel('disk',5);
        afterOpening(:,:,j) = imopen(BW(:,:,j),se);
    end 
 
    rows = readerobj.Height;
    cols = readerobj.width;
    MHI_previous = ones(rows,cols);
    MHI = ones(rows,cols);
    for i = actionStop - tao + 1:actionStop
        MHI(MHI_previous > 0) = MHI(MHI_previous > 0) - 1;
        MHI(afterOpening(:,:,i)) = tao;
        MHI_previous = MHI;
    end
    MHI_scaled = MHI./max(MHI(:));
    MEI = MHI > 0;

    %Image moments
    [X,Y] = meshgrid(1:cols,1:rows);
    M10 = X.*MHI_scaled;
    M10 = sum(M10(:));
    M01 = Y.*MHI_scaled;
    M01 = sum(M01(:));
    M00 = sum(MHI_scaled(:));
    average_X = M10/M00;
    average_Y = M01/M00;

    %MHI Central Moments
    X_central = X - average_X;
    Y_central = Y - average_Y;

    CM_20 = X_central.^2;
    CM_20 = CM_20.*MHI_scaled;
    CM_20 = sum(CM_20(:));

    CM_02 = Y_central.^2;
    CM_02 = CM_02.*MHI_scaled;
    CM_02 = sum(CM_02(:));

    CM_12 = X_central.*Y_central.^2;
    CM_12 = CM_12.*MHI_scaled;
    CM_12 = sum(CM_12(:));

    CM_21 = Y_central.*X_central.^2;
    CM_21 = CM_21.*MHI_scaled;
    CM_21 = sum(CM_21(:));

    CM_22 = X_central.^2.*Y_central.^2;
    CM_22 = CM_22.*MHI_scaled;
    CM_22 = sum(CM_22(:));

    CM_30 = X_central.^3;
    CM_30 = CM_30.*MHI_scaled;
    CM_30 = sum(CM_30(:));

    CM_03 = Y_central.^3;
    CM_03 = CM_03.*MHI_scaled;
    CM_03 = sum(CM_03(:));

    %MEI Central Moments
    M10_MEI = X.*MEI;
    M10_MEI = sum(M10_MEI(:));
    M01_MEI = Y.*MEI;
    M01_MEI = sum(M01_MEI(:));
    M00_MEI = sum(MEI(:));
    average_X_MEI = M10_MEI/M00_MEI;
    average_Y_MEI = M01_MEI/M00_MEI;

    X_central_MEI = X - average_X_MEI;
    Y_central_MEI = Y - average_Y_MEI;

    CM_20_MEI = X_central_MEI.^2;
    CM_20_MEI = CM_20_MEI.*MEI;
    CM_20_MEI = sum(CM_20_MEI(:));

    CM_02_MEI = Y_central_MEI.^2;
    CM_02_MEI = CM_02_MEI.*MEI;
    CM_02_MEI = sum(CM_02_MEI(:));

    CM_12_MEI = X_central_MEI.*Y_central_MEI.^2;
    CM_12_MEI = CM_12_MEI.*MEI;
    CM_12_MEI = sum(CM_12_MEI(:));

    CM_21_MEI = Y_central_MEI.*X_central_MEI.^2;
    CM_21_MEI = CM_21_MEI.*MEI;
    CM_21_MEI = sum(CM_21_MEI(:));

    CM_22_MEI = X_central_MEI.^2.*Y_central_MEI.^2;
    CM_22_MEI = CM_22_MEI.*MEI;
    CM_22_MEI = sum(CM_22_MEI(:));

    CM_30_MEI = X_central_MEI.^3;
    CM_30_MEI = CM_30_MEI.*MEI;
    CM_30_MEI = sum(CM_30_MEI(:));

    CM_03_MEI = Y_central_MEI.^3;
    CM_03_MEI = CM_03_MEI.*MEI;
    CM_03_MEI = sum(CM_03_MEI(:));

    descriptor = [CM_20 CM_02 CM_12 CM_21 CM_22 CM_30 CM_03 CM_20_MEI CM_02_MEI CM_12_MEI CM_21_MEI CM_22_MEI CM_30_MEI CM_03_MEI];