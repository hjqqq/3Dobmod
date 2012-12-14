function getCloud
close all

% this is loading the patchview matrix and the coordinates
load('Teddy/pvMat')
load('Teddy/coma')



% making the matrix smaller
xLoc=CoMa(:,1:2:end);
yLoc=CoMa(:,2:2:end);
ind=find(sum(PVmat,1)>2);
smallPV=PVmat(:,ind);
smallX=xLoc(:,ind);
smallY=yLoc(:,ind);
[smallPV,smallX,smallY,indRechts,indLinks]=switCols(smallPV,smallX,smallY);


dodo=302;
for i=1:13
    % get the first block and translate the Points to the mean
    Points=zeros(6,indRechts-indLinks+1); %32 is 2*cameras
    [~,noPoints] = size(Points);
    Points(1:2:end,:)=smallX(i:i+2,indLinks:indRechts);
    Points(2:2:end,:)=smallY(i:i+2,indLinks:indRechts);
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
    A1 = M(1:2,:);
    L0=pinv(A1'*A1);
    save('M','M')
    
    L = lsqnonlin(@myfun,L0);

    C = chol(L,'lower');
    M = M*C;
    S = pinv(C)*S;
end



% show in 3d coordinates
plot3(S(1,1:dodo),S(2,1:dodo),S(3,1:dodo),'.m');



end