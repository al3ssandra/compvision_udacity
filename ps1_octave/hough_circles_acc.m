function H = hough_circles_acc(BW, Gdir, radius)
    % Compute Hough accumulator array for finding circles.
    %
    % BW: Binary (black and white) image containing edge pixels
    % radius: Radius of circles to look for, in pixels

    % TODO: Your code here

    [row, col] = find(BW);
    R = max(radius);
    cosine = cos((pi/180).*Gdir);
    sine = sin((pi/180).*Gdir);
    acc = zeros(size(BW)(1),size(BW)(2));
    acc = padarray(acc,[R R]);
    for i=1:length(row);
        a_pos = round(col(i) - radius*cosine(row(i),col(i))) + R;
        b_pos = round(row(i) + radius*sine(row(i),col(i))) + R;
        a_neg = round(col(i) + radius*cosine(row(i),col(i))) + R;
        b_neg = round(row(i) - radius*sine(row(i),col(i))) + R;
        pos_indx = sub2ind(size(acc),b_pos,a_pos);
        neg_indx = sub2ind(size(acc),b_neg,a_neg);
        acc(pos_indx) += 1;
        acc(neg_indx) += 1;
    end
    H = acc(R+1:size(acc)(1)-R,R+1:size(acc)(2)-R);

endfunction

