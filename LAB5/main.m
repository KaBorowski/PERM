% read in image
clear ;
image=imread('rozmyte.jpg');
load('allObjectsMask.mat');
imtool(image);
%% show binary contour mask of all
% contour of all
contourOfAll = bwperim(allObjectsMask, 8);
figure;
imshow(contourOfAll);
%% recognize colors
noBackgroundRGBImage = bsxfun(@times, image, cast(allObjectsMask,class(image)));
[B,L] = bwboundaries(allObjectsMask, 'noholes');
Obj = (L==33);
PixelList = regionprops(Obj,'PixelList');
PixelList = PixelList(1).PixelList;

ObjectColor = cell(1,numel(B));
ObjectColor{1} = '';
for i=2:33
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
    elseif 30 && meanG > 113 && meanB < 150
        ObjectColor{i} = 'zielony';
    elseif meanR < 130 && meanG < 111 && meanB > 100
        ObjectColor{i} = 'niebieski'; 
    elseif meanR < 149 && meanG < 138 && meanB < 122
        ObjectColor{i} = 'czarny';  
    else
        ObjectColor{i} = 'nieznany';
    end
end

%% measuring objects

    pause(0.1);
    L = bwlabel(contourOfAll);
    s = regionprops(L, 'Centroid');
%     figure;
%     imshow(image);
%     hold on;
%     % Show object numbers
%     for k = 1:numel(s)
%         c = s(k).Centroid;
%         text(c(1), c(2), sprintf('%d', k), ...
%             'HorizontalAlignment', 'center', ...
%             'VerticalAlignment', 'middle');
%     end
%     hold off;

%     pause(0.1);
    % figure;
    ObjectIndex = [];
    minPixels = 20;
    for i=1:numel(s)
        Obj = (L == i);  
        Area = regionprops(Obj, 'Area');
        if Area.Area > minPixels
            ObjectIndex = [ObjectIndex, i];
            Orientation(i) = regionprops(Obj, 'Orientation');
        end      
    end
    %% Scale object size (7.8 cm circle)
%     Obj = (L == 27);   % 1 is the label number of the first object. 
%     % Circularity = regionprops(Obj, 'Circularity');
%     MajorAxisLength = regionprops(Obj, 'MajorAxisLength');
%     Scale = 7.8 / MajorAxisLength.MajorAxisLength;

%     figure;
%     imshow(image);
%     hold on;
%% Object size version 1.0
%     ObjectSize=zeros(1,numel(s));
%     for i=1:numel(s)
%         Obj = (L == i);
%         MajorAxisLength = regionprops(Obj, 'MajorAxisLength');
%         ObjectSize(i) = MajorAxisLength.MajorAxisLength * Scale;
%     end
%     for k = 1:numel(s)
%         c = s(k).Centroid;
%         Obj = (L == k);
%         MajorAxisLength = regionprops(Obj, 'MajorAxisLength');
%         ObjectSize(k) = MajorAxisLength.MajorAxisLength * Scale;
%         text(c(1), c(2), sprintf('%.2f cm', ObjectSize(k)), ...
%             'HorizontalAlignment', 'center', ...
%             'VerticalAlignment', 'middle');
%     end
%     hold off;
    
%% Classify objects

cc = bwconncomp(allObjectsMask);

[out,LM] = bwferet(cc,'MaxFeretProperties');

maxLabel = max(LM(:));
maxSize = out.MaxDiameter(1:maxLabel);


[out,LM] = bwferet(cc,'MinFeretProperties');

maxLabel = max(LM(:));
minSize = out.MinDiameter(1:maxLabel);



%% Object size version 2.0 with Scale
Scale = 7.8/maxSize(27);
ObjectSize=zeros(1,numel(s));
for i = 1:numel(s)
    ObjectSize(i) = Scale * maxSize(i);
end


%% ... Classify objects 

ObjectClass = cell(1, maxLabel);

circle = 80;%
pen = 20;%


for i=1:maxLabel
    rate = minSize(i)/maxSize(i) * 100;
    if rate > circle
        ObjectClass{i} = 'Magnes';
    elseif rate < pen
        ObjectClass{i} = 'Dlugopis';
    else
        ObjectClass{i} = 'Nieznany';
    end
        
end

pause(0.1);
figure;
imshow(image);
hold on;
% Show object classes
for k = ObjectIndex
    c = s(k).Centroid;
    if ObjectClass{k} == string('Magnes')
        sizeName = 'srednica';
    elseif ObjectClass{k} == string('Dlugopis')
        sizeName = 'dlugosc';
    else 
        sizeName = 'rozmiar';
    end
        
    text(c(1), c(2), sprintf('%s %s\n%s=%.2fcm', ObjectColor{k}, ObjectClass{k},...
        sizeName,ObjectSize(k)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
end
hold off;