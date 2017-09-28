points2D_ID = fopen('input/pts2d-norm-pic_a.txt','r');
points3D_ID = fopen('input/pts3d-norm.txt','r');
formatSpec = '%f';
points2D = fscanf(points2D_ID,formatSpec);
points2D = reshape(points2D,2,[])';
points3D = fscanf(points3D_ID,formatSpec);
points3D = reshape(points3D,3,[])';
A_u = [points3D ones(size(points3D,1),1) zeros(size(points3D,1),4) -points2D(:,1).*points3D];
A_v = [zeros(size(points3D,1),4) points3D ones(size(points3D,1),1) -points2D(:,2).*points3D];
A = [A_u;A_v];
b = points2D(:);
m_norm = inv(A'*A)*A'*b;
m_norm = [m_norm;1];
m_norm = reshape(m_norm,4,3)';
Q = m_norm(:,1:3); m4 = m_norm(:,end);
C_norm = [-inv(Q)*m4;1];