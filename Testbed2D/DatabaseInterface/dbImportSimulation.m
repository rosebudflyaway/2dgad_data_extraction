% This script imports simulation data into the Matlab workspace

% 'simID' must be defined and must be valid in the database.  Puts data in
% 'experiment_ID', 'system_parameter_ID','sObCenter','sObOrient','sContactMode',
% 'sGreenCenter'

% Test to make sure 'simID' exists
if(exist('simID', 'var') == 0)
    fprintf('"simID" does not exist.  Please specify an simulation ID. Exiting Now.\n');
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

%fprintf('Importing simulation data ...\n');

data = fetch(dbConn, sprintf('SELECT experiment_ID, system_parameter_id, object_position, object_rotation, final_contact_mode, actuator_position FROM simulation WHERE simulation_ID = %d', simID));

expIDLoaded = cell2mat(data(1));
system_parameter_ID = cell2mat(data(2));
sObCenter = PostgresqlToMatlabArray(cell2mat(data(3)));
sObOrient = PostgresqlToMatlabArray(cell2mat(data(4)));
sContactMode = cell2mat(data(5));
sGreenCenter = PostgresqlToMatlabArray(cell2mat(data(6)));

close(dbConn);

clear data;
clear dbConn;
clear c;

% %javarmpath('postgresql-8.4-702.jdbc4.jar')

%fprintf('Simulation data imported\n');

if exist('expID', 'var') && expID ~= expIDLoaded 
    error('loaded simulation doesnt correspond to the same experiment');
end
