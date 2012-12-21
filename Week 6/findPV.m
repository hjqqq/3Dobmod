% This function creates the PointViewMatrix
% There are several steps involved:
% STEP1: Fill the matrix
% STEP2: Get double points out of the matrix
% STEP3: Make the matrix perfect step form
function findPV(featInd1,featInd2,featCoor1,featCoor2)

% loading the matches
if nargin<1
    load('featInd1');
    load('featInd2');
    load('featCoor1');
    load('featCoor2');
end

%% STEP1
% Fill the first two rows for the first two images
am=16; % amount of images
pViewMat = zeros(am,size(featInd1{1},2));
pViewMat(1:2,:) = 1;
coorMat = zeros(am,2*size(featInd1{1},2));
coorMat(1,1:2:end) = featCoor1{1}(:,1);
coorMat(1,2:2:end) = featCoor1{1}(:,2);
coorMat(2,1:2:end) = featCoor2{1}(:,1);
coorMat(2,2:2:end) = featCoor2{1}(:,2);

%Fill the rest of the matrix
newInd = 1:size(featInd1{1},2);
%zeros(size(featInd1{2},2),1);
for m = 2:am-1
    oldInd = newInd;
    newInd = zeros(size(featInd1{m},2),1);
    for i = 1:size(featInd1{m},2)
        ind = find(featInd2{m-1}==featInd1{m}(i),1,'first');
        if isempty(ind)
            newColumn = zeros(am,1);
            newColumn(m:m+1) = 1;
            newCoor = zeros(am,2);
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

%% STEP2
xLoc=coorMat(:,1:2:end);
yLoc=coorMat(:,2:2:end);
ind=find(sum(pViewMat,1)>2);

pvMat = pViewMat(:,ind);
xLoc = xLoc(:,ind);
yLoc = yLoc(:,ind);

display(size(xLoc,2))
ind=[];
for i=1:size(xLoc,2)
    a=xLoc(:,i);
    for j=i+1:size(xLoc,2)-1
        b=xLoc(:,j);
        c=a-b;
        if sum(c)==0
            ind=[ind j];
            break
        end
    end
end  
pvMat(:,ind)=[];
xLoc(:,ind)=[];
yLoc(:,ind)=[];

%get the colors for the coordinates
colors = getColors(xLoc,yLoc,pvMat);
save('colors','colors');   

%% STEP3
[pvMat,xLoc,yLoc,indRechts,indLinks]=switCols(pvMat,xLoc,yLoc);

%% Store it and plot it
PV.pvMat=pvMat;
PV.xLoc=xLoc;
PV.yLoc=yLoc;
PV.indLinks=indLinks;
PV.indRechts=indRechts;
PV.colors=colors;

display('save the struct');
save('teddy/PV','PV');

%show it some matches
im1=imread('Teddy/obj02_001.png');
im2=imread('Teddy/obj02_002.png');
imshow([im2,im1])
hold on
plot([PV.xLoc(1,1:7)',PV.xLoc(1,1:7)'+size(im1,2)]',[PV.yLoc(1,1:7)',PV.yLoc(1,1:7)']','-')
end

