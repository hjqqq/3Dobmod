function [d,Z,transform] = myProcrustes2(X,Y)

    k = size(X,1);
    mX = mean(X);
    mY = mean(Y);
    oX = X;
    oY = Y;
    transform.t = mX - mY;
    
    X = X - repmat(mX,k,1);
    Y = Y - repmat(mY,k,1);
    
    sX = sqrt(sum(sum(X.^2))/k);
    sY = sqrt(sum(sum(Y.^2))/k);
    
    transform.s = sX/sY;
    
    X = X/sX;
    Y = Y/sY;
    
    [U,~,V] = svd(Y'*X);
    transform.R = U*V';
    
    transform.t = transform.s*transform.t*transform.R;
    
    for i = 1:k
        oY(i,:) = transform.s*oY(i,:)*transform.R+transform.t;
    end
    Z = oY;
    d = sqrt(sum(sum((oX-Z).^2)));
    
end