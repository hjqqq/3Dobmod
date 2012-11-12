function test2

%im = imread('pn1.jpg');
im= zeros(301,301);
im(150,150) = 1;
im = double(im);
%imshow(im);
F=ImageDerivatives(im,1,'x');
size(F)
max(max(F))
%max(F)
%imshow(F);
% if size(im,3) > 1
%     im = rgb2gray(im);
% end
% im = double(im);
if max(max(F))>1
    F = F/255;
end
% [m,~] = gradmag(im,10);
% %mbin = m>0.05;
 imshow(F)
end