function [fObCenter fObOrient useTactile isOcclude occludeRange fContactMode ...
          system_parameter_ID filter_parameter_ID] = dbImportKalmanFilterFunction(filter_ID)
% This script imports filtering data into the Matlab workspace

% 'filter_id' must be defined and must be valid in the database.  Puts data in
% 'expIDLoaded', 'system_parameter_ID','filter_parameter_ID', 'occludeRange', 'paramax', 'fObCenter','fObOrient','Phat',
% 'isOcclude'

% Test to make sure 'filter_id' exists
if(exist('filter_ID', 'var') == 0)
    fprintf('"filter_ID" does not exist.  Please specify an filter ID. Exiting Now.\n');
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

%fprintf('Importing filter data ...\n');

data = fetch(dbConn, sprintf('SELECT experiment_id, system_parameter_id, filter_parameter_id, occlusion_start_time, occlusion_end_time, object_position, object_rotation, has_occlusion, use_tactile, final_contact_mode FROM filtering WHERE filter_id = %d', filter_ID));

expIDLoaded = cell2mat(data(1));
system_parameter_ID = cell2mat(data(2));
filter_parameter_ID = cell2mat(data(3));
occludeRange(1) = cell2mat(data(4));
occludeRange(2) = cell2mat(data(5));
fObCenter = PostgresqlToMatlabArray(cell2mat(data(6)))';
fObOrient = PostgresqlToMatlabArray(cell2mat(data(7)))';
isOcclude = cell2mat(data(8));
useTactile = cell2mat(data(9));
fContactMode = cell2mat(data(10));

close(dbConn);

clear data;
clear dbConn;
clear c;

% %javarmpath('postgresql-8.4-702.jdbc4.jar')

%fprintf('Filtering data imported\n');

if exist('expID', 'var') && expID ~= expIDLoaded 
    error('loaded filtering result doesnt correspond to the same experiment');
end

end
