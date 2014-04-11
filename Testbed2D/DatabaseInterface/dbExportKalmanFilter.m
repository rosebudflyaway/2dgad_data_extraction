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

% Start export of filtering data
fprintf('Exporting Kalman Filtering Data\n');

filter_id = cell2mat(fetch(dbConn, ['SELECT filter_id FROM filtering WHERE experiment_id = ' num2str(expID) ...
     ' AND system_parameter_id = ' num2str(system_parameter_ID) ... 
     ' AND has_occlusion = ' num2str(isOcclude) ...
     ' AND use_tactile = 0'  ...
     ' AND filter_parameter_id = 4 ;']));
  
if isempty(filter_id)
    % Load the struct with the proper data
    filterData.experiment_id = expID;
    filterData.filter_parameter_id = 4;
    filterData.final_contact_mode = fContactMode;
    filterData.system_parameter_id = system_parameter_ID;
    filterData.has_occlusion = isOcclude;
    if ~isOcclude
        filterData.occlusion_start_time = 0;
        filterData.occlusion_end_time = 0;
    else
        filterData.occlusion_start_time = occludeRange(1);
        filterData.occlusion_end_time = occludeRange(2);
    end
    filterData.use_tactile = 0;
    
    filterData.object_position = MatlabToPostgresqlArray(fObCenter);
    filterData.object_rotation = MatlabToPostgresqlArray(fObOrient);
    
    
    filterFields = {'experiment_id','filter_parameter_id', 'final_contact_mode', 'system_parameter_id', 'has_occlusion','occlusion_start_time','occlusion_end_time', 'use_tactile', 'object_position','object_rotation'};
    
    % Perform the insert for the filter
    insert(dbConn, 'filtering',filterFields,filterData);
    
    % Get the id number of the filter we just inserted
    filter_id = cell2mat(fetch(dbConn, 'SELECT max(filter_id) FROM filtering;'));
    
    % Finished exporting the filtering data
    fprintf('Filtering data exported\n');
else
    warning('The filtering already exists in the database, overwriting it ...');
    fprintf('Filtering result ID is %d \n', filter_id);
    
    filterData.final_contact_mode = fContactMode;
    filterData.has_occlusion = isOcclude;
    if ~isOcclude
        filterData.occlusion_start_time = 0;
        filterData.occlusion_end_time = 0;
    else
        filterData.occlusion_start_time = occludeRange(1);
        filterData.occlusion_end_time = occludeRange(2);
    end
    filterData.use_tactile = 0;
    filterData.object_position = MatlabToPostgresqlArray(fObCenter);
    filterData.object_rotation = MatlabToPostgresqlArray(fObOrient);
    
    filterFields = {'final_contact_mode','has_occlusion','occlusion_start_time','occlusion_end_time', 'use_tactile', 'object_position','object_rotation'};
   
    % Generate the clause that will give us the one experiment
    whereClause = sprintf('WHERE filter_id = %d', filter_id);
    % Perform the update operation to overwrite the data to the 'filtering'
    % table
    update(dbConn, 'filtering', filterFields, filterData, whereClause);
    % finished, commit our changes
    commit(dbConn);
    % Exporting of simulation data is finished
    fprintf('Filtering Data Overwritten\n');
    
end

filter_id

% finished, commit our changes
commit(dbConn);

