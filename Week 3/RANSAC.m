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
bestT = NaN;
bestM = NaN;
for round=1:N
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
    
    % determine number of inliers
    inliers = 0;
    for i=1:size(p1,2)
        p2estimate = M*p1(:,i) + T;
        if norm(p2estimate-p2(:,i)) < 10
            inliers = inliers+1;
        end
    end
    
    % if number of inliers is better update best transformation estimate
    if inliers > bestInliers
        bestInliers = inliers;
        bestT = T;
        bestM = M;
        display(inliers)
    end
end

end