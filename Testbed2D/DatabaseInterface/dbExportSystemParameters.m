% Exports the system parameters to the database

% Gets the system parametrs from the user and exports them to the database.
% system_parameter_id is changed to the current system_parameter_id in the
% database.  It is not changed if there was an error during export.

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

% Get the system parameters  
systemParametersData.rtri = str2double(input('Enter the radius of support triangle: ','s'));    
if(isnan(systemParametersData.rtri))
    fprintf('Invalid Input.  Exiting now')
    return
end
systemParametersData.up = str2double(input('Enter the friction between the block and pusher (Up): ','s'));
if(isnan(systemParametersData.up))
    fprintf('Invalid Input.  Exiting now')
    return
end
systemParametersData.us = str2double(input('Enter the friction between the block and surface (Us): ','s'));
if(isnan(systemParametersData.us))
    fprintf('Invalid Input.  Exiting now')
    return
end
systemParametersData.uf = str2double(input('Enter the friction between the block and fixels (Uf): ','s'));
if(isnan(systemParametersData.uf))
    fprintf('Invalid Input.  Exiting now')
    return
end

% Begin export of system parameters
fprintf('Exporting System Parameters ...\n');

systemParametersFields = {'rtri','up','us','uf'};

% Perfom insert to add system parameters to database
insert(dbConn, 'system_parameters', systemParametersFields, systemParametersData);

% Get the system parameters id to return
system_parameter_id = cell2mat(fetch(dbConn, 'SELECT max(system_parameter_id) FROM system_parameters;'));

% finished, commit our changes
commit(dbConn);

close(dbConn);
clear dbConn;
clear c;
clear systemParametersData;
clear systemParametersFields;

%javarmpath('postgresql-8.4-702.jdbc4.jar')

% Export of system parameters completed
fprintf('Exporting System Parameters Completed\n');