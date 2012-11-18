% function loc = filterLoc(loc)
% Finds locations (x,y and sigma) that are to similar and removes the
% worst.
%
% INPUT
% -loc:  a 4xn set of n locations with [x,y,sigma,response] in the columns
% -dist: The euclidian distance threshold = dist * sigma. (typical 2)
%
% OUTPUT
% -loc: a 3xm set of m filtered locations with [x,y,sigma] in the columns
function loc = filterLoc(loc,dist)

index = ones(size(loc,1),1);
for i = 1:size(loc,1)
    for j = i+1:size(loc,1)
        ratio = loc(i,3)/loc(j,3);
        if  (ratio<2 && ratio>0.5) && ...
                sum(abs(loc(i,1:2) - loc(j,1:2))) <= dist*max(loc(i,3),loc(j,3))
            if loc(i,4) > loc(j,4)
                index(j) = 0;
            else
                index(i) = 0;
            end
        end
    end
end

loc = loc(index==1,1:3);