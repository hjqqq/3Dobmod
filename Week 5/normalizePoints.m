%function [coordinates,T] = normalizePoints(coordinates)
%transforms the points to have a mean on the origin and a variance of
%sqrt(2) from the origin.
%INPUT
%- coordinates: The input coordinates in homogeneous form
%
%OUTPUT
%- coordinates: The transformed coordinates in homogeneous form
%- T: The transformation matrix used for transforming to normalized points 
function [coordinates,T] = normalizePoints(coordinates)

%find mean and variance
m= mean(coordinates(:,1:2));
d = mean(sqrt( (coordinates(:,1)-m(1)).^2 + (coordinates(:,2)-m(2)).^2 ));

%construct matrix for normalization
d = sqrt(2)/d;
T = [d 0  -m(1)*d;
      0  d -m(2)*d;
      0  0   1];

%Apply normalization on homogeneous coordinates
for i=1:size(coordinates,1)
    coordinates(i,:) = T*coordinates(i,:)';
end

end