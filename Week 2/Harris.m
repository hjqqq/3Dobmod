%Harris corner detecter
function [r,c] = Harris(im,n)
if nargin < 1
     n = 3;
end
k = 0.04;


r = [];
c = [];

sigma = 0.1;
G = gaussian(sigma);
Gd = gaussianDer(G,sigma);
L = (length(Gd)-1)/2;

%derivatives in x and y
Ix = conv2(Gd,conv2(G',im));
Ix = Ix(1+L:end-L,1+L:end-L);
Iy = conv2(Gd',conv2(G,im));
Iy = Iy(1+L:end-L,1+L:end-L);

IxIy = Ix.*Iy;
IxIx = Ix.*Ix;
IyIy = Iy.*Iy;

Det   = IxIx.*IyIy - IxIy.*IxIy;
Trace = IxIx + IyIy;

R = Det - k*(Trace.*Trace);

corners = (R > 0);

imshow(corners,[])