%function demo3()
%A demo of the structure from motion
function demo3()
%% For groundtruth
%load points
Points = importdata('model house\measurement_matrix.txt');
size(Points)

[~,noPoints] = size(Points);
Points = Points - repmat(mean(Points,2),1,noPoints);
size(repmat(mean(Points,2),1,noPoints))

%singular value decomposition
[U,W,V] = svd(Points);
size(U)
size(W)
size(V)

U = U(:,1:3);
W = W(1:3,1:3);
V = V(:,1:3);

M = U*(W^0.5);
S = (W^0.5)*V';


%solve for affine ambiguity
A1 = M(1:2,:);
L0=pinv(A1'*A1);
save('M','M')

L = lsqnonlin(@myfun,L0);

C = chol(L,'lower');
M = M*C;
S = pinv(C)*S;

plot3(S(1,:),S(2,:),S(3,:),'.m');

%% For our points

load('Xpoints')
load('Ypoints')

Points(1:2:end,:)=pointsx;
Points(2:2:end,:)=pointsy;



[~,noPoints] = size(Points);
Points = Points - repmat(mean(Points,2),1,noPoints);
size(repmat(mean(Points,2),1,noPoints))

%singular value decomposition
[U,W,V] = svd(Points);
size(U)
size(W)
size(V)

U = U(:,1:3);
W = W(1:3,1:3);
V = V(:,1:3);

M = U*(W^0.5);
S = (W^0.5)*V';


%solve for affine ambiguity
A1 = M(1:2,:);
L0=pinv(A1'*A1);
save('M','M')

L = lsqnonlin(@myfun,L0);

C = chol(L,'lower');
M = M*C;
S = pinv(C)*S;

hold on
plot3(S(1,:),S(2,:),S(3,:),'.y');

%show the result
% hold on
% plot3(S(1,:),S(2,:),S(3,:),'.y');