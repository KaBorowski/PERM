% read in image
clear all;
image=imread('rozmyte.jpg');
load('allObjectsMask.mat')
test = 2;
%% show binary contour mask of all
%imshow(allObjectMask);
% contour of all
contourOfAll = bwperim(allObjectsMask, 8);
figure;
imshow(contourOfAll);
%% recognize colors
if test == 1
    %cut out background of image
    noBackgroundRGBImage = bsxfun(@times, image, cast(allObjectsMask,class(image)));
    % imshow(noBackgroundRGBImage);
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

    %% find and mark contour of red circle
    % x=637;
    % y=806;
    % contour = bwtraceboundary(contourOfAll,[x y],'W');
    % figure;
    % imshow(contourOfAll)
    % hold on;
    % plot(contour(:,2),contour(:,1),'g','LineWidth',2)

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

    % %randomize text position for better visibility
    %  rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
    %  col = boundary(rndRow,2); row = boundary(rndRow,1);
    %   h = text(col+1, row-1, num2str(L(row,col)));
    %   set(h,'Color',colors(cidx),'FontSize',14,'FontWeight','bold');
    end
end

%% measuring objects
if test ==2
    pause(0.1);
    L = bwlabel(contourOfAll);
    s = regionprops(L, 'Centroid');
    figure;
    imshow(image);
    hold on;
    % Show object numbers
    for k = 1:numel(s)
        c = s(k).Centroid;
        text(c(1), c(2), sprintf('%d', k), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle');
    end
    hold off;
    pause(0.1);
    % Step 3: find the area of the object you want using its label
    % Area = zeros(1,numel(s));
    % figure;
    % for i=1:numel(s)
    %     Obj = (L == i);   % 1 is the label number of the first object. 
    % %     subplot(round(sqrt(numel(s))),round(sqrt(numel(s))),i);
    %     figure;imshow(Obj);
    %     title(strcat('Object nr ', num2str(i)));
    % %     Area(i) = regionprops(Obj,'Area'); % the answer
    % end
    %% Scale object size (7.8 cm circle)
    Obj = (L == 27);   % 1 is the label number of the first object. 
    % Circularity = regionprops(Obj, 'Circularity');
    MajorAxisLength = regionprops(Obj, 'MajorAxisLength');
    Scale = 7.8 / MajorAxisLength.MajorAxisLength;

    figure;
    imshow(image);
    hold on;
    ObjectSize=zeros(1,numel(s));
    for k = 1:numel(s)
        c = s(k).Centroid;
        Obj = (L == k);
        MajorAxisLength = regionprops(Obj, 'MajorAxisLength');
        ObjectSize(k) = MajorAxisLength.MajorAxisLength * Scale;
        text(c(1), c(2), sprintf('%.2f cm', ObjectSize(k)), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle');
    end
    hold off;

end