% Exports the object geometry to the database

% Exports the geometry in objGeometry to the database as object geometry.
% The user is asked for the height.  object_geometry_id is changed to the
% current object_geometry_id in the database.  It is not changed if there
% was a failure during export.

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

%height = str2double(input('Input object height: ','s'));

% Begin export of geometry
fprintf('Exporting object geometry ...\n');

geometryData.is_object = 1;

if ~is_circular
    geometryData.geometry = MatlabToPostgresqlArray( objGeometry );
else
    vN = 40;
    objGeometry = zeros(vN, 2);
    for i = 1:vN
        x = objRadius * cos(-2*pi/vN*i);
        y = objRadius * sin(-2*pi/vN*i);
        objGeometry(i, :) = [x, y];
    end
    geometryData.geometry = MatlabToPostgresqlArray( objGeometry );
end
geometryData.height = objHeight;
geometryData.is_circular = is_circular;
if is_circular
    geometryData.radius = objRadius;
else
    geometryData.radius = 0;
end
geometryData.cog = MatlabToPostgresqlArray(cog);
geometryData.mass = objMass;
geometryData.moi = objMOI;
geometryFields = {'is_object','geometry','height', 'is_circular', 'radius', 'cog', 'mass', 'moi'};


% Perform insert to add the geometry to the database
insert(dbConn, 'object_actuator_geometry',geometryFields, geometryData);

% Get the geometry id to return
object_geometry_id = cell2mat(fetch(dbConn, 'SELECT max(object_actuator_geometry_id) FROM object_actuator_geometry WHERE is_object = 1;'));

% finished, commit our changes
commit(dbConn);

close(dbConn);
clear dbConn;
clear c;
clear geometryData;
clear geometryFields;
clear height;

% Export of geometry is complete
fprintf('Exporting geometry completed\n');


%javarmpath('postgresql-8.4-702.jdbc4.jar')
