% This function creates the matches between all consecutive images, for the
% teddybear
% INPUT:
% type := choose between Harris or Hessian points
% store:= do you want to store the ouput or not? (true/false)
function findMatches(store)

if nargin<1
    store=true;
end

am=16;
dataLoc = cell(1,am);
hesLoc = cell(1,am);

featInd1 = cell(1,am);
featInd2 = cell(1,am);
featCoor1 = cell(1,am);
featCoor2 = cell(1,am);


display('loading bear descriptors')
for i = 1:am
    dataLoc{i} = ['Teddy/HarSift/obj02_',num2str(i,'%03d'),'.png.haraff.sift'];
    hesLoc{i} = ['Teddy/HesSift/obj02_',num2str(i,'%03d'),'.png.hesaff.sift'];
end

N = 500; %run RANSAC N times

display('creating the matches')
for i = 1:am % later tot 16
    [~,featInd1{i},featInd2{i},featCoor1{i},featCoor2{i}]= ...
    estFunMatrix(dataLoc{i},dataLoc{mod(i,16)+1},...
    hesLoc{i},hesLoc{mod(i,16)+1},N);
end

if store
    save('featInd1','featInd1');
    save('featInd2','featInd2');
    save('featCoor1','featCoor1');
    save('featCoor2','featCoor2');
end
    

end %end function