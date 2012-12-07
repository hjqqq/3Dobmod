function buildPVmat()


% load the first two images and their descriptors
im1 = imread('../Week 5/img/obj02_001.png');
im2 = imread('../Week 5/img/obj02_002.png');

dataLoc1 = 'HarSift/obj02_001.png.haraff.sift';
dataLoc2 = 'HarSift/obj02_002.png.haraff.sift';
N = 500 %run RANSAC N times

% calculate the matches between the two images
[~,inti]=estFunMatrix(dataLoc1,dataLoc2,im1,im2,N);
size(inti)

% the Point-view matrix, every row represents an image and every column a
% point. On the rows the images are from 1 to 16
% also filling it for the first time
PVmat=[]

%contains the descpriptor of the points (same indexes as the PVmat columns)
%ik weet nog niet of dat nodig is, misschien handig om te checken of
%matches tussen im1 en im3 overeen komen.
pointMat=[]


% for every point matching pairs
for pair=2:16
end
    