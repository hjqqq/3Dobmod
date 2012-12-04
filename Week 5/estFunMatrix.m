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
    end
    
    % match interest points
    [ matches , scores ] = vl_ubcmatch (desc1' , desc2');
    coor1 = coor1(matches(1,:),:);
    coor2 = coor2(matches(2,:),:);
    %select only the top L
    L = 8;
    [~,ind] = sort(scores,'descend');
    coor1 = [coor1(ind([1,3,5:10]),:),ones(L,1)];
    coor2 = [coor2(ind([1,3,5:10]),:),ones(L,1)];
    %show matches
    imshow([rgb2gray(im1),rgb2gray(im2)])
    hold on
    plot([coor1(:,1),coor2(:,1)+size(im1,2)]',[coor1(:,2),coor2(:,2)]')
    
    %find the normalization
    [coor1n,T1] = normalizePoints(coor1);
    [coor2n,T2] = normalizePoints(coor2);
      
    x1 = coor1n(:,1);
    x2 = coor2n(:,1);
    y1 = coor1n(:,2);
    y2 = coor2n(:,2);    
    
    % Construct matrix A
    A = [x1.*x2 x1.*y2 x1 y1.*x2 y1.*y2 y1 x2 y2 ones(length(x1),1)];
  
    % Find SVD of A
    [U,D,V] = svd(A);
    
    % find the fundamental matrix
    F = reshape(V(:,end),3,3);
    
    %make the fundamental matrix non-singular (i.e. det(F) = 0)
    [Uf,Df,Vf] = svd(F);
    Df(3,3)=0;
    F = Uf*Df*Vf';
    
    %transform back
    F = T2'*F*T1;
    
    %Show epipolar lines
    colors = get(gca,'ColorOrder');
    for i = 1:L
        line = F'*coor2(i,:)';%shouldn't this be F*coor2(i,:)'
        a=line(1); b=line(2); c=line(3);
        x = [1,size(im1,2)];
        y = -a/b*x-c/b;
        plot(x,y,'Color',colors(mod(i-1,L-1)+1,:))
    end
    
    for i = 1:L
        line = F*coor1(i,:)';%and this be F'*coor1(i,:)' see pdf
        a=line(1); b=line(2); c=line(3);
        x = [1,size(im1,2)];
        y = -a/b*x-c/b;
        plot(x+size(im1,2),y,'Color',colors(mod(i-1,L-1)+1,:))
    end
    
end