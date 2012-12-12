function getCloud
close all

% this is loading the patchview matrix and the coordinates
load('pvMat')
load('coma')

% making the matrix smaller
ind=find(sum(pvMat,1)>2);
smallPV=pvMat(:,ind);
smallX=coma(:,2*ind-1);
smallY=coma(:,2*ind);


dodo=302;
% get the first block and translate the Points to the mean
Points=zeros(32,dodo);
[~,noPoints] = size(Points);
Points(1:2:end,:)=smallX(:,1:dodo);
Points(2:2:end,:)=smallY(:,1:dodo);
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
plot3(S(1,1:round(dodo/2)),S(2,1:round(dodo/2)),S(3,1:round(dodo/2)),'.r');
hold on
plot3(S(1,round(dodo/2):end),S(2,round(dodo/2):end),S(3,round(dodo/2):end),'.y');

% Shows which points are used for structure of motion
figure(2)
imshow('img/obj02_001.png');
hold on
plot(smallX(1,1:66),smallY(1,1:66),'or');

figure(3)
imshow('img/obj02_002.png');
hold on
plot(smallX(2,1:round(dodo/2)),smallY(2,1:round(dodo/2)),'or');
plot(smallX(2,round(dodo/2):dodo),smallY(2,round(dodo/2):dodo),'oy');


end