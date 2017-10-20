function [CM, SI] = MHIdesc(readerobj,tao,actionStop)
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
    %MHI moments
    [X,Y] = meshgrid(1:cols,1:rows);
    M10 = X.*MHI_scaled;
    M10 = sum(M10(:));
    M01 = Y.*MHI_scaled;
    M01 = sum(M01(:));
    M00 = sum(MHI_scaled(:));
    average_X = M10/M00;
    average_Y = M01/M00;
    X_central = X - average_X;
    Y_central = Y - average_Y;

    %MEI Moments
    M10_MEI = X.*MEI;
    M10_MEI = sum(M10_MEI(:));
    M01_MEI = Y.*MEI;
    M01_MEI = sum(M01_MEI(:));
    M00_MEI = sum(MEI(:));
    average_X_MEI = M10_MEI/M00_MEI;
    average_Y_MEI = M01_MEI/M00_MEI;
    X_central_MEI = X - average_X_MEI;
    Y_central_MEI = Y - average_Y_MEI;
    
    %Central Moments and Scale Invariant Moments
    SIM_MHI = [];
    SIM_MEI = [];
    CM = [];
    CM_MEI = [];
    p = [2 0 1 2 2 3 0];
    q = [0 2 2 1 2 0 3];
    
    for i = 1:length(p)
        cm = X_central.^p(i).*Y_central.^q(i);
        cm = cm.*MHI_scaled;
        cm = sum(cm(:));
        CM(i) = cm;
        cm_mei = X_central_MEI.^p(i).*Y_central_MEI.^q(i);
        cm_mei = cm_mei.*MEI;
        cm_mei = sum(cm_mei(:));
        CM_MEI(i) = cm_mei;
        sim_mhi = cm/(M00^(1 + 0.5*(p(i)+q(i))));  
        SIM_MHI(i) = sim_mhi;
        sim_mei = cm_mei/(M00_MEI^(1 + 0.5*(p(i)+q(i)))); 
        SIM_MEI(i) = sim_mei;
    end 
    
    CM = [CM CM_MEI];
    SI = [SIM_MHI SIM_MEI];