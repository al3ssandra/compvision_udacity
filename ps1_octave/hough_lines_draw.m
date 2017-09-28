function hough_lines_draw(img, outfile, peaks, rho, theta)
    % Draw lines found in an image using Hough transform.
    %
    % img: Image on top of which to draw lines
    % outfile: Output image filename to save plot as
    % peaks: Qx2 matrix containing row, column indices of the Q peaks found in accumulator
    % rho: Vector of rho values, in pixels
    % theta: Vector of theta values, in degrees

    % TODO: Your code here
    
    theta = theta.*(pi/180);
    [len, wid] = size(img);
    figure();
    imshow(img);
    hold on;
    for i = 1:size(peaks)(1)
        sine = sin(theta(peaks(i,2)));
        cosine = cos(theta(peaks(i,2)));
        x0 = rho(peaks(i,1))*cosine;
        y0 = rho(peaks(i,1))*sine;
        x1 = x0 - 1000*sine;
        x2 = x0 + 1000*sine;
        y1 = y0 + 1000*cosine;
        y2 = y0 - 1000*cosine;
        line([x1 x2],[y1 y2],'Color','r','LineWidth',4);
    end
    saveas(gcf, outfile);
    hold off;
    
endfunction
