function [Z,transform]=myProcrustes3(X,Y)
    Xt=X;
    Yt=Y;
    
    k = size(X,1);
    mX = mean(X);
    mY = mean(Y);
    transform.T=mY-mX;

    
    Xi = X - repmat(mX,k,1);
    Yi = Y - repmat(mY,k,1);
    
    sX = sqrt(sum(sum(Xi.^2))/k);
    sY = sqrt(sum(sum(Yi.^2))/k);
    
    transform.s = sX/sY;
    s=transform.s;
    
    X=Xi/sX;
    Y=Yi/sY;
    
    [U,~,V] = svd(Y'*X);
    transform.R = U*V';
    R=transform.R;
    transform.T=-repmat((s*mY*R-mX),k,1);

    Z=s*Yt*R-repmat((s*mY*R-mX),k,1)
    
    figure(2)
     plot(Xt(:,1),Xt(:,2),'r-', Yt(:,1),Yt(:,2),'b-', Z(:,1),Z(:,2),'b:');
end
     %axis([-1 3 -1.5 2.5])
    
    %plot(Xt(:,1), Xt(:,2),'r-', Y(:,1), Y(:,2),'b-',...
%Z(:,1),Z(:,2),'b:');
    %plot(X(:,1),X(:,2),'rx', Y(:,1),Y(:,2),'b.', Z(:,1),Z(:,2),'bx');