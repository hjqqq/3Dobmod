function test2

im = imread('pn1.jpg');
if size(im,3) > 1
    im = rgb2gray(im);
end
im = double(im);
if max(max(im))>1
    im = im/255;
end
[m,~] = gradmag(im,4);
mbin = m>0.05;
imshow(mbin)
end