% Stand-alone post process experiment
function postProcessExperiment(expID)

configure;
dbImportExperiment;
dbImportVideo;

global dataDir
videoFilePath = strrep(videoFilePath, '\', '/');
ind = findstr(videoFilePath, '.avi');
videoFileCompletePath = [videoPath, videoFilePath];
if isempty(ind)
    dataDir = [dataPath, videoFilePath, '/'];
else
    dataDir = [dataPath, videoFilePath(1:ind(1)-1), '/'];
end

% Create the data Directory if necessary
if ~isdir(dataDir)
    mkdir(dataDir);
end

[rGreenCenterF, rGreenSpeed, rGreenOrient, STARTID, ENDID, actuatorStart] = postProcess(TIMES, rGreenCenter);

global tactileSensorReads
if hasSynTactile
    synTactileReads = generateSynTactileReads(rObCenter, rObOrient, rPegsCenter, objGeometry, expFinalContactMode);
end

%% Export the result
dbExportVideo;
end
