% This script imports initial experiment data into the Matlab workspace

% 'expID' must be defined and must be valid in the database.  Puts data in
% 'videoFilePath','expFinalContactMode','hasTactile','tactileSensorReads',
% 'actVelocitySetting'

% Test to make sure 'expID' exists
if(exist('expID', 'var') == 0)
    fprintf('"expID" does not exist.  Please specify an experimet ID. Exiting Now.\n');
    return;
end

% connect using JDBC (faster than ODBC :-D)
% a matlab bug causes all global variables to be cleared
% from the workspace when calling javaaddpath
% %javaaddpath('postgresql-8.4-702.jdbc4.jar');
databaseConfig; 
dbConn = database(dbName, userName, passwd, driverName, host);
% check that we're connected
if(~isconnection(dbConn))
    error('Connection Error\n%s', dbConn.Message);
end

% if something screws up, close the connection and rollback if necessary
c = onCleanup(@()dbCleanupGracefully(dbConn));

%fprintf('Importing experiment data ...\n');

data = fetch(dbConn, sprintf('SELECT video_file_path, final_contact_mode, has_tactile_sensor, tactile_sensor_reads, actuator_velocity_setting FROM experiment WHERE experiment_ID = %d',expID));

global expFinalContactMode hasTactile tactileSensorReads
videoFilePath = cell2mat(data(1));
expFinalContactMode = cell2mat(data(2));
hasTactile = cell2mat(data(3));
tactileSensorReads = PostgresqlToMatlabArray(cell2mat(data(4)));
actVelocitySetting = cell2mat(data(5));

close(dbConn);

clear data;
clear dbConn;
clear c;

% %javarmpath('postgresql-8.4-702.jdbc4.jar')

%fprintf('Experiment data imported\n');
