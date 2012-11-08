% function Gd = gaussianDer2(G,sigma)
% computes the derivative of a gaussian
% INPUT
% G: gaussian
% sigma: sigma of the gaussian G
%
% OUTPUT
% Gd: gaussian second derivative
function Gd = gaussianDer2(G,sigma)
    L = ceil(3*sigma);
    Gd = (-sigma^2 + (-L:L).^2)/(sigma^4) .* G;
end