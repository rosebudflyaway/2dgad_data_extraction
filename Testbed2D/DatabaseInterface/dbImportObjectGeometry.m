% Imports an object geometry

% object_geometry_id must be defined and valid the database
% Puts data in objGeometry and objHeight

% Test to make sure the experiment ID is defined
if(exist('object_geometry_id', 'var') == 0)
    fprintf('"object_geometry_id" does not exist.  Please specify an object geometry ID. Exiting Now.\n');
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


isObject = cell2mat(fetch(dbConn, sprintf('SELECT is_object FROM object_actuator_geometry WHERE object_actuator_geometry_id = %d', object_geometry_id)));
if(isObject ~= 1)
    fprintf('The given "object_geometry_id" represents an actuator geometry, not an object geometry. Exiting Now.\n');
    close(dbConn);
    clear dbConn;
    clear c;
    return;
end

data = fetch(dbConn, sprintf('SELECT geometry, height, is_circular, radius, cog, mass, moi FROM object_actuator_geometry WHERE object_actuator_geometry_id = %d', object_geometry_id));

objGeometry = PostgresqlToMatlabArray(cell2mat(data(1)));
objHeight = cell2mat(data(2));
is_circular = cell2mat(data(3));
if is_circular
    objRadius = cell2mat(data(4));
end
objCoG = PostgresqlToMatlabArray(cell2mat(data(5)));
objMass = cell2mat(data(6));
objMOI = cell2mat(data(7));

close(dbConn);
clear dbConn;
clear c;


%javarmpath('postgresql-8.4-702.jdbc4.jar')

fprintf('Object geometry data imported\n');