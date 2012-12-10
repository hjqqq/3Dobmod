function pViewMat=buildPVmat()


% load the descriptors of the images
dataLoc = cell(1,16);
featInd1 = cell(1,16);
featInd2 = cell(1,16);
featCoor1 = cell(1,16);
featCoor2 = cell(1,16);
for i = 1:16
    dataLoc{i} = ['HarSift/obj02_',num2str(i,'%03d'),'.png.haraff.sift'];
end
N = 200; %run RANSAC N times

% calculate the matches between the two images
for i = 1:16 % later tot 16
    [~,featInd1{i},featInd2{i},featCoor1{i},featCoor2{i}] = ...
        estFunMatrix(dataLoc{i},dataLoc{mod(i,16)+1},N);
end

% the Point-view matrix, every row represents an image and every column a
% point. On the rows the images are from 1 to 16
% also filling it for the first time
pViewMat = zeros(16,size(featInd1{1},2));
pViewMat(1:2,:) = 1;

newInd = 1:size(featInd1{1},2);
%zeros(size(featInd1{2},2),1);
for m = 2:15
    oldInd = newInd;
    newInd = zeros(size(featInd1{m},2),1);
    for i = 1:size(featInd1{m},2)
        ind = find(featInd2{m-1}==featInd1{m}(i),1,'first');
        if isempty(ind)
            newColumn = zeros(16,1);
            newColumn(m:m+1) = 1;
            pViewMat = [pViewMat,newColumn];
            newInd(i) = size(pViewMat,2);
        else
            pViewMat(m+1,oldInd(ind)) = 1;
            newInd(i) = oldInd(ind);
        end
    end
end

%contains the descpriptor of the points (same indexes as the PVmat columns)
%ik weet nog niet of dat nodig is, misschien handig om te checken of
%matches tussen im1 en im3 overeen komen.
pointMat=[]


% for every point matching pairs
for pair=2:16
end
    