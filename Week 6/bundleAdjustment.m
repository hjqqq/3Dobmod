function E = bundleAdjustment(P)
global mP
load('Teddy/PV')

[noCams, noPoints] = size(PV.pvMat);

P = reshape(PX(1:3*noCams*2),noCams*2,3);
X = reshape(PX(3*noCams*2+1:end),3,noPoints);

projection=P*X+repmat(mP,1,noPoints);

E = 0;
for i = 1:noCams
    for j = 1:noPoints %should be all points
        if PV.pvMat(i,j) == 1
            E = E + (projection(i*2-1,j)-PV.xLoc(i,j)).^2 +...
                    (projection(i*2  ,j)-PV.yLoc(i,j)).^2;
        end
    end
end

%% OLD FUNCTION FOR BUNDLE ADJUSTMENT WHEN STITCHING
% function E = bundleAdjustment(PX)
% global smallPV smallX smallY mP
% 
% noCams = sum(mP>0)/2;
% noPoints = (length(PX) - 3*noCams*2)/3;
% 
% P = reshape(PX(1:3*noCams*2),noCams*2,3);
% 
% X = reshape(PX(3*noCams*2+1:end),3,noPoints);
% 
% projection = P*X+repmat(mP(1:noCams*2),1,noPoints);
% 
% D = ((projection(1:2:end,:)-smallX(1:noCams,1:noPoints)) ...
%         .*smallPV(1:noCams,1:noPoints)).^2 +...
%     ((projection(2:2:end,:)-smallY(1:noCams,1:noPoints)) ...
%         .*smallPV(1:noCams,1:noPoints)).^2;
% 
% E = sum(sum(D));