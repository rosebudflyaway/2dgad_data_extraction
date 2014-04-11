function Create_Experiment_DAT_File( experiment_id )
% This function will create a .DAT file that contains all of the experiment 
% trajectory data based upon the data interpolated from
% the video and uploaded into the GAD2D database

%%%%%%%%%%%%%%%%%%%%%%%%%%%%PSEUDOCODE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. Retreive raw experiment data from database
% 2. Isolate necessary data structures: ID, obj_x, obj_y, obj_z, obj_orient, act_x, act_y, act_z 
% 3. Create .DAT file

% Initialize database connection
dbConn = database('2DGAD','robotics','sensornet','org.postgresql.Driver','jdbc:postgresql://grasp.robotics.cs.rpi.edu/');

% Filename that we will write to
file_name = strcat(strcat('experiment1_', num2str(experiment_id)), '.dat');

% Open file
file = fopen(file_name, 'w'); 

% check that we're connected
if(~isconnection(dbConn))
    error('Connection Error\n%s', dbConn.Message);
end

query_prefix = 'SELECT actuator_initial_position, object_position,';
query_prefix = strcat(query_prefix, 'object_rotation, actuator_position, actuator_rotation FROM experiment');
query_prefix = strcat(query_prefix, ' WHERE experiment_id = ');
query_prefix = strcat(query_prefix, int2str(experiment_id));

% This query will retrieve all necessary info from the "experiments" table
cursor = exec(dbConn, query_prefix);
fetcheddata = fetch(cursor, 1);
data = fetcheddata.data;

% Now we have the data, lets put them into a cell array so that we can create a
% CSV from it

object_position = PostgresqlToMatlabArray(cell2mat(data(2)));
obj_orient = PostgresqlToMatlabArray(cell2mat(data(3)));
actuator_position = PostgresqlToMatlabArray(cell2mat(data(4)));

% Create array of exp id's for proper concatentation
exp_id_vector = ones(length(object_position), 1)*experiment_id;

% Place data into matrix
formatted_data = [exp_id_vector object_position obj_orient actuator_position];

length_string = int2str(length(object_position));
length_string = strcat(length_string, '\n');

% Write number of frames to file
fprintf(file, length_string);

fclose(file);

% Now write data to file
cell2csv(file_name, num2cell(formatted_data), ',');

end

