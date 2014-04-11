% Imports System parameters from the database.

% 'system_parameter_ID' must be defined and be valid in the database.  Puts
% data in the 'systemParameters' struct with with labels of
% 'Rtri','Up','Us','Uf'

% Tests to make 'sure system_parameter_ID' exists
if(exist('system_parameter_ID', 'var') == 0)
    fprintf('"system_parameter_ID" does not exist.  Please specify a system parameter ID. Exiting Now.\n');
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

fprintf('Importing system parameters ...\n');

data = fetch(dbConn, sprintf('SELECT rtri, up, us, uf FROM system_parameters WHERE system_parameter_id = %d',system_parameter_ID));

% Where should these parameters go?
systemParameters.Rtri = cell2mat(data(1));
systemParameters.Up   = cell2mat(data(2));
systemParameters.Us   = cell2mat(data(3));
systemParameters.Uf   = cell2mat(data(4));

close(dbConn);
clear dbConn;
clear data;
clear c;

%javarmpath('postgresql-8.4-702.jdbc4.jar')

fprintf('System parameters imported\n');
