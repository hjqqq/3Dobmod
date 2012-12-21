%From a stored pointcloud and colors show the model of the teddybear
function triangulate()

load('Teddy/PC')
load('Teddy/PV')
colors = PV.colors;
k = 7;

Max = max(PC,[],2);
Min = min(PC,[],2);
Dif = (Max-Min)/k;

for ii = 1:2
    if ii == 1
        D1 = Min(1):Dif(1):Max(1);
        D2 = Min(2):Dif(2):Max(2);
        D3 = Min(3):Dif(3):Max(3);
    else
        D1 = Min(1)+0.5*Dif(1):Dif(1):Max(1)+0.5*Dif(1);
        D2 = Min(2)+0.5*Dif(1):Dif(2):Max(2)+0.5*Dif(1);
        D3 = Min(3)+0.5*Dif(1):Dif(3):Max(3)+0.5*Dif(1);        
    end
    for i = 2:k+1
        for j = 2:k+1
            for l = 2:k+1
                ind = PC(1,:)>D1(i-1) & PC(1,:)<D1(i) &...
                      PC(2,:)>D2(j-1) & PC(2,:)<D2(j) &...
                      PC(3,:)>D3(l-1) & PC(3,:)<D3(l);
                PC1 = PC(:,ind);
                color = zeros(size(PC1,2),1,3);
                c = colors(:,ind)./255;
                color(:,:,1) = c(1,:);
                color(:,:,2) = c(2,:);
                color(:,:,3) = c(3,:);
                if size(PC1,2)>4
                    CH = convhulln(PC1');
                    trisurf(CH,PC1(1,:),PC1(2,:),PC1(3,:),'FaceColor',...
                        'interp','Cdata',color,'CDataMapping','scaled')
                    hold on
                end
            end
        end
    end

end