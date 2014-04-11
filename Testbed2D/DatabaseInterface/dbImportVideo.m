% Imports data from video processing from the database

% 'expID' must be defined and be valid in the database
% Puts data in the following variables:
% expFinalContactMode, STARTID, ENDID, rPegsCenter, actuatorStart,
% rObCenter, rObOrient, rGreenCenterF, rGreenSpeed, rGreenOrient,
% hasTactile, hasSynTactile, tactileSensorReads,
% syntheticTactileSensorReads, object_initial_position,
% object_initial_rotation, TIMES

% Test to make sure the experiment ID is defined
if(exist('expID', 'var') == 0)
    fprintf('"expID" does not exist.  Please specify an experimet ID. Exiting Now.\n');
    return;
end

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

%fprintf('Importing Video Data ...\n');

% Get object and actuator geometries
object_geometry_id = cell2mat(fetch(dbConn, sprintf('SELECT object_geometry_id FROM experiment WHERE experiment_id = %d',expID)));
actuator_geometry_id = cell2mat(fetch(dbConn, sprintf('SELECT actuator_geometry_id FROM experiment WHERE experiment_id = %d',expID)));

data = fetch(dbConn, sprintf('SELECT geometry, height, is_circular, radius, cog, mass, moi FROM object_actuator_geometry WHERE object_actuator_geometry_id = %d', object_geometry_id));

objGeometry = PostgresqlToMatlabArray(cell2mat(data(1)));
objHeight = cell2mat(data(2));
is_circular = cell2mat(data(3));
if is_circular
    objRadius = cell2mat(data(4));
else
    objRadius = 0;
end
objCoG = PostgresqlToMatlabArray(cell2mat(data(5)));
objMass = cell2mat(data(6));
objMOI = cell2mat(data(7));

actGeometry = PostgresqlToMatlabArray(cell2mat(fetch(dbConn, sprintf('SELECT geometry FROM object_actuator_geometry WHERE object_actuator_geometry_id = %d', actuator_geometry_id))));
actHeight = cell2mat(fetch(dbConn, sprintf('SELECT height FROM object_actuator_geometry WHERE object_actuator_geometry_id = %d', actuator_geometry_id)));

% Get the remaining experiment data from the database.
data = fetch(dbConn, strcat('SELECT final_contact_mode, effective_start_time, effective_end_time, fixel_1_position,',...
                            'fixel_2_position, fixel_3_position,actuator_initial_position,object_position,object_rotation,',...
                            'actuator_position, actuator_velocity, actuator_rotation,has_tactile_sensor,',...
                            'has_synthetic_tactile_sensor, tactile_sensor_reads,synthetic_tactile_sensor_reads,',...
                            'object_initial_position,object_initial_rotation, frametimes, actuator_marker_position,',...
                            'object_marker_1_position, object_marker_2_position',...
                            ' FROM experiment WHERE experiment_id = ', sprintf('%d', expID)));


expFinalContactMode = cell2mat(data(1));
STARTID = cell2mat(data(2));
ENDID = cell2mat(data(3));
rPegsCenter(1,:) = PostgresqlToMatlabArray(cell2mat(data(4)));
rPegsCenter(2,:) = PostgresqlToMatlabArray(cell2mat(data(5)));
rPegsCenter(3,:) = PostgresqlToMatlabArray(cell2mat(data(6)));
actuatorStart = PostgresqlToMatlabArray(cell2mat(data(7)));
rObCenter = PostgresqlToMatlabArray(cell2mat(data(8)));
rObOrient = PostgresqlToMatlabArray(cell2mat(data(9)));
rGreenCenter = PostgresqlToMatlabArray(cell2mat(data(20)));
rGreenCenterF = PostgresqlToMatlabArray(cell2mat(data(10)));
rGreenSpeed = cell2mat(data(11));
rGreenOrient = cell2mat(data(12));
hasTactile = cell2mat(data(13));
hasSynTactile = cell2mat(data(14));
tactileSensorReads = PostgresqlToMatlabArray(cell2mat(data(15)));
synTactileReads = PostgresqlToMatlabArray(cell2mat(data(16)));
% Initial position and rotation can also be found in rObCenter(STARTID,:)
% and rObOrient(STARTID,:)
object_initial_position = PostgresqlToMatlabArray(cell2mat(data(17)));
object_initial_rotation = cell2mat(data(18));
TIMES = PostgresqlToMatlabArray(cell2mat(data(19)));
rRedCenter = PostgresqlToMatlabArray(cell2mat(data(21)));
rBlueCenter = PostgresqlToMatlabArray(cell2mat(data(22)));
close(dbConn);
clear dbConn;
clear c;
clear data;

%javarmpath('postgresql-8.4-702.jdbc4.jar')

%fprintf('Video data imported\n');
