function animate(expID, simID, animateExp, fullExperiment, overlayWithImage, outputVideoFile)
%% Necessary global parameters
configure;
global tactileSensorReads sensorReads;
%% Import all data from GAD
dbImportExperiment;
dbImportVideo;


%% Define the range
if fullExperiment
    range = 1:numel(rObOrient);
else
    range = STARTID:ENDID;
end

%% Video and Image and Data file path
videoFilePath = strrep(videoFilePath, '\', '/');
ind = findstr(videoFilePath, '.avi');
if isempty(ind)
    imageDir = [imagePath, videoFilePath];
    dataDir = [dataPath, videoFilePath, '/'];
else
    imageDir = [imagePath, videoFilePath(1:ind(1)-1)];
    dataDir = [dataPath, videoFilePath(1:ind(1)-1), '/'];
end

if ~isdir(dataDir)
    mkdir(dataDir);
end

if ~isempty(outputVideoFile)
    videoDir = [dataDir outputVideoFile];
else
    videoDir = [];
end

if ~ animateExp
    dbImportSimulation;
    if overlayWithImage
        imageFileList = cell(ENDID - STARTID + 1, 1);
        for i = STARTID : ENDID
            imageFileList{i-STARTID+1} = strcat(imageDir, '/', num2str(i), '.', 'tif');
        end
        calibPara = loadCalibration(PARAMETERFILENAME);
        sensorReads = tactileSensorReads(STARTID:end, :);
        drawAnimation(videoDir, sGreenCenter, rGreenOrient, ...
            sObCenter, sObOrient, rPegsCenter, ...
            objGeometry, actGeometry, true, calibPara, objHeight, actHeight, imageFileList)

    else
        drawAnimation(videoDir, sGreenCenter, rGreenOrient, ...
            sObCenter, sObOrient, rPegsCenter, ...
            objGeometry, actGeometry, false);
    end
else
    if overlayWithImage
        imageFileList = cell(numel(range), 1);
        for i = 1 : numel(range)
            imageFileList{i} = strcat(imageDir, '/', num2str(range(i)), '.', 'tif');
        end
        calibPara = loadCalibration(PARAMETERFILENAME);
        sensorReads = tactileSensorReads(range(1):end, :);
        drawAnimation(videoDir, rGreenCenter(range(1):range(end), :), rGreenOrient, ...
            rObCenter(range(1):range(end), :), rObOrient(range(1):range(end)), rPegsCenter, ...
            objGeometry, actGeometry, true, calibPara, objHeight, actHeight, imageFileList)
    else
        drawAnimation(videoDir, rGreenCenter(range(1):range(end), :), rGreenOrient, ...
            rObCenter(range(1):range(end), :), rObOrient(range(1):range(end)), rPegsCenter, ...
            objGeometry, actGeometry, false);
    end
end
end
