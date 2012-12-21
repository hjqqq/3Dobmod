function getCloud
close all

clear PV
global mP
% this is loading the patchview matrix and the coordinates
load('Teddy/PV')

%pre-allocation of camera matrix and mean vector
cameras = zeros(size(PV.pvMat,1)*2,3);
mP = zeros(size(PV.pvMat,1)*2,1);

for i=1:14
    display(['iteration: ',num2str(i)])
    % get the first block and translate the Points to the mean
    Points=zeros(6,PV.indRechts(i)-PV.indLinks(i)+1); %32 is 2*cameras
    
    [~,noPoints] = size(Points);
    Points(1:2:end,:)=PV.xLoc(i:i+2,PV.indLinks(i):PV.indRechts(i));
    Points(2:2:end,:)=PV.yLoc(i:i+2,PV.indLinks(i):PV.indRechts(i));
    meanPoints = mean(Points,2);
    Points = Points - repmat(meanPoints,1,noPoints);

    %singular value decomposition for SoM
    [U,W,V] = svd(Points);

    U = U(:,1:3);
    W = W(1:3,1:3);
    V = V(:,1:3);

    M = U*(W^0.5);
    S = (W^0.5)*V';
    
%     %solve for affine ambiguity
    A1 = M(1:2,:);
    L0=pinv(A1'*A1);
    save('M','M')
    

    L = lsqnonlin(@myfun,L0);
    C = chol(L,'lower');
    M = M*C;
    S = pinv(C)*S;
    
    if i == 1
        pointcloud = S;
        cameras(1:6,:) = M;
        mP(1:6) = meanPoints;
    else
        X = pointcloud(:,PV.indLinks(i):PV.indRechts(i-1));
        noMatches = PV.indRechts(i-1)-PV.indLinks(i)+1;
        Y = S(:,1:noMatches);
        [~,T] = myProcrustes3(X',Y');
%         [~,~,T2] = procrustes(X',Y');
%         T.s = T2.b; T.T = T2.c; T.R = T2.T;
        for j = noMatches+1:size(S,2)
            newpoint = T.s*S(:,j)'*T.R + T.T(1,:);
            pointcloud = [pointcloud,newpoint'];
        end
        cameras(i*2+3,:) = M(5,:)*T.R;% + T.T(1,:);
        cameras(i*2+4,:) = M(6,:)*T.R;% + T.T(1,:);
        mP(i*2+3:i*2+4)= meanPoints(5:6);
    end
    
%     CAM = cameras(1:i*2+4,:)
%     CAMS = lsqnonlin(@bundleAdjustmentCam,CAM(:));
%     cameras(1:i*2+4,:) = reshape(CAMS,i*2+4,3);
%     PX0 = [CAM(:);pointcloud(:)];
%     PX = lsqnonlin(@bundleAdjustment,PX0);

end

PC=pointcloud;
plot3(PC(1,:),PC(2,:),PC(3,:),'.')
save('Teddy/PC','PC')
% %Bundle adjustment
% PX0 = [cameras(:);pointcloud(:)];
% PX = lsqnonlin(@bundleAdjustment,PX0);
end