function Gd = gaussianDer2(G,sigma)
    L = ceil(3*sigma);
    Gd = (-sigma^2 + (-L:L).^2)/(sigma^4) .* G;
end