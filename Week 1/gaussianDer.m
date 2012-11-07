function Gd = gaussianDer(G,sigma)
    L = ceil(3*sigma);
    Gd = -(-L:L)/(sigma^2) .* G;
end