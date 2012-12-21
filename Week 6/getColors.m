% function colors = getColors(X,Y,PV)
% get the colors of the feature points in the PV matrix
% INPUT:
% - X: x coordinates in the original image stored as an cxn matrix where
%      c is the number of camera viewpoints and n is the number of points
% - Y: y coordinates in the original image stored as an cxn matrix where
%      c is the number of camera viewpoints and n is the number of points
% - PV: A cxn matrix containing ones if the point is seen in the camera
%
% OUTPUT:
% - colors: an 3xn matrix containing the rgb colors for every point
function colors = getColors(smallX,smallY,smallPV)
    %Find number of cameras and point
    [noCams,noPoints] = size(smallX);
    colors = nan(3,noPoints);
    
    %Load images
    im = cell(noCams,1);
    for count=1:noCams
        im{count} = imread(['Teddy\obj02_',num2str(count,'%03d'),'.png']);
    end
    
    %For all points find a corresponding color
    for i=1:noPoints
        for j=1:noCams
            if smallPV(j,i)
                X = round(smallX(j,i));
                Y = round(smallY(j,i));
                color = im{j}(Y,X,:);
                colors(:,i) = color;
            end
        end
    end
end