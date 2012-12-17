function getCloud
close all

% this is loading the patchview matrix and the coordinates
load('Teddy/pvMat')
load('Teddy/coma')



% making the matrix smaller
xLoc=CoMa(:,1:2:end);
yLoc=CoMa(:,2:2:end);
ind=find(sum(PVmat,1)>2);

[smallPV,smallX,smallY,indRechts,indLinks]=switCols(PVmat(:,ind)...
                                    ,xLoc(:,ind),yLoc(:,ind));

                                
for i=1:13
    dodo=indRechts-indLinks+1;
    % get the first block and translate the Points to the mean
    Points=zeros(6,indRechts(i)-indLinks(i)+1); %32 is 2*cameras
    mat=smallPV(:,indLinks(i):indRechts(i)+1);
    maX=smallX(:,indLinks(i):indRechts(i)+1);
    maY=smallY(:,indLinks(i):indRechts(i)+1);
    
    [~,noPoints] = size(Points);
    Points(1:2:end,:)=smallX(i:i+2,indLinks(i):indRechts(i));
    Points(2:2:end,:)=smallY(i:i+2,indLinks(i):indRechts(i));
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
    [~,b]=size(S)
%     figure(1)
%     plot3(S(1,1:b),S(2,1:b),S(3,1:b),'xm');
%     hold on
%     plot3(S(1,1:3),S(2,1:3),S(3,1:3),'.b');

    
%     img= imread(['Teddy\obj02_',num2str(i,'%03d'),'.png']);
%     figure(2)
%     imshow(img)
%     hold on
%     plot(maX(1,1:3),maY(1,1:3),'or')
    
    if i == 1
        pointcloud = S;
    else
        X = pointcloud(:,indLinks(i):indRechts(i-1));
        noMatches = indRechts(i-1)-indLinks(i)+1;
        Y = S(:,1:noMatches);
        [~,~,T] = procrustes(X',Y');
        for j = noMatches+1:size(S,2)
            newpoint = T.b*S(:,j)'*T.T + T.c(1,:);
            pointcloud = [pointcloud,newpoint'];
        end
    end
%     %solve for affine ambiguity
    A1 = M(1:2,:);
    L0=pinv(A1'*A1);
    save('M','M')
    
    L = lsqnonlin(@myfun,L0);

    C = chol(L,'lower');
    M = M*C;
    S = pinv(C)*S;

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
% PC = pointcloud(:,1:800);
% [X,Y] = meshgrid(PC(1,:),PC(2,:));
% Z = griddata(PC(1,:),PC(2,:),PC(3,:), X, Y);
% figure;
% surf(X,Y,Z);
% surf(PC(1,:),PC(2,:),PC(3,:))


end