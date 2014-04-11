% Exports simulation data to the database

% Exports the object position and rotation trajectories as well as the
% final contact mode of the simulation.  simulation_id is changed to the
% inserted id.  It is not changed if there was a failure during export


% connect using JDBC (faster than ODBC :-D)
% a matlab bug causes all global variables to be cleared
% from the workspace when calling javaaddpath
%javaaddpath('postgresql-8.4-702.jdbc4.jar');
databaseConfig; 
dbConn = database(dbName, userName, passwd, driverName, host);
setdbprefs('DefaultRowPrefetch', '10');

% check that we're connected
if(~isconnection(dbConn))
    error('Connection Error\n%s', dbConn.Message);
end

% if something screws up, close the connection and rollback if necessary
c = onCleanup(@()dbCleanupGracefully(dbConn));

% set AutoCommit to off, so that no bad data goes in the database if
% the function fails for whatever reason
set(dbConn,'AutoCommit','off');

% Start export of simulation data
fprintf('Exporting Simulation Data\n');

simulation_id = cell2mat(fetch(dbConn, ['SELECT simulation_id FROM simulation WHERE experiment_id = ' num2str(expID) ' AND system_parameter_id = ' num2str(system_parameter_ID) ';']));


simulationFields = {'experiment_id','system_parameter_id','object_position', 'object_rotation', 'final_contact_mode', 'actuator_position'};

if isempty(simulation_id)
    % Load the struct with the data to export
    simulationData.experiment_id = expID;
    simulationData.system_parameter_id = system_parameter_ID;
    simulationData.object_position = MatlabToPostgresqlArray(sObCenter);
    simulationData.object_rotation = MatlabToPostgresqlArray(sObOrient);
    simulationData.final_contact_mode = sContactMode;
    simulationData.actuator_position = MatlabToPostgresqlArray(sGreenCenter);
    
    simulationFields = {'experiment_id','system_parameter_id','object_position', 'object_rotation', 'final_contact_mode', 'actuator_position'};

    % Perform the insert into the database
    insert(dbConn, 'simulation', simulationFields, simulationData);
    % Get the simulation id of the information we just inserted
    simulation_id = cell2mat(fetch(dbConn, 'SELECT max(simulation_id) FROM simulation;'));
    fprintf('Simulation id: %d\n', simulation_id );
    % finished, commit our changes
    commit(dbConn);
    % Exporting of simulation data is finished
    fprintf('Simulation Data Exported\n');
else
    warning('The simulation already exists in the database, overwriting it ...');
    
    fprintf('Simulation ID is %d \n', simulation_id);
     % Load the struct with the data to export
    simulationData.object_position = MatlabToPostgresqlArray(sObCenter);
    simulationData.object_rotation = MatlabToPostgresqlArray(sObOrient);
    simulationData.final_contact_mode = sContactMode;
    simulationData.actuator_position = MatlabToPostgresqlArray(sGreenCenter);
    
    simulationFields = {'object_position', 'object_rotation', 'final_contact_mode', 'actuator_position'};
 
    % Generate the clause that will give us the one experiment
    whereClause = sprintf('WHERE simulation_id = %d', simulation_id);
    % Perform the update operation to overwrite the data to the 'simulation'
    % table
    % simulationData = struct2cell(simulationData);
    
    %size(simulationData.object_position) 
    %size(simulationData.object_rotation)
    %size(simulationData.final_contact_mode)
    %size(simulationData.actuator_position) 
    %pause
    
    simulationDataAsCell = {simulationData.object_position, simulationData.object_rotation, ...
                            simulationData.final_contact_mode, simulationData.actuator_position};
    setdbprefs('DefaultRowPrefetch', '10');                    
    update(dbConn, 'simulation', simulationFields, simulationDataAsCell, whereClause);
    %update(dbConn, 'simulation', simulationFields, simulationData, whereClause);

    % finished, commit our changes
    commit(dbConn);
    % Exporting of simulation data is finished
    fprintf('Simulation Data Overwritten\n');
end

close(dbConn);
clear dbConn;
clear c;
clear simulationData;
clear simulationFields;

%javarmpath('postgresql-8.4-702.jdbc4.jar')

