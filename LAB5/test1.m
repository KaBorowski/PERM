clear all;
image=imread('rozmyte.jpg');
load('allObjectsMask.mat');
noBackgroundRGBImage = bsxfun(@times, image, cast(allObjectsMask,class(image)));
[B,L] = bwboundaries(allObjectsMask, 'noholes');
imshow(image); hold on;
colors=['b' 'g' 'r' 'c' 'm' 'y'];
for k=1:length(B),
  boundary = B{k};
  cidx = mod(k,length(colors))+1;
  plot(boundary(:,2), boundary(:,1),...
       colors(cidx),'LineWidth',2);

  %randomize text position for better visibility
  rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
  col = boundary(rndRow,2); row = boundary(rndRow,1);
  h = text(col+1, row-1, num2str(L(row,col)));
  set(h,'Color',colors(cidx),'FontSize',14,'FontWeight','bold');
end
s = struct;
ObjectColor = cell(1,numel(B));
for i=1:33
    Obj = (L==i);
    PixelList = regionprops(Obj,'PixelList');
    PixelList = PixelList(1).PixelList;
    Z = PixelList(:,1);
    C = PixelList(:,2);
    meanR = mean(mean(image(C,Z,1)));
    meanG = mean(mean(image(C,Z,2)));
    meanB = mean(mean(image(C,Z,3)));
    if meanR > 200 && meanG < 80 && meanB < 80
        ObjectColor{i} = 'czerwony'; 
    elseif meanR > 181 && meanG > 146 && meanB > 128
        ObjectColor{i} = 'bialy';
    elseif meanR > 143 && meanG > 113 && meanB < 139
        ObjectColor{i} = 'zolty';
    elseif meanR > 30 && meanG > 113 && meanB < 150
        ObjectColor{i} = 'zielony';
    elseif meanR < 130 && meanG < 111 && meanB > 100
        ObjectColor{i} = 'niebieski'; 
    elseif meanR < 149 && meanG < 138 && meanB < 122
        ObjectColor{i} = 'czarny';  
    else
        ObjectColor{i} = 'nieznany';
    end
    s(i).i = i;
    s(i).R = meanR;
    s(i).G = meanG;
    s(i).B = meanB;
    s(i).color = ObjectColor{i};
    %disp([num2str(i),' | ',num2str(meanR),' | ', num2str(meanG),' | ', num2str(meanB),' | ', ObjectColor{i}])
end
disp('------------------------------------------------------------')
for k = [16,20,30]
    disp([num2str(s(k).i),' | ',num2str(s(k).R),' | ',num2str(s(k).G),' | ',num2str(s(k).B),' | ',s(k).color]);
end
