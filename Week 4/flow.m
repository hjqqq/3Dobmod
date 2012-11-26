%function F = flow(im1,im2)
% calculates the optical flow between images im1 and im2
%
%INPUT
%- im1: first image (in time) should be in black and white
%- im2: second image (in time) should be in black and white
%
%OUTPUT
%- F: vector of flows
%- ind: indexes of the flow vectors
function [F,ind] = flow(im1,im2)

if nargin < 1
    im1 = imread('synth1.pgm');
    im2 = imread('synth2.pgm');
end
% devide regions
[h,w] = size(im1);

hDevide = floor(h/15);
wDevide = floor(w/15);

ind = zeros(hDevide,wDevide,2);
ind(:,:,1) = repmat((0:wDevide-1)',1,hDevide)*15+7.5;
ind(:,:,2) = repmat((0:hDevide-1),wDevide,1)*15+7.5;

Ix = conv2(im1,[-1,0,1],'same');
Iy = conv2(im1,[-1,0,1]','same');
It = im2-im1;

F = zeros(hDevide,wDevide,2);
for i=0:hDevide-1
    for j=0:wDevide-1
        A1 =Ix(i*15+1:(i+1)*15,j*15+1:(j+1)*15);
        A2 =Iy(i*15+1:(i+1)*15,j*15+1:(j+1)*15);
        A = [A1(:) , A2(:)];
        b = It(i*15+1:(i+1)*15,j*15+1:(j+1)*15);
        b = b(:);
        v = inv(A'*A) * A' * double(b);
        F(i+1,j+1,:) = v;
    end
end

% compute A At and b



% visualize

end