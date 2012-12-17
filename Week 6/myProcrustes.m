function [d,Z,transformation] = myProcrustes(X,Y)

k = size(X,1);
d = sqrt(sum(sum((X-Y).^2)));
display(['original distance is: ' ,num2str(d)])

%transform to the same mean

mX = mean(X);
mY = mean(Y);
t = mX-mY;
tY = Y + repmat(t,k,1);

d = sqrt(sum(sum((X-tY).^2)));
display(['distance after translation is: ' ,num2str(d)])

transformation.c = t;

%transform to the same scaling

sX = sqrt(sum(sum((X-repmat(mX,k,1)).^2))/k);
sY = sqrt(sum(sum((tY-repmat(mX,k,1)).^2))/k);

s = 1;%sX/sY;

stY = (tY-repmat(mX,k,1))*s+repmat(mX,k,1);

d = sqrt(sum(sum((X-stY).^2)));
display(['distance after scaling is: ' ,num2str(d)])

transformation.b = s;
%transform to the same orientation

[U,D,V] = svd((stY-repmat(mX,k,1))'*(X-repmat(mX,k,1)));
% D = eye(3);
% D(3,3) = sign(det(U*V'));
R = U*V';

Z = stY;
for i = 1:k
    Z(i,:) = R'*(stY(i,:)-mX)'+mX';
end

transformation.T = R;

d = sqrt(sum(sum((X-Z).^2)));
display(['distance after rotating is: ' ,num2str(d)])