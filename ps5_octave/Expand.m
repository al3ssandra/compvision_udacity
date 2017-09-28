function expanded = Expand(img)

    h = [1 4 6 4 1]/8;
    expanded = zeros(2*size(img));
    expanded(1:2:end,1:2:end) = img;
    expanded = conv2(conv2(expanded,h,'same'),h','same');