% BW=imread('rozmyte.jpg');
BW2 = bwperim(BW4, 8);
% imshowpair(BW4,BW2,'montage');
x=580;
y=695;
contour = bwtraceboundary(BW2,[x y],'W');
imshow(BW2);
hold on;

plot(contour(:,2),contour(:,1),'g','LineWidth',2)