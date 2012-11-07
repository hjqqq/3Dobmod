%test
function test
im = imread('zebra.png');
im = rgb2gray(im);
%imOut = gaussianConv('zebra.png',7,7);
%imshow(imOut,[])

[m,o] = gradmag(im,1);

figure(1)
imshow(m,[])
figure(2)
imshow(o,[-pi,pi])
colormap(hsv)
colorbar;