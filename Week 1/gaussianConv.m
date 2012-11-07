function imOut = gaussianConv(image_path,sigma_x,sigma_y)

    im = imread(image_path);
    im = im(:,:,1);
    hcol = gaussian(sigma_y);
    hrow = gaussian(sigma_x);
    imOut = conv2(hcol,hrow,im);
    shifty = (length(hcol)-1)/2;
    shiftx = (length(hrow)-1)/2;
    imOut = imOut(shifty+1:end-shifty, shiftx+1:end-shiftx);
end

%C:\Users\Toby\Documents\VISION\Practical\Week 1\