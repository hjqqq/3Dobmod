function demo1()

% im1 = imread('synth1.pgm');
% im2 = imread('synth2.pgm');
% [F,ind] = flow(im1,im2);
% imshow(im1)
% hold on
% quiver(ind(:,:,1),ind(:,:,2),F(:,:,1),F(:,:,2),'m');
% 
% pause()

im1 = imread('sphere1.ppm');
im2 = imread('sphere2.ppm');

ig1 = rgb2gray(im1);
ig2 = rgb2gray(im2);
[F,ind] = flow(ig1,ig2,4);
imshow(im1)
hold on
quiver(ind(:,:,2),ind(:,:,1),F(:,:,1),F(:,:,2),'m');
f = getframe;
im = frame2im(f);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,'test','gif', 'Loopcount',inf);

imshow(im2)
quiver(ind(:,:,2),ind(:,:,1),F(:,:,1),F(:,:,2),'m');
f = getframe;
im = frame2im(f);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,'test','gif','WriteMode','append');
end


