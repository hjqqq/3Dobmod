function loc = DoG(im)
loc = [];

%prior smoothing sigma
sigmaP = 1.6;
levels = 3;
%scaling factor
k = 2^(1/levels);
noCascades = 4;

GP  =  cell(levels+3,1);
for i = 1:levels+3
    GP{i} = gaussian(sigmaP*(k^(i-2)));
end

im2 = imresize(im,2);

%for all cascades
for cascade = 1:noCascades
    %gaussians for smoothing (i.e. scaling)
    % and gaussian smoothed images

    %smoothing of images
    imG = cell(levels+3,1);
    for i = 1:levels+3
        if cascade == 0
            imG{i} = conv2(GP{i},GP{i},im2,'same');
        else
            imG{i} = conv2(GP{i},GP{i},im,'same');
        end
    end

    %difference of gaussians
    imDoG = zeros(size(im,1),size(im,2),levels+2);
    for i = 1:levels+2
        imDoG(:,:,i) = imG{i+1} - imG{i};
    end

    %check nearby extrema in subsequent layers
    imExtrema = imregionalmax(imDoG);
    imExtrema = imExtrema(:,:,2:end-1);

    for i = 1:levels
        % current sigma
        scale = 2^(cascade-1);
        sigmaC = scale*sigmaP*(k^(i-1));
        [row,col] = find(imExtrema(:,:,i)==1);
        loc = [loc; round(scale*col),round(scale*row),...
                    repmat(sigmaC,length(row),1)];
    end
    
    im = imresize(im,0.5);
end

end