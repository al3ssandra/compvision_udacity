points2D_ID = fopen('input/pts2d-pic_b.txt','r');
points3D_ID = fopen('input/pts3d.txt','r');
formatSpec = '%f';
points2D = fscanf(points2D_ID,formatSpec);
points2D = reshape(points2D,2,[])';
points3D = fscanf(points3D_ID,formatSpec);
points3D = reshape(points3D,3,[])';
A_u = [points3D ones(size(points3D,1),1) zeros(size(points3D,1),4) -points2D(:,1).*points3D -points2D(:,1)];
A_v = [zeros(size(points3D,1),4) points3D ones(size(points3D,1),1) -points2D(:,2).*points3D -points2D(:,2)];
A = [A_u;A_v];
[U,D,V] = svd(A'*A);
m = V(:,end);
m = reshape(m,4,3)';