function R = Harris(im,n)
if nargin < 1
     n = 3;
end

xl=size(im,2);
yl=size(im,1);

k = 0.04;

w=fspecial('gaussian',3,1);

Ix = conv2(im,[-1,0,1],'same');
Iy = conv2(im,[-1,0,1]','same');

Ixx = Ix.*Ix;
Iyy = Iy.*Iy;
Ixy = Ix.*Iy;

M1 = conv2(Ixx,w,'same');
M2 = conv2(Ixy,w,'same');
M4 = conv2(Iyy,w,'same');

Det = M1.*M4 - M2.^2;
Tr  = M1 + M4;
R = Det - k*Tr.^2;

imshow(R,[])
end