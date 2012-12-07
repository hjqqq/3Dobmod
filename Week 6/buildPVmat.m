function buildPVmat()


% load the descriptors of the images
dataLoc = cell(1,16);
featInd1 = cell(1,16);
featInd2 = cell(1,16);
for i = 1:16
    dataLoc{i} = ['HarSift/obj02_',num2str(i,'%03d'),'.png.haraff.sift'];
end
N = 500; %run RANSAC N times

% calculate the matches between the two images
for i = 1:3 % later tot 16
    [~,featInd1{i},featInd2{i}]=estFunMatrix(dataLoc{i},dataLoc{mod(i,16)+1},N);
end

% the Point-view matrix, every row represents an image and every column a
% point. On the rows the images are from 1 to 16
% also filling it for the first time
%PVmat=zeros(16
pViewMat = zeros(16,size(featInd1{1},2));
pViewMat(1:2,:) = 1;

%contains the descpriptor of the points (same indexes as the PVmat columns)
%ik weet nog niet of dat nodig is, misschien handig om te checken of
%matches tussen im1 en im3 overeen komen.
pointMat=[]


% for every point matching pairs
for pair=2:16
end
    