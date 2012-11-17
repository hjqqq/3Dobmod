%function Rfeat = Harris(im,t,t2)
%
%INPUT
%-im: input image, should be double and normalized between 0 and 1
%-t:  threshold for R (cornerness) to discard flat surfaces
%     (typically set to 0.0000001 or 10^-7)
%-t2: second check of the found corner (typically set to 0.003)
%     tests wether there is a peak at the tested scale (laplacian)

function loc = Harris(im,t,t2)
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
    
    % for every point detect max scale or reject
    nScales = 8;
    step = (1/(nScales-1))*sigmaI*(mFactor-1/mFactor);
    sigmaS = sigmaI/mFactor:step:sigmaI*mFactor;
    responses = zeros(sum(sum(Rfeat)),nScales);
    columns = size(Rfeat,2);
    rows = size(Rfeat,1);
    for ind = 1:nScales
        GS = gaussian(sigmaS(ind));
        GSdd = gaussianDer2(GS,sigmaS(ind));
        Laplace = sigmaS(ind)^2 * (GS'*GSdd+GSdd'*GS);
        L = (length(GSdd)-1)/2;
        num = 0;
        for j = 1:columns
            for i = 1:rows
                if Rfeat(i,j) == 1
                    num = num+1;
                    if i-L <= 0 || i+L > rows || j-L <= 0 || j+L > columns
                        responses(num,ind) = NaN;
                    else
                        res = sum(sum((im(i-L:i+L,j-L:j+L).*Laplace)));
                        responses(num,ind) = res;
                    end
                end
            end
        end
    end
    
    [peaks,peaklocs] = max(responses,[],2);
    [valleys,valleylocs] = min(responses,[],2);
    maxima = peaks > responses(:,1) & peaks > responses(:,nScales);
    minima = valleys < responses(:,1) & valleys < responses(:,nScales);
    %extrema = xor(maxima,minima) & ~any(isnan(responses),2);
    extremum = abs(peaks) > abs(valleys);
    extremumVal = max(abs(peaks),abs(valleys));
    extremaLocs = peaklocs.*extremum+valleylocs.*~extremum;
    p = 1/8;
    curvature = conv2(responses,[-p,-p,p,p,p,p,-p,-p],'valid');
    extrema = abs(curvature)> t2;% & xor(maxima,minima);
    num = 0;
    for j = 1:columns
        for i = 1:rows
            if Rfeat(i,j) == 1
                num = num+1;
                if extrema(num)
                    loc = [loc; j,i,sigmaS(extremaLocs(num)),extremumVal(num)];
                end
            end
        end
    end
    
end
loc = filterLoc(loc);

end