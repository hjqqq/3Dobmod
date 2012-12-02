%function demo3(tracked)
%A demo of the structure from motion that shows the 3d structure of the
%points in the space. Either from the original points or the tracked points
%INPUT
%- tracked: boolean that states whether to use the tracked points
%           if set to true the tracked points will be used otherwise
%           the ground truth is used. (default = false)
%
%OUTPUT
% an image showing the points in their estimated 3-dimensional position
%- M: The transformation matrix size of 2nx3. Where n is the number of 
%     cameras i.e. images.
%- S: The estimated 3-dimensional locations of the points (3x#points)
function [M,S] = demo3(tracked)

if nargin < 1
    tracked = false;
end

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



%if specified: replace the Point data with the tracked point data
if tracked
    %load all images
    for num = 1:101;
        imageLoc = ['model house\frame' num2str(num, '%08d') '.jpg'];
        im = double(imread(imageLoc))/255;
        if num == 1
            Imf=zeros(size(im,1),size(im,2),101);
        end
        Imf(:,:,num)=im;
    end

    %track points and replace 'Points'
    [pointsx,pointsy]=LKtracker(Points(1:2,:),Imf,1);
    
    Points = [pointsx;pointsy];
    Points = Points([1:2:size(Points,1),2:2:size(Points,1)],:);
end

%Shift the mean of the points to zero
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

%solve for affine ambiguity using non-linear least squares

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
