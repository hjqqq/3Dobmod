function colors = getColors(smallX,smallY,smallPV)
    [noCams,noPoints] = size(smallX);
    colors = nan(3,noPoints);
    
    im = cell(noCams,1);
    for count=1:noCams
        im{count} = imread(['Teddy\obj02_',num2str(count,'%03d'),'.png']);
    end
    
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