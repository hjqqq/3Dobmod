%function Rfeat = Harris(im,t)
%
function loc = Harris(im,t)
k = 0.04;
mFactor = 1.4;
loc = [];

sigmas = 1*mFactor.^(0:9);
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
    step = (1/9)*sigmaI*(mFactor-1/mFactor);
    sigmaS = sigmaI/mFactor:step:sigmaI*mFactor;
    Laplace = cell(1,10);
    responses = zeros(sum(sum(Rfeat)),10);
    columns = size(Rfeat,2);
    rows = size(Rfeat,1);
    for ind = 1:10
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
                        responses(num,ind) = 0;
                    else
                        res = sum(sum((im(i-L:i+L,j-L:j+L).*Laplace)));
                        responses(num,ind) = res;
                    end
                end
            end
        end
    end
    
    [~,peaks] = max(abs(responses),[],2);
    num = 0;
    for j = 1:columns
        for i = 1:rows
            if Rfeat(i,j) == 1
                num = num+1;
                if peaks(num) ~= 1 && peaks(num) ~= 10
                    loc = [loc; j,i,sigmaS(peaks(num))];
                end
            end
        end
    end
end


end