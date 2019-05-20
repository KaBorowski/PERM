% read in image
clear ;
image=imread('rozmyte.jpg');
load('allObjectsMask.mat')
%% show binary contour mask of all
% contour of all
contourOfAll = bwperim(allObjectsMask, 8);

%% recognize colors
    %cut out background of image
    noBackgroundRGBImage = bsxfun(@times, image, cast(allObjectsMask,class(image)));
    lab_Image = rgb2lab(noBackgroundRGBImage);
    ab_image = lab_Image(:,:,2:3);
    ab_image = im2single(ab_image);
    nColors = 6;
    % repeat the clustering 3 times to avoid local minima
    pixel_labels = imsegkmeans(ab_image,nColors,'NumAttempts',3);

    mask1 = pixel_labels==1;
    blackMaskRGB = noBackgroundRGBImage .* uint8(mask1);
    blackMask = squeeze(blackMaskRGB(:,:,1));
    blackMask = imbinarize(blackMask);
    [blackB,blackL] = bwboundaries(blackMask);
    blackB = removeHoles(blackB);
    % figure;
    % imshow(blackMask)
    mask2 = pixel_labels==2;
    redMaskRGB = noBackgroundRGBImage .* uint8(mask2);
    redMask = squeeze(redMaskRGB(:,:,1));
    redMask = imbinarize(redMask);
    [redB,redL] = bwboundaries(redMask);
    redB = removeHoles(redB);
    % figure;
    % imshow(redMask)
    mask3 = pixel_labels==3;
    greenMaskRGB = noBackgroundRGBImage .* uint8(mask3);
    greenMask = squeeze(greenMaskRGB(:,:,1));
    greenMask = imbinarize(greenMask);
    [greenB,greenL] = bwboundaries(greenMask);
    greenB = removeHoles(greenB);
    % figure;
    % imshow(greenMask)
    mask4 = pixel_labels==4;
    blueMaskRGB = noBackgroundRGBImage .* uint8(mask4);
    blueMask = squeeze(blueMaskRGB(:,:,1));
    blueMask = imbinarize(blueMask);
    [blueB,blueL] = bwboundaries(blueMask);
    blueB = removeHoles(blueB);
    % figure;
    % imshow(blueMask)
    mask5 = pixel_labels==5;
    yellowMaskRGB = noBackgroundRGBImage .* uint8(mask5);
    yellowMask = squeeze(yellowMaskRGB(:,:,1));
    yellowMask = imbinarize(yellowMask);
    [yellowB,yellowL] = bwboundaries(yellowMask);
    yellowB = removeHoles(yellowB);
    % figure;
    % imshow(yellowMask)
    mask6 = pixel_labels==6;
    whiteMaskRGB = noBackgroundRGBImage .* uint8(mask6);
    whiteMask = squeeze(whiteMaskRGB(:,:,1));
    whiteMask = imbinarize(whiteMask);
    [whiteB,whiteL] = bwboundaries(whiteMask);
    whiteB = removeHoles(whiteB);
    % figure;
    % imshow(whiteMask)
    coloredContours = [blackB', redB', greenB', blueB', yellowB', whiteB']';
    DDDD = 0;
    if greenL == whiteL
        DDDD = 1;
    end

    %% finding single objects

    for k=1:length(coloredContours)
      boundary = coloredContours{k};

      color = 'black';
      if k > length(blackB)
          color = 'red';
      end
      if k > length(blackB) + length(redB)
          color = 'green';
      end
      if k > length(blackB) + length(redB) + length(greenB)
          color = 'blue';
      end
      if k > length(blackB) + length(redB) + length(greenB) + length(blueB)
          color = 'yellow';
      end
      if k > length(blackB) + length(redB) + length(greenB) + length(blueB) + length(yellowB)
          color = 'magenta';
      end

      plot(boundary(:,1), boundary(:,2),color,'LineWidth',2);
      hold on;

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
    % for i=1:numel(s)
    %     Obj = (L == i);   % 1 is the label number of the first object. 
    % %     subplot(round(sqrt(numel(s))),round(sqrt(numel(s))),i);
    %     figure;imshow(Obj);
    %     title(strcat('Object nr ', num2str(i)));
    % end
    %% Scale object size (7.8 cm circle)
    Obj = (L == 27);   % 1 is the label number of the first object. 
    % Circularity = regionprops(Obj, 'Circularity');
    MajorAxisLength = regionprops(Obj, 'MajorAxisLength');
    Scale = 7.8 / MajorAxisLength.MajorAxisLength;

%     figure;
%     imshow(image);
%     hold on;
    ObjectSize=zeros(1,numel(s));
    for i=1:numel(s)
        Obj = (L == i);
        MajorAxisLength = regionprops(Obj, 'MajorAxisLength');
        ObjectSize(i) = MajorAxisLength.MajorAxisLength * Scale;
    end
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
for k = 1:numel(s)
    c = s(k).Centroid;
    if ObjectClass{k} == "Magnes"
        sizeName = 'srednica';
    elseif ObjectClass{k} == "Dlugopis"
        sizeName = 'dlugosc';
    else 
        sizeName = 'rozmiar';
    end
        
    text(c(1), c(2), sprintf('%s\n%s=%.2fcm', ObjectClass{k},...
        sizeName,ObjectSize(k)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
end
hold off;