function [ success ] = processExperiment(expID, object_geometry_id, actuator_geometry_id)

%% Configure the important global parameters and load calibration parameter
configure;

%% expID is used to import experiment
dbImportExperiment;

%% build up the image and data plot directory
global dataDir
videoFilePath = strrep(videoFilePath, '\', '/');
ind = findstr(videoFilePath, '.avi');
videoFileCompletePath = [videoPath, videoFilePath];
if isempty(ind)
    imageDir = [imagePath, videoFilePath];
    dataDir = [dataPath, videoFilePath, '/'];
else
    imageDir = [imagePath, videoFilePath(1:ind(1)-1)];
    dataDir = [dataPath, videoFilePath(1:ind(1)-1), '/'];
end

% Create the image Directory if necessary
if ~isdir(imageDir)
    mkdir(imageDir);
end
if ~isdir(dataDir)
    mkdir(dataDir);
end

%% extract images
success = extractImageFromVideo(videoFileCompletePath, imageDir);

%% Load Calibration parameter
% PARAMETERFILENAME is defined in configure
calibPara = loadCalibration(PARAMETERFILENAME);

%% Offline process
if success
    offlineProcess(imageDir, calibPara, expID, object_geometry_id, actuator_geometry_id);
end

end


 