function getCloud
close all

% this is loading the patchview matrix and the coordinates
load('Teddy/pvMat')
load('Teddy/coma')

global smallPV smallX smallY mP

% making the matrix smaller
xLoc=CoMa(:,1:2:end);
yLoc=CoMa(:,2:2:end);
ind=find(sum(PVmat,1)>2);

[smallPV,smallX,smallY,indRechts,indLinks]=switCols(PVmat(:,ind)...
                                    ,xLoc(:,ind),yLoc(:,ind));
% colors = getColors(smallX,smallY,smallPV);
% save('colors','colors');

cameras = zeros(size(smallPV,1)*2,3);
mP = zeros(size(smallPV,1)*2,1);

for i=1:14
    % get the first block and translate the Points to the mean
    Points=zeros(6,indRechts(i)-indLinks(i)+1); %32 is 2*cameras
    mat=smallPV(:,indLinks(i):indRechts(i));
    maX=smallX(:,indLinks(i):indRechts(i));
    maY=smallY(:,indLinks(i):indRechts(i));
    
    [~,noPoints] = size(Points);
    Points(1:2:end,:)=smallX(i:i+2,indLinks(i):indRechts(i));
    Points(2:2:end,:)=smallY(i:i+2,indLinks(i):indRechts(i));
    meanPoints = mean(Points,2);
    Points = Points - repmat(meanPoints,1,noPoints);

    %singular value decomposition for SoM
    [U,W,V] = svd(Points);

    U = U(:,1:3);
    W = W(1:3,1:3);
    V = V(:,1:3);

    M = U*(W^0.5);
    S = (W^0.5)*V';
  
%     img= imread(['Teddy\obj02_',num2str(i,'%03d'),'.png']);
%     figure(2)
%     imshow(img)
%     hold on
%     plot(maX(1,1:3),maY(1,1:3),'or')
    
    %solve for affine ambiguity
    A1 = M(1:2,:);
    L0=pinv(A1'*A1);
    save('M','M')
    
    L = lsqnonlin(@myfun,L0);
    C = chol(L,'lower');
    M = M*C;
    S = pinv(C)*S;
  
%     lsqnonlin(@bundleAdjustment,PX)
%     PX = M*S+repmat(mP,1,noPoints);
%     
    
    if i == 1
        pointcloud = S;
        cameras(1:6,:) = M;
        mP(1:6) = meanPoints;
    else
        X = pointcloud(:,indLinks(i):indRechts(i-1));
        noMatches = indRechts(i-1)-indLinks(i)+1;
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
    
%     CAM = cameras(1:i*2+4,:);
%     PX0 = [CAM(:);pointcloud(:)];
%     PX = lsqnonlin(@bundleAdjustment,PX0);
    
% figure(3)
% plot3(S(1,1:b),S(2,1:b),S(3,1:b),'xm');
% hold on
% plot3(S(1,1:3),S(2,1:3),S(3,1:3),'.b');
    
%     if i==2
%         for j=1:3
%         img= imread(['Teddy\obj02_',num2str(j+1,'%03d'),'.png']);
%         figure(j)
%         imshow(img)
%         hold on
%         plot(smallX(j+1:j+3,indLinks(i):indRechts(i)),smallY(j+1:j+3,...
%             indLinks(i):indRechts(i)),'ro')
%         hold off
%         end
%     end
    %plot3(S(1,1:dodo),S(2,1:dodo),S(3,1:dodo),'.m');

end

PC=pointcloud;
save('PC','PC')
% %Bundle adjustment
% PX0 = [cameras(:);pointcloud(:)];
% PX = lsqnonlin(@bundleAdjustment,PX0);

end