%test
function test
im = imread('zebra.png');
im = rgb2gray(im);
%imOut = gaussianConv('zebra.png',7,7);
%imshow(imOut,[])

G = gaussian(5);
Gd = gaussianDer(G,5);