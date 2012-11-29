function LKtracker(p,im,sigma)

G = fspecial('gaussian',[1 2*ceil(3*sigma)+1],sigma);
Gd = gaussianDer(G,sigma)


It=zeros(size(im,1)*size(im,2),size(im,3));
Ix=zeros(size(im));
Iy=zeros(size(im));
for i=1:1%size(im,3)
    isi=im(:,:,i);
    size(isi)
    isi=isi(:);
    Ini(:,i)=isi;
    size(isi)
    Ix(:,:,i)=conv2(im(:,:,i),Gd,'same');
    Iy(:,:,i)=conv2(im(:,:,i),Gd','same');
end

size(Ini)
Ini=conv2(Ini,Gd,'same');
size(Ini)