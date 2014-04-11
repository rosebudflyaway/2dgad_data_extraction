function Create_Actuator_Velocity_DAT_File( experiment_id )
% This function will create a dat file that describes the motion of the
% actuator for DVC

% Initialize database connection
dbConn = database('2DGAD','robotics','sensornet','org.postgresql.Driver','jdbc:postgresql://grasp.robotics.cs.rpi.edu/');

% Filename that we will write to
file_name = strcat('actuator_speed_', num2str(experiment_id));

% Open file
file = fopen(file_name, 'w');

% Check that we're connected
if(~isconnection(dbConn))
    error('Connection Error\n%s', dbConn.Message);
end

%Old query
%query = strcat('SELECT actuator_rotation, actuator_velocity FROM experiment WHERE experiment_id = ', num2str(experiment_id));

%New query
query = strcat('SELECT actuator_rotation, actuator_velocity, actuator_position, ',...
    'final_contact_mode, effective_start_time, effective_end_time ',...
    ' FROM experiment WHERE experiment_id = ', num2str(experiment_id));

% This query will retrieve all necessary info from the "experiments" table
cursor = exec(dbConn, query);
fetcheddata = fetch(cursor, 1);
data = fetcheddata.data;

%Get cell arrays of experimental objects
actuator_angle_in_radians = data(1);
actuator_velocity = data(2);
actuator_position = data(3);
final_contact_mode = data(4);
start_time = data(5);
end_time = data(6);

%Get actual values
actuator_angle_in_radians = actuator_angle_in_radians{1};
actuator_velocity = actuator_velocity{1};
start_time = start_time{1};
final_contact_mode = final_contact_mode{1};
end_time = end_time{1};
actuator_position = PostgresqlToMatlabArray(actuator_position{1});
actuator_final_position = actuator_position(end_time, :);
actuator_initial_position = actuator_position(start_time, :);

%actuator distance traveled (euclidean distance)
actuator_length_limit = sqrt(...
    (actuator_initial_position(1) - actuator_final_position(1))^2 + ...
    (actuator_initial_position(2) - actuator_final_position(2))^2 +...
    (actuator_initial_position(3) - actuator_final_position(3))^2);
%Convert byte representation of fixel contact modes to number of fixel
%touching object at end of experiment.

%Byte representation to actuator config file representation
%--------------------------------------------------------------
%0 corresponds to 0 fixels touching object
%1,2,4 correspond to 1 fixel touching object
%3, 5, 6 corresponds to 2 fixels touching object
%7 corresponds to 3 fixels touching object
%--------------------------------------------------------------

dvc_final_contact_mode = -1;

switch final_contact_mode
    case 0
        dvc_final_contact_mode = 0;
    case 1
        dvc_final_contact_mode = 1;
    case 2
        dvc_final_contact_mode = 1;
    case 3
        dvc_final_contact_mode = 2;
    case 4
        dvc_final_contact_mode = 1;
    case 5
        dvc_final_contact_mode = 2;
    case 6
        dvc_final_contact_mode = 2;
    case 7
        dvc_final_contact_mode = 3;
        
end

%%%%%%%%%%%% Unused %%%%%%%%%%%%%%%%%%%%%
%actuator_angle_in_degrees = actuator_angle_in_radians*(180/pi);

%y_velocity = sin(actuator_angle_in_radians)*actuator_velocity;
%x_velocity = cos(actuator_angle_in_radians)*actuator_velocity;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Template for actuator config file is:

%1. Actuator speed magnitude
%2. Actuator orientation in radians
%3. Actuator limit length (final position - initial position)
%4. Number of fixels in contact with the object at the end of the
%experiment

%1. 
fprintf(file, strcat(num2str(actuator_velocity), '\n'));
%2. 
fprintf(file, strcat(num2str(actuator_angle_in_radians), '\n'));
%3. 
fprintf(file, strcat(num2str(actuator_length_limit), '\n'));
%4
fprintf(file, num2str(dvc_final_contact_mode));

fclose(file);

end

