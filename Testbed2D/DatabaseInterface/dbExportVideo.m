% Exports the video processing data to database.

% connect using JDBC (faster than ODBC :-D)
% a matlab bug causes all global variables to be cleared
% from the workspace when calling javaaddpath
%javaaddpath('postgresql-8.4-702.jdbc4.jar');
databaseConfig; 
dbConn = database(dbName, userName, passwd, driverName, host);

% check that we're connected
if(~isconnection(dbConn))
    error('Connection Error\n%s', dbConn.Message);
end

% if something screws up, close the connection and rollback if necessary
c = onCleanup(@()dbCleanupGracefully(dbConn));

% set AutoCommit to off, so that no bad data goes in the database if
% the function fails for whatever reason
set(dbConn,'AutoCommit','off');

fprintf('Exporting Video Data ...\n');

% Load the struct with all the data to be exported to the database
experimentData.effective_start_time = STARTID;
experimentData.effective_end_time = ENDID;
experimentData.has_synthetic_tactile_sensor = hasSynTactile;
experimentData.synthetic_tactile_sensor_reads = MatlabToPostgresqlArray(synTactileReads);
experimentData.fixel_1_position = MatlabToPostgresqlArray(rPegsCenter(1,:));
experimentData.fixel_2_position = MatlabToPostgresqlArray(rPegsCenter(2,:));
experimentData.fixel_3_position = MatlabToPostgresqlArray(rPegsCenter(3,:));
experimentData.actuator_initial_position = MatlabToPostgresqlArray(actuatorStart);
experimentData.frametimes = MatlabToPostgresqlArray(TIMES);
experimentData.object_marker_1_position = MatlabToPostgresqlArray(rRedCenter);
experimentData.object_marker_2_position = MatlabToPostgresqlArray(rBlueCenter);
experimentData.object_position = MatlabToPostgresqlArray(rObCenter);
experimentData.object_rotation = MatlabToPostgresqlArray(rObOrient);
experimentData.actuator_marker_position = MatlabToPostgresqlArray(rGreenCenter);
experimentData.actuator_position = MatlabToPostgresqlArray(rGreenCenterF);
experimentData.actuator_velocity = rGreenSpeed;
experimentData.actuator_rotation = rGreenOrient;
experimentData.object_initial_position = MatlabToPostgresqlArray(rObCenter(STARTID,:));
experimentData.object_initial_rotation = rObOrient(STARTID,:);
experimentData.object_geometry_id = object_geometry_id;
experimentData.actuator_geometry_id = actuator_geometry_id;

% Generate the clause that will give us the one experiment
whereClause = sprintf('WHERE experiment_id = %d',expID);

% A list of all the fields we have to update.
experimentFields = {'effective_start_time','effective_end_time','has_synthetic_tactile_sensor',...
    'synthetic_tactile_sensor_reads','fixel_1_position','fixel_2_position','fixel_3_position','actuator_initial_position',...
    'frametimes','object_marker_1_position','object_marker_2_position','object_position','object_rotation','actuator_marker_position',...
    'actuator_position','actuator_velocity','actuator_rotation','object_initial_position','object_initial_rotation',...
    'object_geometry_id','actuator_geometry_id'};
% Perform the update operation to add the data to the 'experiment'
% table
update(dbConn, 'experiment', experimentFields, experimentData, whereClause);

% finished, commit our changes
commit(dbConn);

close(dbConn);
clear dbConn;
clear c;
clear experimentData;
clear experimentFields;
clear whereClause;

%javarmpath('postgresql-8.4-702.jdbc4.jar')

% Export of experiment data from video processing is completed
fprintf('Exporting Video Data Completed\n');
