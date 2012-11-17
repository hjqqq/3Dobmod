function plotFeatures(im,loc)

imshow(im,[]);
hold on;
for ind = 1:size(loc,1)
    circle(loc(ind,1),loc(ind,2),2*loc(ind,3));
end