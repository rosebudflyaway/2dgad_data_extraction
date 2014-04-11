function offlineProcess(imageDir, calibPara, expID, object_geometry_id, actuator_geometry_id)

global FRAMERATE hasSynTactile expFinalContactMode ANIMATE DEBUG PAUSEFRAMEINDEX;

%% load the object geometry and actuator geometry
% object_geometry_id actuator_geometry_id are used
dbImportObjectGeometry;
dbImportActuatorGeometry;

%% count the file number
imgCount = size(dir([imageDir, '/*.tif']), 1); % The number of images to show

TIMES = (1:imgCount) ./ FRAMERATE; % Calculate the experiment time series

%% process the images
% initialize the stickers coordinate in image space
% the coordinates extracted at one time step will be feed to the image
% processor at the next time step to narrow down the search range
redCenterCurrent = [];
blueCenterCurrent = [];
greenCenterCurrent = [];

% real world coordinates history
rRedCenter = zeros(imgCount, 3);
rBlueCenter = zeros(imgCount, 3);
rGreenCenter = zeros(imgCount, 3);

rObCenter = zeros(imgCount, 3);
rObOrient = zeros(imgCount, 1);

% Set the image obj as global variable to reduce copy cost
global imgOrigionalRGB;

% loop through all images and extract the coordinates
requestPegCoords = true;

if DEBUG && isempty(PAUSEFRAMEINDEX)
    isDebug = true;
else
    isDebug = false;
end
for i = 1:imgCount
    
    disp(strcat('Starting processing frame ', num2str(i), ' ...'));
    % Load the image
    fileName = [imageDir, '/', num2str(i), '.tif'];
    
    imgOrigionalRGB = imread(fileName);
    
    if ~isempty(PAUSEFRAMEINDEX) && DEBUG
        if i == PAUSEFRAMEINDEX
            isDebug = true;
        else
            isDebug = false;
        end
    end
    
%     imageDimension = [size(imgOrigionalRGB, 1) size(imgOrigionalRGB, 2)];
% %     edgeWidth = imageDimension/8;
%    % imgOrigionalRGB(1:edgeWidth(1), :, :) = 0;
%    % imgOrigionalRGB(imageDimension(1)-edgeWidth(1):imageDimension(1), :, :) = 0;
%     imgOrigionalRGB(:, 1:edgeWidth(2), :) = 0;
%     imgOrigionalRGB(:, imageDimension(2)-edgeWidth(2):imageDimension(2), :) = 0;
%     
    
    
    
    % Process the image
    if requestPegCoords
        [rRedCenterCurrent, rBlueCenterCurrent, rGreenCenterCurrent, rObCenterCurrent, rObOrientCurrent, rPegsCenter, ...
            redCenterCurrent, blueCenterCurrent, greenCenterCurrent] ...
            = imageProcess(calibPara, objHeight, actHeight, redCenterCurrent, blueCenterCurrent, greenCenterCurrent, true, isDebug);
    else
        % Process the image
        [rRedCenterCurrent, rBlueCenterCurrent, rGreenCenterCurrent, rObCenterCurrent, rObOrientCurrent, ~, ...
            redCenterCurrent, blueCenterCurrent, greenCenterCurrent] ...
            = imageProcess(calibPara, objHeight, actHeight, redCenterCurrent, blueCenterCurrent, greenCenterCurrent, false, isDebug);
    end
    
    rRedCenter(i, :) = rRedCenterCurrent(:)';
    rBlueCenter(i, :) = rBlueCenterCurrent(:)';
    rGreenCenter(i, :) = rGreenCenterCurrent(:)';
    
    rObCenter(i, :) = rObCenterCurrent(:)';
    rObOrient(i, :) = rObOrientCurrent(:)';
    
    if i == 1, requestPegCoords = false; end % do not need to recalculate pegs coordinate every timestep because they're fixed
end

%% Filter Actuator Movement and generate synthetic tactile sensor data if
% necessary

[rGreenCenterF, rGreenSpeed, rGreenOrient, STARTID, ENDID, actuatorStart] = postProcess(TIMES, rGreenCenter);

if hasSynTactile
    synTactileReads = generateSynTactileReads(rObCenter, rObOrient, rPegsCenter, object_geometry_id, expFinalContactMode);
end

%% Export the result
dbExportVideo;

end