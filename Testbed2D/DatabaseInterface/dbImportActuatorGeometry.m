% Imports an actuator geometry

% actuator_geometry_id must be defined and valid the database
% Puts data in actGeometry and actHeight

% Test to make sure the experiment ID is defined
if(exist('actuator_geometry_id', 'var') == 0)
    fprintf('"actuator_geometry_id" does not exist.  Please specify an actuator geometry ID. Exiting Now.\n');
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

isObject = cell2mat(fetch(dbConn, sprintf('SELECT is_object FROM object_actuator_geometry WHERE object_actuator_geometry_id = %d', actuator_geometry_id)));
if(isObject ~= 0)
    fprintf('The given "actuator_geometry_id" represents an object geometry, not an actuator geometry. Exiting Now.\n');
    close(dbConn);
    clear dbConn;
    clear c;
    return;
end

actGeometry = PostgresqlToMatlabArray(cell2mat(fetch(dbConn, sprintf('SELECT geometry FROM object_actuator_geometry WHERE object_actuator_geometry_id = %d', actuator_geometry_id))));
actHeight = cell2mat(fetch(dbConn, sprintf('SELECT height FROM object_actuator_geometry WHERE object_actuator_geometry_id = %d', actuator_geometry_id)));

close(dbConn);
clear dbConn;
clear c;


%javarmpath('postgresql-8.4-702.jdbc4.jar')

fprintf('Actuator geometry data imported\n');