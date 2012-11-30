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


LKtracker(Points(1:2,:),Imf,3);