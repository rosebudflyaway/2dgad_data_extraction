function [rCenter center] = fineStickerLocate(stickerColor, region, offset, height, isDebug, calibPara)
% locate the sticker within a small area using more accurate method

%% parameters

global imgOrigionalRGB
global RED BLUE GREEN
persistent imgHnd


DIAMETER = double(floor((region(3) - region(1))/6));
if DIAMETER < 8
    htInImageSpace = true;
else
    htInImageSpace = false;
end

Rc = calibPara.Rc;
Tc = calibPara.Tc;
cc = calibPara.cc;
fc = calibPara.fc;
kc = calibPara.kc;
alpha_c = calibPara.alpha_c;

%% extract the small region around the sticker to accelerate processing
origRegion = imgOrigionalRGB(region(2):region(4),region(1):region(3), :);
workRegion = origRegion;

%% initialize the figure
if isDebug
    if isempty(imgHnd)
        imgHnd = figure;
        title('Fine sticker location');
        set(gcf, 'Position', get(0, 'ScreenSize')); % Maximize figure.
    else
        figure(imgHnd);
    end
end

%% Eliminate background by eliminating possible colors
% Distinguish all candidate pixels for the color
imgR = double(workRegion(:,:,1))/255;
imgG = double(workRegion(:,:,2))/255;
imgB = double(workRegion(:,:,3))/255;

switch stickerColor
    case RED,
        pixel = ~((imgR > imgG ) ...
            &(imgR > imgB));
        result1 = imgR - imgB;
        result2 = imgR - imgG;
    case BLUE,
        pixel = ~((imgB > imgG ) ...
            &(imgB > imgR));
        result1 = imgB - imgR;
        result2 = imgB - imgG;
    case GREEN,
        pixel = ~((imgG > imgB ) ...
            &(imgG > imgR));
        result1 = imgG - imgR;
        result2 = imgG - imgB;
    otherwise,
        null;
end



%% Finer location


if htInImageSpace
    result = result1.*result2;          % product can distinguish the color more
    result = result.*result;
    result = result./max(max(result));
    grayMat = result;  % convert to double grayscale image
else
    grayWorkRegion = rgb2gray(workRegion);
    grayWorkRegion = double(grayWorkRegion)/255.0;
    grayWorkRegion(pixel) = grayWorkRegion(pixel) * 0.1;
    grayMat = grayWorkRegion;
end
if isDebug, subplot(231), imshow(grayMat), title('Grayscale'); end
grayMatFilt = medfilt2(grayMat, [DIAMETER DIAMETER]);  % 11*11 median filter
if isDebug, subplot(232), imshow(grayMatFilt), title('Median Filtering'); end

grayMatFilt = grayMatFilt./max(max(grayMatFilt)); % intensify the contrast
if isDebug, subplot(233), imshow(grayMatFilt), title('Cut');  end

level = graythresh(grayMatFilt); % find the thresh to convert to bw
grayMatFiltBW = im2bw(grayMatFilt, level); % convert to bw
if isDebug, subplot(234), imshow(grayMatFiltBW), title('Cut Black&White'); end

grayMatFiltBWEdge = edge(double(grayMatFiltBW), 'sobel'); % find the edge
if isDebug, subplot(235), imshow(grayMatFiltBWEdge), title('Edge Detected'); end

%% Circle Edge Detection and convert back to image space
if htInImageSpace
    [center, ~, edgeX, edgeY] = hTCircleDetectionImageSpace(grayMatFiltBWEdge);
    center = center + offset;
    rCenter = coordinateInverse(center, height, calibPara);
    edgeCoord = [edgeX'; edgeY'] + repmat(offset, 1, size(edgeX, 1));
else
    [rCenter , ~, rEdgeX, rEdgeY] = hTCircleDetection(grayMatFiltBWEdge, offset(1), offset(2), height, calibPara);
    rCenter(3) = height;
    rEdge = [rEdgeX'; rEdgeY'];  rEdge(3,:) = height;
    center = project_points2(rCenter, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
    edgeCoord = project_points2(rEdge, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
end
if isDebug,
    subplot(236), imshow(origRegion), title('Comparison'), hold on;
    plot(edgeCoord(1,:)-offset(1), edgeCoord(2,:)-offset(2), 'ro');
    plot(center(1)-offset(1), center(2)-offset(2), 'go');
end

end