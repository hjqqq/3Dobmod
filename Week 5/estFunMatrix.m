%function M = estFunMatrix()
%Estimates the Fundamental matrix between two images. Using points found by
%the Harris/Hessian Affine implementation and matching them with SIFT from
%the vl_feat toolbox.
%
%INPUT
%- im1: first image
%- im2: second image
%
%OUTPUT
%- M: The estimated fundamental transformation matrix
function M = estFunMatrix(im1,im2)
    % Load images if not supplied
    if nargin < 1
        im1 = imread('...');
        im2 = imread('...');
    end
    
    % Load interest points in images and match them
    
    [ matches , scores ] = vl_ubcmatch (desc1 , desc2);
    
    % Construct matrix A
    x1 = x1(matches(1,:))';
    x2 = x2(matches(1,:))';
    y1 = y1(matches(1,:))';
    y2 = y2(matches(1,:))';
    A = [x1.*x2 x1.*y2 x1 y1.*x2 y1.*y2 y1 x2 y2 1];
    
    % Find SVD of A
    [U,D,V] = svd(A);
end