function [f1,f2]=runningSIFT(im1,im2)
close all
if nargin <1
% loading the image
im1 = imread('landscape-a.jpg');
im2 = imread('landscape-b.jpg');
im1 = single(im1(:,:,1));
im2 = single(im2(:,:,1));
end
%% HARRIS
% now we get the keypoints
%  loc1=Harris(im1./255,0.000001,0.003)';
%  display('first image processed with Harris')
%  loc2=Harris(im2./255,0.000001,0.003)';
%  display('second image processed with Harris')
%  f1=[loc1;zeros(1,size(loc1,2))];
%  f2=[loc2;zeros(1,size(loc2,2))];
 
 %% DoG
 loc1=DoG(im1./255)';
 display('first image processed with DoG')
 loc2=DoG(im2./255)';
 display('second image processed with DoG')
 f1=[loc1;zeros(1,size(loc1,2))];
 f2=[loc2;zeros(1,size(loc2,2))];
 
 
 
% hiermee kun je de keypoints plotten:
% figure(2)
% imshow(im1,[])
% hold on
% h1 = vl_plotframe(f1);
% set(h1,'color','y','linewidth',2) ;
% size(f1)
% return
%% Keypoints and orientation
% f is a matrix, the first two columns is the center of the keypoints, the 3rd
% colum is the size and the 4th the orientation (we dont use orientation
% for now)
% d is the descriptor of the keypoints 

%now we find the descriptors for every keypoint
[f1,d1] = vl_sift(im1,'frames',f1,'orientations');
[f2,d2] = vl_sift(im2,'frames',f2,'orientations');


%% Matching two images
[matches, scores] = vl_ubcmatch(d1, d2) ;
% this is plotting the matching points
imshow([im1 im2],[]);
hold on;
f1match=f1(:,matches(1,:));
h1 = vl_plotframe(f1match);
set(h1,'color','y','linewidth',2) ;

f2shift=f2(:,matches(2,:));
f2shift(1,:)=f2shift(1,:)+size(im1,2);
h2 = vl_plotframe(f2shift);
set(h2,'color','y','linewidth',2) ;

%plot the lines between the matches
for i=1:size(matches,2)
    plot([f1match(1,i)' f2shift(1,i)'],[f1match(2,i)' f2shift(2,i)'],'-m')
end

%% Somecode
% might be handy
% [m1,o1]=gradmag(im1,1);
% [m2,o2]=gradmag(im2,1);
% o1=o1+2*pi*(o1<0);
% o2=o2+2*pi*(o2<0);
% grad1(1,:,:)=m1;
% grad1(2,:,:)=o1;
% grad2(1,:,:)=m2;
% grad2(2,:,:)=o2;
%the keypoints should be gained with harris, just for thesting now !!!!!!!!!!!!!
%[f1,~] = vl_sift(im1); %here Harris
%[f2,~] = vl_sift(im2); %here Harris

