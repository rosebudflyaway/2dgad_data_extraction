function dbExportExperimentWithTactile(tactile_byte_array)

% Exports initial experiment data to the database.

% Exports the video file path, final contact mode, actual velocity
%  setting and tactile data to the database.  expID will be
%  changed to the current experiment ID in the database.  It will not be
%  changed if there was a failure.


% connect using JDBC (faster than ODBC :-D)
% a matlab bug causes all global variables to be cleared
% from the workspace when calling javaaddpath
%javaaddpath('postgresql-8.4-702.jdbc4.jar');
dbConn = database('2DGAD','robotics','sensornet','org.postgresql.Driver','jdbc:postgresql://grasp.robotics.cs.rpi.edu/');

% check that we're connected
if(~isconnection(dbConn))
    error('Connection Error\n%s', dbConn.Message);
end

% if something screws up, close the connection and rollback if necessary
c = onCleanup(@()dbCleanupGracefully(dbConn));

% set AutoCommit to off, so that no bad data goes in the database if
% the function fails for whatever reason
set(dbConn,'AutoCommit','off');

% Get the information needed to export the experiment
% Get the video file path
videoFilePath = regexptranslate('escape',input('Enter video file path: ','s'));

% Get the contact mode  (How are we going to define the contact mode?)
expFinalContactMode = str2double(input('Enter final contact mode: ', 's'));
if(floor(expFinalContactMode) ~= expFinalContactMode)
    fprintf('\nInvalid Input. Must enter an integer value. Exiting now.\n')
    return;
end

% Get the actual velocity setting
actVelocitySetting = str2double(input('Enter actuator velocity setting: ', 's'));
if(isnan(actVelocitySetting))
    fprintf('\nInvalid Inupt.  Exiting now.\n');
    return;
end

% Verify that the user does or does not want tactile data
hasTactile = upper(input('Does experiment have tactile sensors? [Y/N] ' ,'s'));
if(hasTactile == 'Y')
    hasTactile = 1;
elseif (hasTactile == 'N')
    hasTactile = 0;
    tactileSensorReads = [];
else
    fprintf('\nInvalid input.  Enter only "Y" or "N".  Exiting Now\n');
    return;
end

% Begin exporting of data
fprintf('\nExporting Experiment Data ...\n');

% Convert to array format
tactile_byte_array = Convert_Tactile_Bytes_To_Contact_Arrays(tactile_byte_array);

experimentData.video_file_path = videoFilePath;
experimentData.final_contact_mode = expFinalContactMode;
experimentData.actuator_velocity_setting = actVelocitySetting;
experimentData.has_tactile_sensor = hasTactile;
experimentData.tactile_sensor_reads = MatlabToPostgresqlArray(tactile_byte_array);

experimentFields = {'video_file_path','final_contact_mode','actuator_velocity_setting', 'has_tactile_sensor',...
                    'tactile_sensor_reads'};

insert(dbConn, 'experiment', experimentFields ,experimentData);

% Determine experiment id
expID = cell2mat(fetch(dbConn, 'SELECT max(experiment_id) FROM experiment;'));

%tactile_column_name = {'tactile_sensor_reads'}

%Insert tactile data
%update(dbConn, 'experiment', tactile_column_name, tactile_byte_array, strcat('WHERE experiment_id = ', num2str(expID)));

fprintf('\nThe experiment ID is: %d\n', expID);

% Finished, commit our changes
commit(dbConn);

close(dbConn);
clear dbConn;
clear experimentData;
clear experimentFields;
clear c;

%javarmpath('postgresql-8.4-702.jdbc4.jar')

% Export of data is complete
fprintf('\nExport Finished \n');

end