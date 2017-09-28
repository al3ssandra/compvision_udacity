function D = disparity_ssd(L, R)
    % Compute disparity map D(y, x) such that: L(y, x) = R(y, x + D(y, x))
    %
    % L: Grayscale left image
    % R: Grayscale right image, same size as L
    % D: Output disparity map, same size as L, R

    % TODO: Your code here
    tplRows = 5; tplCols = 5;
    tplRowHalf = floor(tplRows/2); 
    tplColHalf = floor(tplCols/2);
    L_aug = padarray(L, [tplRowHalf tplColHalf], -1);
    R_aug = padarray(R, [tplRowHalf tplColHalf], -1);
    [rows, cols] = size(L);
    
    for i = tplRowHalf+1:tplRowHalf+rows
        for j = tplColHalf+1:tplColHalf+cols
        
            X = R_aug(i-tplRowHalf:i+tplRowHalf,:);
            X = X(X>-1);
            X = reshape(X,[numel(X)/cols cols]);
            [Xrows, Xcols] = size(X);
            templateAug = L_aug(i-tplRowHalf:i+tplRowHalf,j-tplColHalf:j+tplColHalf);
            template = templateAug(templateAug>-1);
            template = reshape(template,[size(X,1) numel(template)/size(X,1)]);
            [tempRows, tempCols] = size(template);
            template = template(:);
            X = repmat(X,tempCols,1);
            M = (template - X).^2;
            M = reshape(M', Xcols, Xrows, []);
            M = squeeze(sum(M,2))';
            M = [M zeros(size(M,1),tempCols-1)];
            shifts = flipud([0:tempCols-1]');
            [m, n] = size(M);
            [R, C] = ndgrid(1:m,1:n);
            C = mod(bsxfun(@plus,C,shifts-1),n)+1;
            M(sub2ind(size(M), R, C)) = M(:);
            M = sum(M);
            extraCols = templateAug(:,end-tplColHalf+1:end);
            extraCols = numel(extraCols(extraCols==-1))/tplRows;
            SSD_shift = abs(extraCols-tplColHalf);
            M = M(SSD_shift + 1:SSD_shift + cols);
            tempRowIndex = i - tplRowHalf;
            tempColIndex = j - tplColHalf;
            [dummy, minIndex] = min(M);
            D(tempRowIndex,tempColIndex) = minIndex - tempColIndex; 
            
        end
            
end
