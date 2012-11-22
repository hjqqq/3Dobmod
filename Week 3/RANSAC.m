% function T = RANSAC(N,p1,p2)
%
% INPUT
% - N:  Number of iterations
% - p1: point locations in first image (2xn matrix)
% - p2: point locations in second image (2xn matrix)
%
% OUTPUT
% - T: Translation
% - M: transformation matrix
function [bestT, bestM] = RANSAC(N,p1,p2)

bestInliers = 0;
bestLS = 100000;
bestT = NaN;
bestM = NaN;
bestIntin = [];
size(p1,2)
for round=1:N

    [T,M]=maakMat(p1,p2);
    % determine number of inliers
    inliers = 0;
    LS=0;
    intin=[];
    for i=1:size(p1,2)
        p2estimate = M*p1(:,i) + T;
        nor=norm(p2estimate-p2(:,i));
        if nor < 10
            inliers = inliers+1;
            LS=LS+nor;
            intin=[intin;i];
        end
    end
    
    % if number of inliers is better update best transformation estimate
    if inliers > bestInliers && LS < bestLS
        bestInliers = inliers;
        bestLS = LS;
        bestIntin = intin;
        bestT = T
        bestM = M
        round
        display(inliers)
    end
end

MatT=[];
MatM=[];
bestIntin
size(p1)

for j=1:2*length(bestIntin)
    [T,M]=maakMat(p1(:,bestIntin),p2(:,bestIntin));
    MatT=[MatT;T'];
    MatM=[MatM;M];   
end

[bestT,bestM]=meanMatrix(MatT,MatM);

end

function [T,M]=maakMat(p1,p2)
    permutation = randperm(size(p1,2));
    p1p = p1(:,permutation(1:3));
    p2p = p2(:,permutation(1:3));
    
    %construct A
    A = zeros(6,6);
    A(1:2:5,5) = 1;
    A(2:2:6,6) = 1;
    A(1:2:5,1:2) = p1p';
    A(2:2:6,3:4) = p1p';
    
    % calculate transformation
    x = pinv(A)*p2p(:);
    M = [x(1),x(2);x(3),x(4)];
    T = [x(5);x(6)];
end




