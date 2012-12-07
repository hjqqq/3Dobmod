%function M = estFunMatrix()
%Estimates the Fundamental matrix between two images. Using points found by
%the Harris/Hessian Affine implementation and matching them with SIFT from
%the vl_feat toolbox.
%
%INPUT
%- dataLoc1: location of the pre-computed descriptors file for im1
%- dataLoc2: location of the pre-computed descriptors file for im2
%- im1: The first image
%- im2: The second image
%- N: The number of rounds RANSAC should perform
%
%OUTPUT
%- F: The estimated fundamental transformation matrix
function F = estFunMatrix(dataLoc1,dataLoc2,im1,im2,N)
    close all
    % Load images if not supplied
    if nargin < 1
        im1 = imread('img/obj02_001.png');
        im2 = imread('img/obj02_002.png');
    
        dataLoc1 = 'extract_features/obj02_001.png.haraff.sift';
        dataLoc2 = 'extract_features/obj02_002.png.haraff.sift';
        N = 500 ; %amount of rounds used for RANSAC (prob. more)
    end

    % Load interest points in images
    data1 = importdata(dataLoc1, ' ', 2);
    desc1 = data1.data(:,6:end);
    coor1 = data1.data(:,1:2);
    data2 = importdata(dataLoc2, ' ', 2);
    desc2 = data2.data(:,6:end);
    coor2 = data2.data(:,1:2);
    
    % match interest points
    [ matches , scores ] = vl_ubcmatch (desc1' , desc2')
    coor1 = coor1(matches(1,:),:);
    coor2 = coor2(matches(2,:),:);
    totM = size(coor1,1);
    coor1 = [coor1,ones(totM,1)];
    coor2 = [coor2,ones(totM,1)];
    
    %% RANSAC
    L = 20;
    bestInliers = 0;
    bestInti = []
    th = 1; %the threshold that the distance between points maybe
    for round=1:N
        %select only the top L of the permutated points
        permutation = randperm(size(coor1,1));
        p1p = coor1(permutation(1:L),:);
        p2p = coor2(permutation(1:L),:);
        
        % this function creates the Fundamental Matrix out of 8 point
        F=createF(p1p,p2p);
        inliers = 0;
        inti = [];
        for i=1:totM
            Dis = SampsonDist(coor1(i,:),coor2(i,:),F);
            if Dis < th
                inliers = inliers +  1;
                inti = [inti,i];
            end
        end
        
        %If the current estimate improves the best estimate replace the
        %current estimate
        if inliers > bestInliers
            bestInliers = inliers;
            bestP1 = p1p; bestP2 = p2p;
            bestInti = inti;
            display(['best number of inliers: ',num2str(inliers),', found in round #',num2str(round)])
        end
    end

    %[~,ind] = sort(scores,'descend');

    %% show matches, used for estimating F
    imshow([rgb2gray(im1),rgb2gray(im2)])
    hold on
    plot([coor1(bestInti,1),coor2(bestInti,1)+size(im1,2)]',[coor1(bestInti,2),coor2(bestInti,2)]')

%     %Show epipolar lines
%     colors = get(gca,'ColorOrder');
%     for i = 1:L
%         line = F'*bestP2(i,:)';%shouldn't this be F*coor2(i,:)'
%         a=line(1); b=line(2); c=line(3);
%         x = [1,size(im1,2)];
%         y = -a/b*x-c/b;
%         plot(x,y,'Color',colors(mod(i-1,L-1)+1,:))
%     end
%     
%     for i = 1:L
%         line = F*bestP1(i,:)';%and this be F'*coor1(i,:)' see pdf
%         a=line(1); b=line(2); c=line(3);
%         x = [1,size(im1,2)];
%         y = -a/b*x-c/b;
%         plot(x+size(im1,2),y,'Color',colors(mod(i-1,L-1)+1,:))
%     end

    
end