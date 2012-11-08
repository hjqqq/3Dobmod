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
    end
    F = F(1+L:end-L,1+L:end-L);
end