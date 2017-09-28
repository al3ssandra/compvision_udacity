function R_constellation = threshAndNms(R,threshold,radius)
    R_scaled = (R-min(R(:)))./max((R-min(R(:)))(:));
    R_scaled = R_scaled*255;
    [r,c] = find(R_scaled > threshold*max(R_scaled(:)));
    R_scaled(R_scaled <= threshold*max(R_scaled(:))) = 0;
    r = r + radius;
    c = c + radius;
    R_scaled = padarray(R_scaled,[radius radius]);

    for i = 1:length(r)
        neighbors = R_scaled(r(i)-radius:r(i)+radius,c(i)-radius:c(i)+radius);
        neighbors(neighbors < max(neighbors(:))) = 0;
        R_scaled(r(i)-radius:r(i)+radius,c(i)-radius:c(i)+radius) = neighbors;
    end

    R_constellation = R_scaled(radius+1:radius+size(R,1),radius+1:radius+size(R,2));
    R_constellation(R_constellation > 0) = 1;