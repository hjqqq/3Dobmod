% function imOut = gaussianConv(image_path,sigma_x,sigma_y)
% Convolution of the image with a gaussian with a certain sigma in the x
% and y direction.
% INPUT
% - image_path: location of the image
% - sigma_x: sigma of the gaussian in the x direction (amount of smoothing)
% - sigma_y: sigma of the gaussian in the y direction (amount of smoothing)
%
% OUTPUT
% -imOut: smoothed picture (same size as the input image)
function imOut = gaussianConv(image_path,sigma_x,sigma_y)
    % read in the image and extract gray scale
    im = imread(image_path);
    if size(im,3) > 1
        im = rgb2gray(im);
    end
    
    % convolution with the gaussian seperately in x abd y direction
    hcol = gaussian(sigma_y);
    hrow = gaussian(sigma_x);
    imOut = conv2(hcol,hrow,im);
    shifty = (length(hcol)-1)/2;
    shiftx = (length(hrow)-1)/2;
    imOut = imOut(shifty+1:end-shifty, shiftx+1:end-shiftx);
end

%C:\Users\Toby\Documents\VISION\Practical\Week 1\