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
    coor1 = coor1(ind([1,3,5:10]),:)
    coor2 = coor2(ind([1,3,5:10]),:);
    
    co1 = [coor1 ones(size(coor1,1),1)];
    co2 = [coor2 ones(size(coor2,1),1)];
    
    %show matches
    imshow([rgb2gray(im1),rgb2gray(im2)])
    hold on
    plot([coor1(:,1),coor2(:,1)+size(im1,2)]',[coor1(:,2),coor2(:,2)]')
    
    %find the normalization
    m1 = mean(coor1);
    m2 = mean(coor2);
    d1 = sqrt(2) / mean(sqrt( (coor1(:,1)-m1(1)).^2 + (coor1(:,2)-m1(2)).^2 ));
    d2 = sqrt(2) / mean(sqrt( (coor2(:,1)-m2(1)).^2 + (coor2(:,2)-m2(2)).^2 ));
    T1 = [d1 0  -m1(1)*d1;
          0  d1 -m1(2)*d1;
          0  0   1];
    T2 = [d2 0  -m2(1)*d2;
          0  d2 -m2(2)*d2;
          0  0   1];
    
    coor1 = [coor1,ones(L,1)];
    coor2 = [coor2,ones(L,1)];
    for i=1:L
        coor1(i,:) = T1*coor1(i,:)';
        coor2(i,:) = T2*coor2(i,:)';
    end
      
    x1 = coor1(:,1);
    x2 = coor2(:,1);
    y1 = coor1(:,2);
    y2 = coor2(:,2);
    
    
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
    F = T2'*F*T1
    
    for i=1:size(co1,1)
        D = SampsonDist(co1(i,:),co2(i,:),F)
    end
    
    
    %Test if the x2*F*x1'=0
    x1 = co1(:,1);
    x2 = co2(:,1);
    y1 = co1(:,2);
    y2 = co2(:,2);
    A = [x1.*x2 x1.*y2 x1 y1.*x2 y1.*y2 y1 x2 y2 ones(length(x1),1)];
    Fs= F(:)
    A*Fs
    
end