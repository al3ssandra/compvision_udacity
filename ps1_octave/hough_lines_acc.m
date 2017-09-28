function [H, theta, rho] = hough_lines_acc(BW, varargin)
    % Compute Hough accumulator array for finding lines.
    %
    % BW: Binary (black and white) image containing edge pixels
    % RhoResolution (optional): Difference between successive rho values, in pixels
    % Theta (optional): Vector of theta values to use, in degrees
    %
    % Please see the Matlab documentation for hough():
    % http://www.mathworks.com/help/images/ref/hough.html
    % Your code should imitate the Matlab implementation.
    %
    % Pay close attention to the coordinate system specified in the assignment.
    % Note: Rows of H should correspond to values of rho, columns those of theta.

    %% Parse input arguments
    p = inputParser();
    addParamValue(p, 'RhoResolution', 1);
    addParamValue(p, 'Theta', linspace(-90, 89, 180));
    parse(p, varargin{:});

    rhoStep = p.Results.RhoResolution;
    theta = p.Results.Theta;

    %% TODO: Your code here
    
    [rindx, cindx] = find(BW);
    numEdgePixl = numel(rindx);
    [height, width] = size(BW);
    D = norm([width height]);
    nrho = 2*(ceil(D/rhoStep)) + 1;
    diag = rhoStep*ceil(D/rhoStep);
    rhos = -diag:rhoStep:diag;
    thetas = (pi/180).*theta;
    numtheta = numel(thetas);
    H = zeros(nrho,numtheta);
    
    %Preallocate cosine and sine calculations to increase speed.
    %In addition to precallculating sine and cosine we are also
    %multiplying them by the proper pixel weights such that the
    %rows will be indexed by the pixel number and the columns will
    %be indexed by the thetas.
    %Example: cosine(3,:) is 2*cosine(0 to pi)
    %         cosine(:,1) is (0 to width of image)*cosine(0)
    
    accumulator = zeros(numEdgePixl, numtheta);
    cosine = (1:width)'*cos(thetas);
    sine = (1:height)'*sin(thetas);
    
    accumulator((1:numEdgePixl),:) = cosine(cindx,:) + sine(rindx,:);
    
    for i = 1:numtheta
      H(:,i) = hist(accumulator(:,i),rhos);
    end
    
    rho = rhos;
    
endfunction
