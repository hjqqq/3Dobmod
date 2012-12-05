%function M = estFunMatrix()
%Estimates the Fundamental matrix between two images. Using points found by
%the Harris/Hessian Affine implementation and matching them with SIFT from
%the vl_feat toolbox.
%
%INPUT
% in progress
%
%OUTPUT
%- M: The estimated fundamental transformation matrix
function F = estFunMatrix()
    % Load images if not supplied
    if nargin < 1
        im1 = imread('img/obj02_001.png');
        im2 = imread('img/obj02_002.png');
    
        % Load interest points in images
        data1 = importdata('extract_features/obj02_001.png.haraff.sift', ' ', 2);
        desc1 = data1.data(:,6:end);
        coor1 = data1.data(:,1:2);
        data2 = importdata('extract_features/obj02_002.png.haraff.sift', ' ', 2);
        desc2 = data2.data(:,6:end);
        coor2 = data2.data(:,1:2);
        N = 100 ; %amount of rounds used for RANSAC (prob. more)
    end
    
    % match interest points
    [ matches , scores ] = vl_ubcmatch (desc1' , desc2');
    coor1 = coor1(matches(1,:),:);
    coor2 = coor2(matches(2,:),:);
    totM = size(coor1)
    coor1 = [coor1,ones(totM,1)];
    coor2 = [coor2,ones(totM,1)];
    
    %% RANSAC
    L = 8;
    bestInliers = 0;
    inti = [];
    th = 2; %the threshold that the distance between points maybe
    for round=1:N
        %select only the top L of the permutated points
        permutation = randperm(size(coor1,1));
        p1p = coor1(permutation(1:L),:);
        p2p = coor2(permutation(1:L),:);
        
        % this function creates the Fundamental Matrix out of 8 point
        F=createF(p1p,p2p);
        
        inliers = 0;
        for i=1:totM
            Dis = SampsonDist(coor1(i,:),coor2(i,:),F);
            if Dis < th
                inliers = inliers +  1;
                inti = [inti i];
            end
        end
        
        if inliers > bestInliers
            bestInliers = inliers;
            display(['best number of inliers: ',num2str(inliers),', found in round #',num2str(round)])
        end
    end

    %[~,ind] = sort(scores,'descend');

    %% show matches
    imshow([rgb2gray(im1),rgb2gray(im2)])
    hold on
    plot([coor1(inti,1),coor2(inti,1)+size(im1,2)]',[coor1(inti,2),coor2(inti,2)]')
    
    
    
    
%     %Test if the x2*F*x1'=0
%     x1 = co1(:,1);
%     x2 = co2(:,1);
%     y1 = co1(:,2);
%     y2 = co2(:,2);
%     A = [x1.*x2 x1.*y2 x1 y1.*x2 y1.*y2 y1 x2 y2 ones(length(x1),1)];
%     Fs= F(:);
%     A*Fs;
    
    %Show epipolar lines
    line = F*coor2(1,:)';
    a=line(1); b=line(2); c=line(3);
    x = [1,size(im1,2)];
    y = -a/b*x-c/b;
    plot(x,y)
    
end