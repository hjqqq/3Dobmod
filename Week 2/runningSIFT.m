function [matches,scores]=runningSIFT(im1,im2)
if nargin <1
close all
% loading the image
im1 = loadImage('landscape-a.jpg');
im2 = loadImage('landscape-b.jpg');
im1 = single(im1);
im2 = single(im2);
end
%% Keypoints and orientation
% f is a matrix, the first two columns is the center of the keypoints, the 3rd
% colum is the size and the 4th the orientation
% d is the descriptor of the keypoints 
[f,d] = vl_sift(im1);
% this is plotting some keypoints
% imshow(im1,[]);
% hold on;
% perm = randperm(size(f,2)) ;
% sel = perm(1:50) ;
% h1 = vl_plotframe(f(:,sel)) ;
% %h2 = vl_plotframe(f(:,sel)) ;
% %h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
% set(h1,'color','k','linewidth',3) ;
% %set(h2,'color','y','linewidth',2) ;
% %set(h3,'color','g') ;
% hold off;

%% Matching two images
[f2,d2]=vl_sift(im2); %same but then for second image
[matches, scores] = vl_ubcmatch(d, d2) ;
% this is plotting the matching points
imshow(im1,[]);
hold on;
h1 = vl_plotframe(f(:,matches(1,:)));
set(h1,'color','y','linewidth',2) ;
hold off;
figure(2);
hold on;
imshow(im2,[]);
h2 = vl_plotframe(f2(:,matches(2,:)));
set(h2,'color','y','linewidth',2) ;
hold off;


