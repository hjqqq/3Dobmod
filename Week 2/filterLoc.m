% function loc = filterLoc(loc)
% Finds locations (x,y and sigma) that are to similar and removes the
% worst.
%
% INPUT
% -loc: a 4xn set of n locations with [x,y,sigma,response] in the columns
%
% OUTPUT
% -loc: a 3xm set of m filtered locations with [x,y,sigma] in the columns
function loc = filterLoc(loc)

index = ones(size(loc,1),1);
for i = 1:size(loc,1)
    for j = i+1:size(loc,1)
        if abs(loc(i,3)-loc(j,3)) < 3 && sum(abs(loc(i,1:2) - loc(j,1:2))) < 4
            if loc(i,4) > loc(j,4)
                index(j) = 0;
            else
                index(i) = 0;
            end
        end
    end
end

loc = loc(index==1,1:3);