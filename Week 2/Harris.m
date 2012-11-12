function HarrisKR(im,n)
if nargin < 1
     n = 3;
end

xl=size(im,2);
yl=size(im,1);

k = 0.04;

w=fspecial('gaussian',3,1);

sigma = 1;
G = gaussian(sigma);
Gd = gaussianDer(G,sigma);
L = (length(Gd)-1)/2;

Ix = conv2(Gd,conv2(G',im));
Ix = Ix(1+L:end-L,1+L:end-L);
Iy = conv2(Gd',conv2(G,im));
Iy = Iy(1+L:end-L,1+L:end-L);

M=zeros(2);
R=zeros(size(im));

for i=2:xl-1
    for j=2:yl-1
        M(1,1)=sum(sum(w.*Ix(j-1:j+1,i-1:i+1).*Ix(j-1:j+1,i-1:i+1)));
        M(1,2)=sum(sum(w.*Ix(j-1:j+1,i-1:i+1).*Iy(j-1:j+1,i-1:i+1)));
        M(2,1)=M(1,2);
        M(2,2)=sum(sum(w.*Iy(j-1:j+1,i-1:i+1).*Iy(j-1:j+1,i-1:i+1)));
        
        R(j,i)=det(M)-k*trace(M)^2;
        
        
    end
end

figure(2)
imshow(R,[])
end