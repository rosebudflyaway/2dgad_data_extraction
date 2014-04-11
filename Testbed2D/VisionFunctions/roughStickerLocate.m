function [center, pegCenter] = roughStickerLocate(stickerColor, region, isDebug, requestPegCoords)
% roughly locate the stickers given its color

%% global variables and settings
global imgOrigionalRGB
global RED BLUE GREEN
global STICKERREGIONWIDTH;
global REDHUE BLUEHUE GREENHUE hueTolerance;

close all

imgOrigionalR = imgOrigionalRGB(region(2):region(4),region(1):region(3),1);
imgOrigionalG = imgOrigionalRGB(region(2):region(4),region(1):region(3),2);
imgOrigionalB = imgOrigionalRGB(region(2):region(4),region(1):region(3),3);

if requestPegCoords
    DIAMETER = STICKERREGIONWIDTH/30;
else
    DIAMETER = STICKERREGIONWIDTH/10;
end
%% Distinguish all candidate pixels for the color

switch stickerColor
    case RED,
        pixel = ~((imgOrigionalR > imgOrigionalG ) ...
            &(imgOrigionalR > imgOrigionalB));
        result1 = double(imgOrigionalR) - double(imgOrigionalG);
        result2 = double(imgOrigionalR) - double(imgOrigionalB);
        HUE = REDHUE;
    case BLUE,    
        pixel = ~((imgOrigionalB > imgOrigionalG ) ...
            &(imgOrigionalB > imgOrigionalR));
        result1 = double(imgOrigionalB) - double(imgOrigionalR);
        result2 = double(imgOrigionalB) - double(imgOrigionalG);
        HUE = BLUEHUE;
    case GREEN,
        pixel = ~((imgOrigionalG > imgOrigionalB ) ...
            &(imgOrigionalG > imgOrigionalR));
        result1 = double(imgOrigionalG) - double(imgOrigionalB);
        result2 = double(imgOrigionalG) - double(imgOrigionalR);
        HUE = GREENHUE;
end

if isDebug,
    figure, title('Rough sticker location');
    set(gcf, 'Position', get(0, 'ScreenSize')); % Maximize figure.
end

%% locate the stickers without using rgb color and threshold
result1 = result1/255;
result2 = result2/255;
result1(pixel) = 0;
result2(pixel) = 0;

if isDebug, subplot(2,3,1), imshow(result1); end
if isDebug, subplot(2,3,2), imshow(result2); end

result = result1.*result2;          % product can distinguish the color more
result = result.*result;
result = result./max(max(result));
if isDebug, subplot(2,3,3), imshow(result); end

% 
se = strel('disk', floor(DIAMETER));              % remove the background noise

afterOpening = imopen(result, se);
afterOpening = afterOpening./max(max(afterOpening));
if isDebug, subplot(2,3,4), imshow(afterOpening); end

% Thresholding in hue space to distinguish the sticker from similar color
imgHSV = rgb2hsv(imgOrigionalRGB(region(2):region(4),region(1):region(3),:));
imgH = imgHSV(:, :, 1);
pixelIDThresh = (imgH > HUE + hueTolerance) | (imgH < HUE - hueTolerance);
afterOpening(pixelIDThresh) = afterOpening(pixelIDThresh) * 0.1;
if isDebug, subplot(2,3,5), imshow(afterOpening); end

bwlevel = graythresh(afterOpening);   
%bwlevel = 0.5;
BW = im2bw(afterOpening, bwlevel); % convert to black and white

if isDebug, subplot(2,3,6), imshow(BW); end

%% Calculate the region centroid
stickerCC = bwconncomp(BW, 4);   %4-connected neighbourhood
numPixels = cellfun(@numel, stickerCC.PixelIdxList);

% Locate the biggest connect component as the sticker
[~,idx] = max(numPixels);
% remove all other components in the component structure, though it's
% possibly already just one region left after all procedures above
bigStickerCC = stickerCC;
bigStickerCC.NumObjects = 1;
tmp = stickerCC.PixelIdxList{idx};
bigStickerCC.PixelIdxList = cell(1);
bigStickerCC.PixelIdxList{1} = tmp;

% Sticker centroid calculation
centroid = regionprops(bigStickerCC, 'Centroid');
center = centroid.Centroid(:);

if requestPegCoords
    numPixels(idx) = 0;
    [~,idx] = max(numPixels);
    pegStickerCC = stickerCC;
    pegStickerCC.NumObjects = 1;
    tmp = stickerCC.PixelIdxList{idx};
    pegStickerCC.PixelIdxList = cell(1);
    pegStickerCC.PixelIdxList{1} = tmp;
    pegCentroid = regionprops(pegStickerCC, 'Centroid');
    pegCenter = pegCentroid.Centroid(:);
else
    pegCenter = [];
end

end

