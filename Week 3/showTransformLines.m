im1 = single(imread('boat/img1.pgm'));
im2 = single(imread('boat/img2.pgm'));
[f1,d1] = vl_sift(im1);
[f2,d2] = vl_sift(im2);
[matches, scores] = vl_ubcmatch(d1, d2) ;
f1match=f1(:,matches(1,:));
f2match=f2(:,matches(2,:));
p1 = f1match(1:2,:);
p2 = f2match(1:2,:);
[T, M] = RANSAC(1000,p1,p2);
newim = [im1,im2];
p1t = zeros(size(p1));
for i = 1:size(p1,2)
    p1t(:,i) = M*p1(:,i) + T;
end
%plot(p1(1,:),p1(2,:),'r.')
%plot(p1t(1,:) + size(im1,2),p1t(2,:),'r.')
imshow(newim,[]);
hold on;
plot([p1(1,:);p1t(1,:) + size(im1,2)],[p1(2,:);p1t(2,:)],'r')