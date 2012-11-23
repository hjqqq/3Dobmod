% function T = RANSAC(N,p1,p2,mode)
%
% INPUT
% - N:  Number of iterations
% - p1: point locations in first image (2xn matrix)
% - p2: point locations in second image (2xn matrix)
% - mode: can be either 'affine' or 'projective'
%
% OUTPUT
% - TM: transformation matrix
function bestTM = RANSAC(N,p1,p2,mode)

if nargin<4
    mode = 'affine';
end

%number of matches needed
if strcmp(mode,'affine')
    npix = 3;
elseif strcmp(mode,'projective')
    npix = 4;
else
    display('unknown mode in RANSAC using projective')
    npix = 4;
end
bestInliers = 0;
bestLS = Inf;
bestTM = NaN;

for round=1:N
    %determine transformation
    TM=maakMat(p1,p2,npix,mode);
    
    % determine number of inliers
    inliers = 0;
    LS=0;
    intin=[];
    for i=1:size(p1,2)
        p2estimate = TM*[p1(:,i);1];
        nor=norm(p2estimate(1:2,:)./p2estimate(3,:)-p2(:,i));
        if nor < 10 %within a euclidean distance of 10 pixels
            inliers = inliers+1;
            LS=LS+nor;
            intin=[intin;i];
        end
    end
    
    % if number of inliers is better update best transformation estimate
    if inliers > bestInliers ||(inliers == bestInliers && LS < bestLS)
        bestInliers = inliers;
        bestLS = LS;
        bestTM = TM;
        display(['best number of inliers: ',num2str(inliers)])
    end
end

% MatT=[];
% MatM=[];
% bestIntin
% size(p1)
% 
% for j=1:2*length(bestIntin)
%     [T,M]=maakMat(p1(:,bestIntin),p2(:,bestIntin));
%     MatT=[MatT;T'];
%     MatM=[MatM;M];   
% end
% 
% [bestT,bestM]=meanMatrix(MatT,MatM);

end

function TM = maakMat(p1,p2,npix,mode)
    % randomly select set of points
    permutation = randperm(size(p1,2));
    p1p = p1(:,permutation(1:npix));
    p2p = p2(:,permutation(1:npix));
    
    if strcmp(mode,'affine')
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
        TM = [M,T;0,0,1];
    else %'projective'
        %construct linear system
        A = zeros(8,8);
        A(1:3:8,3)=1;
        A(2:3:8,6)=1;
        A(1:2:8,1:2)=p1p';
        A(2:2:8,4:5)=p1p';
        A(1:2,7:8)=-p2p(:,1)*p1p(:,1)';
        A(3:4,7:8)=-p2p(:,2)*p1p(:,2)';
        A(5:6,7:8)=-p2p(:,3)*p1p(:,3)';
        A(7:8,7:8)=-p2p(:,4)*p1p(:,4)';
        %solve system
        x = [pinv(A)*p2p(:);1];
        x = reshape(x,3,3);
        TM=x';
    end
end




