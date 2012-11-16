% function F= ImageDerivatives (img ,sigma , type )
% compute a derivative of 'type' with smoothing 'sigma' and convole img
% with this derivative.
% INPUT
% - img: input image (grayscale)
% - sigma: smoothing of the gaussian, sigma
% - type: The type of derivative can be 'x', 'xx', 'y', 'yy', 'xxy', 'xyy'
%
% OUTPUT
% - F image convolved with the specified derivative
function F= ImageDerivatives (img ,sigma , type )
    G = gaussian(sigma);
    Gd = gaussianDer(G,sigma);
    Gdd = gaussianDer2(G,sigma);
    L = (length(G)-1)/2;
    if strcmp(type,'x')
        F = conv2(G',conv2(Gd,img));
    elseif strcmp(type, 'y')
        F = conv2(G,conv2(Gd',img));
    elseif strcmp(type,'xx')
        F = conv2(G',conv2(Gdd,img));
    elseif strcmp(type,'yy')
        F = conv2(G,conv2(Gdd',img));
    elseif strcmp(type,'xy') || strcmp(type,'yx')
        F = conv2(Gd',conv2(Gd,img));
    elseif strcmp(type,'xxy') || strcmp(type,'yx')
        F = conv2(Gd',conv2(Gdd,img));
    elseif strcmp(type,'xyy') || strcmp(type,'yyx')
        F = conv2(Gd,conv2(Gdd',img));
    elseif strcmp(type,'xxyy') || strcmp(type,'yyxx')
        F = conv2(Gdd,conv2(Gdd',img));
    end
    F = F(1+L:end-L,1+L:end-L);
end