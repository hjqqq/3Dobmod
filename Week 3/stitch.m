function xdata = stitch(im1,im2);

if nargin<1
    im1 = single(rgb2gray(imread('boat/left.jpg')));
    im2 = single(rgb2gray(imread('boat/right.jpg')));
    figure(4)
    imshow(im2,[])
end

im3 = NaN;
%find matching points
[f1,d1] = vl_sift(im1);
[f2,d2] = vl_sift(im2);
[matches, scores] = vl_ubcmatch(d1, d2) ;
f1match=f1(:,matches(1,:));
f2match=f2(:,matches(2,:));
p1 = f1match(1:2,:);
p2 = f2match(1:2,:);

%perform RANSAC to find transformation
[T, M] = RANSAC(1000,p1,p2);
T;
xdata=0;
%transform the 2cnd image
tt = maketform('affine',[M [0;0];0 0 1 ]);
[B,xdata,ydata]=imtransform(im2,tt);
xdata
ydata
figure(1)
imshow(im1,[])
figure(2)
imshow(B,[]);
size(B)

%define new image size
im3=zeros(size(im1,1),size(B,2)-floor(T(1)));
T(2)
ydata(1)
shi=-floor((T(2))-2*ydata(1))

im3(1:size(im1,1),1:size(im1,2))=im1;
im3(shi:shi+size(B,1)-1,end-size(B,2)+1:end)=B;
figure(3)
imshow(im3,[])
%return new image


