% function Gd = gaussianDer(G,sigma)
% computes the derivative of a gaussian
% INPUT
% G: gaussian
% sigma: sigma of the gaussian G
%
% OUTPUT
% Gd: gaussian derivative
function Gd = gaussianDer(G,sigma)
    L = ceil(3*sigma);
    Gd = -(-L:L)/(sigma^2) .* G;
end