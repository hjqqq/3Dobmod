function [magnitude,orientation] = gradmag(img,sigma)
    Gd = gaussianDer(gaussian(sigma),sigma);
    L = (length(Gd)-1)/2;
    Xmag = conv2(Gd,img);
    Ymag = conv2(Gd',img);
    Xmag = Xmag(:,1+L:end-L);
    Ymag = Ymag(1+L:end-L,:);
    magnitude = sqrt(Xmag.^2 + Ymag.^2);
    orientation = atan2(Ymag,Xmag);
    stepsize = 10;
    quiver(1:stepsize:size(img,1),1:stepsize:size(img,2), ...
           Xmag(1:stepsize:end,1:stepsize:end), ...
           Ymag(1:stepsize:end,1:stepsize:end),10);
end