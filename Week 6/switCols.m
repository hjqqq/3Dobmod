% This functions changes the patch view matrix so that blocks are
% contained. This is necessary to create overlap of points in different
% pointclouds.
function [mat,locX,locY,indRechts,indLinks]=switCols(mat,locX,locY)

size(mat)
size(locX)

prevInd=1;
indRechts=zeros(14,1);
indRechts(14)=size(mat,2);
indLinks=zeros(14,1);
indLinks(1)=1;
for i=1:size(mat,1)-3
    IndFstZero=find(mat(i,prevInd:end)==0);
    tempMat=mat(:,prevInd+1:(prevInd-1+IndFstZero(1)-1));
    tempX=locX(:,prevInd+1:(prevInd-1+IndFstZero(1)-1));
    tempY=locY(:,prevInd+1:(prevInd-1+IndFstZero(1)-1));
    
    ind3= find(sum(tempMat,1)==3);
    ind4= find(sum(tempMat,1)==4);
    indI= find(sum(tempMat,1)>4);
    delMat=tempMat(:,indI);
    delMat(i+4:end,:) = zeros(size(delMat(i+4:end,:)));
    a=[tempMat(:,ind3) tempMat(:,ind4) delMat];
    x=[tempX(:,ind3) tempX(:,ind4) tempX(:,indI)];
    y=[tempY(:,ind3) tempY(:,ind4) tempY(:,indI)];
    
    
    mat(:,prevInd+1:(prevInd-1+IndFstZero(1)-1))=a;
    locX(:,prevInd+1:(prevInd-1+IndFstZero(1)-1))=x;
    locY(:,prevInd+1:(prevInd-1+IndFstZero(1)-1))=y;
    prevInd=prevInd+IndFstZero(1)-2;
    indRechts(i)=prevInd;
end

for i=1:13
    a=find(mat(i+3,:)==1);
    indLinks(i+1)=a(1);
end
