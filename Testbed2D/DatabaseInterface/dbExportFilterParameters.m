% Exports the filter parameters to the database

%   Gets the parameters to define a filter (If it is a particle filter and
%   the 12 parameters) from the user, then exports the data to the
%   database.  filter_parameter_id will be changed to hold the id of the
%   filter just exported.  It will not be changed if there was a failure.

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

% Get input form user    
is_particle_filter = upper(input('Is the filter a particle filter? [Y/N] ','s'));
if(is_particle_filter == 'Y')
    filterData.is_particle_filter = 1;
elseif(is_particle_filter == 'N')
    filterData.is_particle_filter = 0;
else
    fprintf('\nInvalid input.  Must enter only either "Y" or "N"');
    return;
end

% Get the 12 filter parameters from the user
for i=1:12
    filterData.parameters(i) = str2double(input(sprintf('Enter parameter %d: ', i),'s'));
    if(isnan(filterData.parameters(i)))
        fprintf('\nInvalid Input.  Exiting now.\n');
        return;
    end
end
filterData.parameters = MatlabToPostgresqlArray(filterData.parameters);
filter_parameters = filterData.parameters;

% Begin export of filter parameters
fprintf('Exporting Filter Parameters\n');

filterFields = {'is_particle_filter','parameters'};

% Perform the insert into the database
insert(dbConn, 'filter_parameters', filterFields, filterData);

% Get the id of the filter we just inserted
filter_parameter_id = cell2mat(fetch(dbConn, 'SELECT max(filter_parameter_id) FROM filter_parameters;'));

% finished, commit our changes
commit(dbConn);

close(dbConn);
clear dbConn;
clear c;
clear filterData;
clear filterFields;

%javarmpath('postgresql-8.4-702.jdbc4.jar')

% Export of filter is completed
fprintf('Filter Parameters Exported\n');