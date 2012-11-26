function demo1()

% im1 = imread('synth1.pgm');
% im2 = imread('synth2.pgm');
% [F,ind] = flow(im1,im2);
% imshow(im1)
% hold on
% quiver(ind(:,:,1),ind(:,:,2),F(:,:,1),F(:,:,2),'m');
% 
% pause()

im1 = rgb2gray(imread('sphere1.ppm'));
im2 = rgb2gray(imread('sphere2.ppm'));
[F,ind] = flow(im1,im2);
imshow(im1)
hold on
quiver(ind(:,:,2),ind(:,:,1),F(:,:,1),F(:,:,2),'m');

end


