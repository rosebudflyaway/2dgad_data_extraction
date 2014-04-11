% Imports filter parameters from the database

% Imports the filter parameters given the filter_parameter_ID.  Puts data
% in 'is_particle_filter' and 'parameters'

% Test to make sure 'filter_parameter_ID' exists
if(exist('filter_parameter_ID', 'var') == 0)
    fprintf('"filter_parameter_ID" does not exist.  Please specify a filter parameter ID. Exiting Now.\n');
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

fprintf('Importing filter parameters ...\n');

data = fetch(dbConn, sprintf('SELECT parameters, is_particle_filter FROM filter_parameters WHERE filter_parameter_id = %d',filter_parameter_ID));

parameters = PostgresqlToMatlabArray(cell2mat(data(1)));
is_particle_filter = cell2mat(data(2));

close(dbConn);
clear dbConn;
clear data;
clear c;

%javarmpath('postgresql-8.4-702.jdbc4.jar')

fprintf('Filter parameters imported\n');
