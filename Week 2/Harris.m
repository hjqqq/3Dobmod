%function Rfeat = Harris(im,t)
%
%INPUT
%-im: input image, should be double and normalized between 0 and 1
%-t:  threshold for R (cornerness) to discard flat surfaces
%     (typically set to 0.0000001 or 10^-7)

function loc = Harris(im,t)
k = 0.04;
mFactor = 1.4;
loc = [];

sigmas = 2*mFactor.^(0:12);
%loc = cell(1,length(sigmas));
for n = 1:length(sigmas)
    %Calculate sigma for integration and derivative
    sigmaI = sigmas(n);
    sigmaD = 0.7 * sigmaI;
    
    %calculate gaussian (derivatives)
    G   = gaussian(sigmaI);
    GD  = gaussian(sigmaD);
    GDd = gaussianDer(GD,sigmaD);
    
    % compute derivative of image
    Ix = conv2(GD,GDd,im,'same');
    Iy = conv2(GDd,GD,im,'same');

    %compute M matrix
    Ixx = Ix.*Ix;
    Iyy = Iy.*Iy;
    Ixy = Ix.*Iy;
    
    M1 = sigmaD^2*conv2(G,G,Ixx,'same');
    M2 = sigmaD^2*conv2(G,G,Ixy,'same');
    M4 = sigmaD^2*conv2(G,G,Iyy,'same');

    % compute determinant of M matrix for every pixel location
    Det = M1.*M4 - M2.^2;
    Tr  = M1 + M4;
    
    % Compute cornerness R
    R = Det - k*Tr.^2;
    
    % Find local maxima above threshold
    Rmax = imregionalmax(R);
    Rthr = R>t;
    Rfeat = Rmax & Rthr;
    
end
loc = filterLoc(loc,2);

end