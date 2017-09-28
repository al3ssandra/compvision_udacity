pkg load image;  % Octave only
pkg load geometry;

%% 1-a
%img = imread('input/ps1-input0.png');  % already grayscale
%% TODO: Compute edge image img_edges
%img_edges = edge(img, 'lindeberg');
%imwrite(img_edges, 'output/ps1-1-a-1.png');  % save as output/ps1-1-a-1.png

%% 2-a
%[H, theta, rho] = hough_lines_acc(img_edges);  % defined in hough_lines_acc.m
%H_norm = uint8(H);
%% TODO: Plot/show accumulator array H, save as output/ps1-2-a-1.png
%imwrite(H_norm, 'output/ps1-2-a-1.png')

%% 2-b
%P = hough_peaks(H, 10);  % defined in hough_peaks.m
%% TODO: Highlight peak locations on accumulator array, save as output/ps1-2-b-1.png
%imshow(H,[],'XData',theta,'YData',rho,'InitialMagnification','fit');
%xlabel('\theta'), ylabel('\rho');
%axis on, axis normal, hold on;
%plot(theta(P(:,2)),rho(P(:,1)),'s','color','cyan');
%saveas(gcf, 'output/ps1-2-b-1.png');

%% TODO: Rest of your code here

%% 2-c
%hough_lines_draw(img, 'output/ps1-2-c-1.png', P, rho, theta);

%% 3-a
%img_noise = imread('input/ps1-input0-noise.png');
%smoothFilt = fspecial('gaussian', 9, 7); 
%ImgBlur = imfilter(img_noise,smoothFilt);
%imwrite(ImgBlur, 'output/ps1-3-a-1.png'); 

%% 3-b
%img_edgesBlur = edge(ImgBlur, 'canny');
%imwrite(img_edgesBlur, 'output/ps1-3-b-2.png');
%img_edgesNoise = edge(img_noise, 'canny');
%imwrite(img_edgesNoise, 'output/ps1-3-b-1.png');

%% 3-c
%[H, theta, rho] = hough_lines_acc(img_edgesBlur); 
%P = hough_peaks(H, 10);
%imshow(H,[],'XData',theta,'YData',rho,'InitialMagnification','fit');
%xlabel('\theta'), ylabel('\rho');
%axis on, axis normal, hold on;
%plot(theta(P(:,2)),rho(P(:,1)),'s','color','cyan');
%saveas(gcf, 'output/ps1-3-c-1.png');
%hough_lines_draw(img_noise, 'output/ps1-3-c-2.png', P, rho, theta);

%% 4-a
%img_coinpen = rgb2gray(imread('input/ps1-input1.png'));
%smoothFilt = fspecial('gaussian', 17, 3); 
%ImgBlur = imfilter(img_coinpen,smoothFilt,'symmetric');
%imwrite(ImgBlur, 'output/ps1-4-a-1.png');

%% 4-b
%coinpen_edge = edge(ImgBlur, 'canny');
%imwrite(coinpen_edge, 'output/ps1-4-b-1.png');

%% 4-c
%[H, theta, rho] = hough_lines_acc(coinpen_edge); 
%P = hough_peaks(H, 4); 
%imshow(H,[],'XData',theta,'YData',rho,'InitialMagnification','fit');
%xlabel('\theta'), ylabel('\rho');
%axis on, axis normal, hold on;
%plot(theta(P(:,2)),rho(P(:,1)),'s','color','cyan');
%saveas(gcf, 'output/ps1-4-c-1.png');
%hough_lines_draw(img_coinpen, 'output/ps1-4-c-2.png', P, rho, theta);

%% 5-a
%[Gmag, Gdir] = imgradient(img_coinpen);
%H = hough_circles_acc(coinpen_edge, Gdir, 20);
%centers = hough_peaks(H, 10);
%r = [];
%r(1:length(centers(:,1))) = 20;
%imshow(img_coinpen); hold on;
%drawCircle(centers(:,2), centers(:,1), r', 'Color','r','LineWidth',2);
%saveas(gcf, 'output/ps1-5-a-3.png');
%hold off;

%% 5-b
%[centers, radii] = find_circles(coinpen_edge, Gdir, [15:30]);
%x = centers(:,2);
%y = centers(:,1);
%figure();
%imshow(img_coinpen);
%hold on;
%for i = 1:length(x)
    %drawCircle(x(i), y(i), radii(i), 'Color','r','LineWidth',2);
%end
%saveas(gcf, 'output/ps1-5-b-1.png');
%hold off

%% 6-a
img_clutter = rgb2gray(imread('input/ps1-input2.png'));
smoothFilt = fspecial('gaussian', 17, 3); 
ImgBlur = imfilter(img_clutter,smoothFilt,'symmetric');
clutter_edge = edge(ImgBlur, 'canny');
[H, theta, rho] = hough_lines_acc(clutter_edge);
P = hough_peaks(H, 15, 'Threshold', 0.4*max(H(:)));
hough_lines_draw(ImgBlur, 'output/ps1-6-a-1.png', P, rho, theta);