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
%fprintf('Querying filter ids ...\n');

filter_ID1 = cell2mat(fetch(dbConn, ['SELECT filter_id FROM filtering WHERE experiment_id = ' num2str(expID) ...
     ' AND has_occlusion = 0'  ...
     ' AND use_tactile = 1' ...
     ' AND filter_parameter_id = 3 ;']));
 filter_ID2 = cell2mat(fetch(dbConn, ['SELECT filter_id FROM filtering WHERE experiment_id = ' num2str(expID) ...
     ' AND has_occlusion = 1'  ...
     ' AND use_tactile = 1' ...
     ' AND filter_parameter_id = 3 ;']));
 filter_ID3 = cell2mat(fetch(dbConn, ['SELECT filter_id FROM filtering WHERE experiment_id = ' num2str(expID) ...
     ' AND has_occlusion = 1'  ...
     ' AND use_tactile = 0' ...
     ' AND filter_parameter_id = 3 ;']));
 filter_ID4 = cell2mat(fetch(dbConn, ['SELECT filter_id FROM filtering WHERE experiment_id = ' num2str(expID) ...
     ' AND has_occlusion = 1'  ...
     ' AND use_tactile = 0' ...
     ' AND filter_parameter_id = 4 ;']));
   
if isempty(filter_ID1) && isempty(filter_ID2) && isempty(filter_ID3) && isempty(filter_ID4)
    fprintf('no filter result exists for this experiment yet\n');
end

% finished, commit our changes
commit(dbConn);

