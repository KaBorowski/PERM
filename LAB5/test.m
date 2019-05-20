% read in image
image=imread('rozmyte.jpg');
% show show binary mask of all
imshow(allObjectMask);
% contour of all
contourOfAll = bwperim(allObjects, 8);
%% recognize size
I = im2bw(image);
figure;
subplot(1,2,1);
imshow(I);
subplot(1,2,2);
imshow()