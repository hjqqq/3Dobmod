%% The function calculates the Sampson Distance
% INPUT:
%p1:= a point in image 1
%p2:= same point in image 2
%F:= Fundamental matrix

function Dis = SampsonDist(p1,p2,F)

a=p2*F*p1';
b=F*p1';
c=F'*p2';

Dis = a^2/(b(1)^2+b(2)^2+c(1)^2+c(2)^2);

end