function [pViewMat,coorMat]=buildPVmat(Load)

if nargin<1
    Load = 1;
end

% load the descriptors of the images
dataLoc = cell(1,16);
hesLoc = cell(1,16);
featInd1 = cell(1,16);
featInd2 = cell(1,16);
featCoor1 = cell(1,16);
featCoor2 = cell(1,16);
for i = 1:16
    dataLoc{i} = ['HarSift/obj02_',num2str(i,'%03d'),'.png.haraff.sift'];
    hesLoc{i} = ['HesSift/obj02_',num2str(i,'%03d'),'.png.hesaff.sift'];
end
N = 200; %run RANSAC N times

% calculate the matches between the two images
if Load
    load('featInd1','featInd1');
    load('featInd2','featInd2');
    load('featCoor1','featCoor1');
    load('featCoor2','featCoor2');
else
    %if you get an error here please load the feat toolbox
    for i = 1:16 % later tot 16
        [~,featInd1{i},featInd2{i},featCoor1{i},featCoor2{i}]= ...
            estFunMatrix(dataLoc{i},dataLoc{mod(i,16)+1},hesLoc{i},hesLoc{mod(i,16)+1},N);
    end
end

% the Point-view matrix, every row represents an image and every column a
% point. On the rows the images are from 1 to 16
% also filling it for the first time
pViewMat = zeros(16,size(featInd1{1},2));
pViewMat(1:2,:) = 1;
coorMat = zeros(16,2*size(featInd1{1},2));
coorMat(1,1:2:end) = featCoor1{1}(:,1);
coorMat(1,2:2:end) = featCoor1{1}(:,2);
coorMat(2,1:2:end) = featCoor2{1}(:,1);
coorMat(2,2:2:end) = featCoor2{1}(:,2);

% pViewMat = sparse(pViewMat);
% coorMat = sparse(coorMat);

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
            newCoor = zeros(16,2);
            newCoor(m:m+1,:) = [featCoor1{m}(i,1:2);featCoor2{m}(i,1:2)];
            
            pViewMat = [pViewMat,newColumn];
            coorMat = [coorMat,newCoor];
            newInd(i) = size(pViewMat,2);
        else
            pViewMat(m+1,oldInd(ind)) = 1;
            try 
                coorMat(m+1,oldInd(ind)*2-1:oldInd(ind)*2) = featCoor2{m}(i,1:2);
            catch exception
                throw(exception);
            end
            newInd(i) = oldInd(ind);
        end
    end
end

%Load images
im = cell(1,16);
for i = 1:16
im{i} = imread(['img\obj02_',num2str(i,'%03d'),'.png']);
end

%show some of the images with matched point connected in images
n=13;
ind=find(sum(pViewMat,1)>3);
for i = 1:sum(pViewMat(:,ind(n)))
    figure(i)
    imshow(im{i})
    hold on;
    plot(coorMat(i,ind(n)*2-1),coorMat(i,ind(n)*2),'ro');
end

end