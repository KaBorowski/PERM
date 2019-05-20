% read in image
image=imread('rozmyte.jpg');
% show show binary mask of all
imshow(allObjectMask);
% contour of all
contourOfAll = bwperim(allObjects, 8);
%% recognize colors
%cut out background of image
noBackgroundRGBImage = bsxfun(@times, image, cast(allObjects,class(BW)));
figure;
imshow(noBackgroundRGBImage);
lab_Image = rgb2lab(noBackgroundImage);
LChannel = lab_Image(:, :, 1); 
aChannel = lab_Image(:, :, 2); 
bChannel = lab_Image(:, :, 3);
figure;
subplot(3, 1, 1);
imshow(LChannel, []);
title('L Channel', 'FontSize', 20);
subplot(3, 1, 2);
imshow(aChannel, []);
title('a Channel', 'FontSize', 10);
subplot(3, 1, 3);
imshow(bChannel, []);
title('b Channel', 'FontSize', 10);
% [LMean, aMean, bMean] = GetMeanLABValues(LChannel, aChannel, bChannel, allObjects);

% % ab_image = lab_image(:,:,2:3);
% % ab_image = im2single(ab_image);
% % nColors = 6;
% % % repeat the clustering 3 times to avoid local minima
% % pixel_labels = imsegkmeans(ab_image,nColors,'NumAttempts',3);
% % % pixel_labels should be array of colors from image- dunno, check in R2019a
% % %show one color
% % mask1 = pixel_labels==1;
% % cluster1 = he .* uint8(mask1);
% % imshow(cluster1)
% % title('Objects in Cluster 1');

%% find and mark contour of red circle
% x=637;
% y=806;
% contour = bwtraceboundary(contourOfAll,[x y],'W');
% figure;
% imshow(contourOfAll)
% hold on;
% plot(contour(:,2),contour(:,1),'g','LineWidth',2)