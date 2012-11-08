% function [magnitude,orientation] = gradmag(img,sigma)
% INPUT
% -img: the input image, has to be grayscale
% -sigma: sigma used by the gaussian and gaussian derivative
%
% OUTPUT
% - magnitude of the gradient
% - orientation of the gradient
function [magnitude,orientation] = gradmag(img,sigma)
    % calculate gaussians
    G = gaussian(sigma);
    Gd = gaussianDer(G,sigma);
    L = (length(Gd)-1)/2;
    
    %convolve in x and y direction
    Xmag = conv2(G',conv2(Gd,img));
    Ymag = conv2(G,conv2(Gd',img));
    Xmag = Xmag(1+L:end-L,1+L:end-L);
    Ymag = Ymag(1+L:end-L,1+L:end-L);
    
    %compute magnitude and orientation
    magnitude = sqrt(Xmag.^2 + Ymag.^2);
    orientation = atan2(Ymag,Xmag);
    
    %QUIVER VISUALIZATION
    %stepsize = 10;
    %figure(3)
    %quiver(5+1:stepsize:size(img,2),5+1:stepsize:size(img,1), ...
    %       Xmag(5+1:stepsize:end,5+1:stepsize:end), ...
    %       Ymag(5+1:stepsize:end,5+1:stepsize:end),2);
end