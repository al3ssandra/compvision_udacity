%Gaussian pyramid
function reduced = Reduce(img)

    h = [1 4 6 4 1]/16;
    %reduced = conv2(conv2(img,h,'same'),h','same')(1:2:end,1:2:end);
    reduced = imfilter(imfilter(img,h,'symmetric'),h','symmetric')(1:2:end,1:2:end);