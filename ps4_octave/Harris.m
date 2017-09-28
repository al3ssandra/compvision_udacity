function R = Harris(I_x,I_y)
    Ix_squared = I_x.*I_x;
    Iy_squared = I_y.*I_y;
    IxIy = I_x.*I_y;
    window = fspecial('gaussian',21,3);
    window = window./max(window(:));
    [winRows,winCols] = size(window);
    winHalf = floor(winRows/2);
    Ix_aug = padarray(Ix_squared,[winHalf winHalf]);
    Iy_aug = padarray(Iy_squared,[winHalf winHalf]);
    Ixy_aug = padarray(IxIy,[winHalf winHalf]);
    [rows,cols] = size(I_x);
    
    for i = winHalf+1:winHalf+rows
        for j = winHalf+1:winHalf+cols
    
            M11 = Ix_aug(i-winHalf:i+winHalf,j-winHalf:j+winHalf).*window;
            M11 = sum(M11(:));
            M12 = Ixy_aug(i-winHalf:i+winHalf,j-winHalf:j+winHalf).*window; 
            M12 = sum(M12(:));
            M22 = Iy_aug(i-winHalf:i+winHalf,j-winHalf:j+winHalf).*window;
            M22 = sum(M22(:));
            M = [M11 M12;M12 M22];
            R(i - winHalf,j - winHalf) = det(M) - 0.05*trace(M)*trace(M);
        end
    end