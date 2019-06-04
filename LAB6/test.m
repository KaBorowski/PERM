clear;
img1 = imread('11.png');
img2 = imread('12.png');
img2 = double(img2);

cy(1:480) = 312;
cx(1:640) = 264;

fx = 525;
fy = 525;

x=1:640;
y=1:480;


X=((x - cx)./fx).*img2;

Y=((y - cy)./fy)'.*img2;

pc(:,:,1) = Y;
pc(:,:,2) = X;
pc(:,:,3) = img2;

pcshow(pc);

ptCloud = pointCloud(pc);

maxDistance = 8;
referenceVector = [0,0,1];
maxAngularDistance = 20;

[model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,...
            maxDistance,referenceVector,maxAngularDistance);
plane1 = select(ptCloud,inlierIndices);
remainPtCloud = select(ptCloud,outlierIndices);



roi = [-inf,inf;0.4,inf;-inf,inf];
sampleIndices = findPointsInROI(remainPtCloud,roi);

% [model2,inlierIndices,outlierIndices] = pcfitplane(remainPtCloud,...
%             maxDistance,'SampleIndices',sampleIndices);
% plane2 = select(remainPtCloud,inlierIndices);
% remainPtCloud = select(remainPtCloud,outlierIndices);

figure;
pcshow(plane1);
% figure;
% pcshow(plane2);
figure;
pcshow(remainPtCloud);


mask = ones(size(img1));
imshow(mask)
mask(inlierIndices) = 0;
