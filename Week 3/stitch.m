% im3 = stitch(im1,im2,mode)
%
% INPUT
% - im1: first image should be grayscale and of single precision
% - im2: second image should be grayscale and of single precision
% - mode: can be either 'affine' or 'projective'
%
% OUTPUT
% - im3: stitched image
function im3 = stitch(im1,im2,mode);


if nargin<1
    im1 = single(rgb2gray(imread('boat/left.jpg')));
    im2 = single(rgb2gray(imread('boat/right.jpg'))); 
    mode = 'affine';
end

%find matching points
[f1,d1] = vl_sift(im1);
[f2,d2] = vl_sift(im2);
[matches, ~] = vl_ubcmatch(d1, d2) ;
f1match=f1(:,matches(1,:));
f2match=f2(:,matches(2,:));
p1 = f1match(1:2,:);
p2 = f2match(1:2,:);

%perform RANSAC to find transformation

A = RANSAC(5000,p1,p2,mode);

%make t-form for both first and second image
tA = maketform(mode,A');
tI = maketform(mode,eye(3));

%find new image size
[h,w] = size(im1);
[h2,w2] = size(im2);
newcorners = A*[1,w,1,w;1,1,h,h;1,1,1,1];
minXY = min([newcorners [w2;h2;1]],[],2);
maxXY = max([newcorners [w2;h2;1]],[],2);

Xdata = [minXY(1), maxXY(1)];
Ydata = [minXY(2), maxXY(2)];

%transform both images to canvas and combine
imt1 = imtransform(im1,tA,'Xdata',Xdata,'Ydata',Ydata,'FillValues',NaN);
imt2 = imtransform(im2,tI,'Xdata',Xdata,'Ydata',Ydata,'FillValues',NaN);
imshow(imt1,[]);
[nh, nw] = size(imt1);
size(imt1)
size(imt2)
im3 = nanmean([imt1(:),imt2(:)],2);
im3 = reshape(im3,nh,nw);
%imshow(im3,[]);
end

