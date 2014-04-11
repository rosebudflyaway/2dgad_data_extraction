function tactile_bytes = Capture_Video_And_Tactile( video_file_path )
% This function will capture video and tactile data until a user 
% manually terminates the function

configure();

% global videoPath
global videoPath

% Path to videos
video_file_path = strcat(videoPath, video_file_path);

% Initialize video object
vid = videoinput('winvideo', 1, 'RGB24_1280x720');

% Get video source
src = getselectedsource(vid);

% Set frames per trigger to infinite (for video)
vid.FramesPerTrigger = Inf;

% Preview the shot
%preview(vid);

% Set focus to manual so that we don't refocus while we are filming
src.FocusMode = 'manual';

% Save video to disk
vid.LoggingMode = 'disk';

% Settings for file and video stream initialization to disk
diskLogger = avifile(video_file_path, 'Compression', 'None', 'Quality', 75, 'keyframepersec', 2.14, 'FPS', 30);
vid.DiskLogger = diskLogger;

%Cell array to hold tactile bytes
%tactile_bytes = cell(1);
global tactileBytes

tactileBytes = cell(1);

% Arduino object. Attempt to delete before we use it to be safe.
delete(instrfind({'Port'},{'COM4'}))
arduino_object = arduino('COM4');

% Set callback function
set(vid,'FramesAcquiredFcnCount', 1);
%set(vid,'FramesAcquiredFcn', {'Query_Tactile_Sensor_Callback', tactile_bytes, arduino_object});
vid.FramesAcquiredFcn = {'Query_Tactile_Sensor_Callback', arduino_object};

try

% Start the video
start(vid);

% This will wait for keyboard input - Press any key to stop video capture
evalResponse = input('Press any key to stop video capture');

% Stop the video and it's preview
stop(vid);
%stoppreview(vid);

% Write to disk
while(vid.DiskLoggerFrameCount ~= vid.FramesAcquired)
    pause(1);
end

diskLogger = close(vid.DiskLogger);

% If there is an error anywhere, exit so we don't save to the database
catch
   return; 
end

% Returned tactile bytes
tactile_bytes = tactileBytes;
tactile_bytes = cell2mat(tactile_bytes);

% Dispose of arduino object
delete(instrfind({'Port'},{'COM4'}))

finalContactMode = tactileBytes(length(tactileBytes));

dbExportExperimentWithTactileNoPrompt(video_file_path, tactileBytes, finalContactMode);

end

