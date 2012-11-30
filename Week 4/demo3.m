function demo3()


%load points
Points = importdata('model house\measurement_matrix.txt');

[~,noPoints] = size(Points);
Points = Points - repmat(mean(Points,2),1,noPoints);

%singular value decomposition
[U,W,V] = svd(Points);

U = U(:,1:3);
W = W(1:3,1:3);
V = V(:,1:3);

M = U*(W^0.5);
S = (W^0.5)*V';

plot3(S(1,:),S(2,:),S(3,:),'.')

Ai = M(1:2,:);
L=pinv(Ai'*Ai);

%C=chol(L,'lower');
%M = M*C;
%S = pinv(C)*S;

% Ai = M(1:2,1:2);
% L = pinv(Ai'*Ai)
% Ai * L * Ai'
% C = chol(L,'lower');
% for num = 1:101;
%     imageLoc = ['model house\frame' num2str(num, '%08d') '.jpg'];
%     im = double(imread(imageLoc))/255;
%     imshow(im);
%     hold on 
%     plot(Points(num*2-1,:),Points(num*2,:),'b.');
%     pause(0.1)
% end
