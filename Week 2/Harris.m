function loc = Harris(im,n,t)
if nargin < 2
     n = 1;
end

loc = [];
k = 0.04;

sigma = 2;
w=fspecial('gaussian',ceil(6*sigma),sigma);

Ix = conv2(im,[-1,0,1],'same');
Iy = conv2(im,[-1,0,1]','same');

Ixx = Ix.*Ix;
Iyy = Iy.*Iy;
Ixy = Ix.*Iy;

M1 = conv2(Ixx,w,'same');
M2 = conv2(Ixy,w,'same');
M4 = conv2(Iyy,w,'same');

Det = M1.*M4 - M2.^2;
Tr  = M1 + M4;
R = Det - k*Tr.^2;

for i = 1+n:size(im,1)-n
    for j= 1+n:size(im,2)-n
        middle = R(i,j);
        if middle > t
            Patch = R(i-n:i+n,j-n:j+n);
            if sum(middle<Patch) < 1
                loc = [loc;j,i];
            end
        end
    end
end



end