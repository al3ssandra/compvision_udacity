function peaks = hough_peaks(H, varargin)
    % Find peaks in a Hough accumulator array.
    %
    % Threshold (optional): Threshold at which values of H are considered to be peaks
    % NHoodSize (optional): Size of the suppression neighborhood, [M N]
    %
    % Please see the Matlab documentation for houghpeaks():
    % http://www.mathworks.com/help/images/ref/houghpeaks.html
    % Your code should imitate the matlab implementation.

    %% Parse input arguments
    p = inputParser;
    addOptional(p, 'numpeaks', 1, @isnumeric);
    addParamValue(p, 'Threshold', 0.5 * max(H(:)));
    addParamValue(p, 'NHoodSize', floor(size(H) / 100.0) * 2 + 1);  % odd values >= size(H)/50
    parse(p, varargin{:});

    numpeaks = p.Results.numpeaks;
    threshold = p.Results.Threshold;
    nHoodSize = p.Results.NHoodSize;

    % TODO: Your code here
   
    Done = false;
    Hpeaks = padarray(H, [(nHoodSize(1)-1)/2 (nHoodSize(2)-1)/2]);
    r = []; c = [];
    while ~Done
        [row, col] = find(Hpeaks == max(Hpeaks(:)));
        if Hpeaks(row(1),col(1)) >= threshold
            r(end+1) = row(1) - (nHoodSize(1)-1)/2;
            c(end+1) = col(1) - (nHoodSize(2)-1)/2;
            Hpeaks(row(1) - (nHoodSize(1)-1)/2:row(1) + (nHoodSize(1)-1)/2,col(1) - (nHoodSize(2)-1)/2:col(1) + (nHoodSize(2)-1)/2) = 0;
    
            Done = length(r) == numpeaks;
        else
            Done = true;
        end
    end
    peaks(:,1) = r;
    peaks(:,2) = c;
    
endfunction
