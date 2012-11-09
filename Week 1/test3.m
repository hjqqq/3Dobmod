%test all gaussians
function test3
    sigmas = [30,40,50,30,40,50,30,40,50];
    impulsIm = zeros(301,301);
    impulsIm(151,151) = 1;
    for i = 1:9
        figure(i)
        sigma = sigmas(i);
        if i < 4
            g = gaussian(sigma);
            Z = conv2(g,g,impulsIm);
            L = (length(g)-1)/2;
            Z = Z(1+L:end-L, 1+L:end-L);
            imshow(Z,[])
        elseif i < 7
            F = ImageDerivatives(impulsIm,sigma,'x');
            imshow(F,[])
        else
            F = ImageDerivatives(impulsIm,sigma,'xx');
            imshow(F,[]) 
        end
    end
end