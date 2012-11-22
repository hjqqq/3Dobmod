function [meanT,meanM]=meanMatrix(MatT,MatM)
meanT=mean(MatT,1);
n=size(MatM,1)/2;
H=0;
S=0;
for i=1:n
    [h,s]=findVals(MatM);
    H=H+h;
    S=S+s;
end
H=H/n;
S=S./n;

meanM=[cos(H) -sin(H);sin(H) cos(H)]*[S(1) 0;0 S(2)];
end

function [hoek,scaling]=findVals(M)
c=M(1,1);
d=M(2,1);
f=M(2,2);
hoek = atan2(d,c); %in radiants
scaling(1) = c/cos(hoek);
scaling(2) = f/cos(hoek);
end