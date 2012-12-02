% this function gives a demo of the Lucas Kanade tracker. The sum of the
% euclidean distance between the tracked points and the groundtruth is
% plotted for every frame.

function demo2()
%load points
Points = importdata('model house\measurement_matrix.txt');


for num = 1:101;
    imageLoc = ['model house\frame' num2str(num, '%08d') '.jpg'];
    im = double(imread(imageLoc))/255;
    if num == 1
        Imf=zeros(size(im,1),size(im,2),101);
    end
    Imf(:,:,num)=im;
%     imshow(im);
%     hold on 
%     plot(Points(num*2-1,:),Points(num*2,:),'b.');
%     pause(0.1)
end

%track points
[pointsx,pointsy]=LKtracker(Points,Imf,1);

save('Xpoints','pointsx')
save('Ypoints','pointsy')


%original point locations
pointsxo = Points(1:2:end,:);
pointsyo = Points(2:2:end,:);


%% euclidean distance per frame
figure(2)
eudis=sqrt((pointsx-pointsxo).^2+(pointsy-pointsyo).^2);
LS=sum(eudis,2);
plot(LS)
xlabel('image #')
ylabel('sum of LS-error')
end