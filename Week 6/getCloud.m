function getCloud
close all

% this is loading the patchview matrix and the coordinates
load('pvMat')
load('coma')



% making the matrix smaller
xLoc=coma(:,1:2:end);
yLoc=coma(:,2:2:end);
ind=find(sum(pvMat,1)>2);
smallPV=pvMat(:,ind);
smallX=xLoc(:,ind);
smallY=yLoc(:,ind);
[smallPV,smallX,smallY,indRechts,indLinks]=switCols(smallPV,smallX,smallY);


dodo=302;
% get the first block and translate the Points to the mean
Points=zeros(6,dodo); %32 is 2*cameras
[~,noPoints] = size(Points);
Points(1:2:end,:)=smallX(1:3,1:dodo);
Points(2:2:end,:)=smallY(1:3,1:dodo);
Points = Points - repmat(mean(Points,2),1,noPoints);
size(repmat(mean(Points,2),1,noPoints))


%singular value decomposition for SoM
[U,W,V] = svd(Points);
size(U)
size(W)
size(V)

U = U(:,1:3);
W = W(1:3,1:3);
V = V(:,1:3);

M = U*(W^0.5);
S = (W^0.5)*V';


%solve for affine ambiguity
% A1 = M(1:2,:);
% L0=pinv(A1'*A1);
% save('M','M')
% 
% L = lsqnonlin(@myfun,L0);
% 
% C = chol(L,'lower');
% M = M*C;
% S = pinv(C)*S;

% show in 3d coordinates
plot3(S(1,1:dodo),S(2,1:dodo),S(3,1:dodo),'.m');



end