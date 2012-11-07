%test
function test
im = imread('zebra.png');
if size(im,3) > 1
    im = rgb2gray(im);
end
%imOut = gaussianConv('zebra.png',7,7);
%imshow(imOut,[])

[m,o] = gradmag(im,3);

figure(1)
imshow(m,[])
figure(2)
hold on
imshow(o,[-pi,pi])
colormap(hsv)
colorbar;