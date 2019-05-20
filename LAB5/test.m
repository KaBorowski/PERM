clear;

% read in image
image=imread('rozmyte.jpg');
imtool(image);
% show show binary mask of all
load('allObjectsMask.mat');

% contour of all
contourOfAll = bwperim(allObjectsMask, 8);

%% recognize size
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
pause(0.01);

% figure;
% for i=1:numel(s)
%     Obj = (L == i);   % 1 is the label number of the first object. 
% %     subplot(round(sqrt(numel(s))),round(sqrt(numel(s))),i);
%     figure;imshow(Obj);
%     title(strcat('Object nr ', num2str(i)));
% 
% end
%% Scale object size (7.8 cm circle)
Obj = (L == 27);   % 1 is the label number of the first object. 
% figure;
% imshow(Obj);
% Area = regionprops(Obj,'Area'); % the answer
% Circularity = regionprops(Obj, 'Circularity');
MajorAxisLength = regionprops(Obj, 'MajorAxisLength');
Scale = 7.8 / MajorAxisLength.MajorAxisLength;

pause(0.1);
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
    text(c(1), c(2), sprintf('%s', ObjectClass{k}), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
end
hold off;



