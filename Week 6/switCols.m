function [mat,locX,locY,indRechts,indLinks]=switCols(mat,locX,locY)

prevInd=1;
indRechts=zeros(14,1);
indRechts(14)=size(mat,2);
indLinks=zeros(14,1);
indLinks=1;
for i=1:size(mat,1)-3
    IndFstZero=find(mat(i,prevInd:end)==0);
    tempMat=mat(:,prevInd+1:(prevInd-1+IndFstZero(1)-1));
    ind3= find(sum(tempMat,1)==3);
    indI= find(sum(tempMat,1)>3);
    a=tempMat(:,ind3);
    a=[a tempMat(:,indI)];
    imshow(a)
    mat(:,prevInd+1:(prevInd-1+IndFstZero(1)-1))=a;
    prevInd=prevInd+IndFstZero(1)-2;
    indRechts(i)=prevInd;
end

for i=1:13
    a=find(mat(i+3,:)==1);
    indLinks(i)=a(1);
end
