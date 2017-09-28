function [centers, radii] = find_circles(BW, Gdir, radius)
    % Find circles in given radius range using Hough transform.
    %
    % BW: Binary (black and white) image containing edge pixels
    % radius_range: Range of circle radii [min max] to look for, in pixels

    % TODO: Your code here

    [row, col] = find(BW);
    R = max(radius);
    cosine = cos((pi/180).*Gdir);
    sine = sin((pi/180).*Gdir);
    acc = zeros(size(BW)(1),size(BW)(2));
    acc = padarray(acc,[R R]);
    r = zeros(size(acc));
    for i=1:length(row);
        a_pos = round(col(i) - radius*cosine(row(i),col(i))) + R;
        b_pos = round(row(i) + radius*sine(row(i),col(i))) + R;
        a_neg = round(col(i) + radius*cosine(row(i),col(i))) + R;
        b_neg = round(row(i) - radius*sine(row(i),col(i))) + R;
        pos_indx = sub2ind(size(acc),b_pos,a_pos);
        neg_indx = sub2ind(size(acc),b_neg,a_neg);
        acc(pos_indx) += 1;
        acc(neg_indx) += 1;
        r(pos_indx) = radius;
        r(neg_indx) = radius;
    end
    H = acc(R+1:size(acc)(1)-R,R+1:size(acc)(2)-R);
    radii = r(R+1:size(r)(1)-R,R+1:size(r)(2)-R);
    
    threshold = 0.5 * max(H(:));
    nHoodSize = floor(size(H) / 100.0) * 2 + 1;
    Done = false;
    Hpeaks = padarray(H, [(nHoodSize(1)-1)/2 (nHoodSize(2)-1)/2]);
    r = []; c = [];
    while ~Done
        [row, col] = find(Hpeaks == max(Hpeaks(:)));
        if Hpeaks(row(1),col(1)) >= threshold
            r(end+1) = row(1) - (nHoodSize(1)-1)/2;
            c(end+1) = col(1) - (nHoodSize(2)-1)/2;
            Hpeaks(row(1) - (nHoodSize(1)-1)/2:row(1) + (nHoodSize(1)-1)/2,col(1) - (nHoodSize(2)-1)/2:col(1) + (nHoodSize(2)-1)/2) = 0;
    
            %Done = length(r) == numpeaks;
        else
            Done = true;
        end
    end
    centers(:,1) = r;
    centers(:,2) = c;
    ind = sub2ind(size(radii),r,c);
    radii = radii(ind);

endfunction
