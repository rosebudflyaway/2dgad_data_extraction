function Create_Scene_XML_File( experiment_id )
% This function will generate an XML file that can be used by dakota/emma's
% bash script for calibration purposes

% Initialize database connection
dbConn = database('2DGAD','robotics','sensornet','org.postgresql.Driver','jdbc:postgresql://grasp.robotics.cs.rpi.edu/');

% Queries
fixel1_query = strcat('SELECT fixel_1_position FROM experiment WHERE experiment_id = ', int2str(experiment_id));
fixel2_query = strcat('SELECT fixel_2_position FROM experiment WHERE experiment_id = ', int2str(experiment_id));
fixel3_query = strcat('SELECT fixel_3_position FROM experiment WHERE experiment_id = ', int2str(experiment_id));
shape_position_query = strcat('SELECT object_initial_position FROM experiment WHERE experiment_id = ', int2str(experiment_id));
shape_orientation_query = strcat('SELECT object_initial_rotation FROM experiment WHERE experiment_id = ', int2str(experiment_id));
actuator_position_query = strcat('SELECT actuator_initial_position FROM experiment WHERE experiment_id = ', int2str(experiment_id));
actuator_orientation_query = strcat('SELECT actuator_rotation FROM experiment WHERE experiment_id = ', int2str(experiment_id));

% Query database to retrieve initial position of geometrical objects
% fixel1 initial position
fixel_1_cursor = exec(dbConn, fixel1_query);
fixel_1_fetched = fetch(fixel_1_cursor, 1);
fixel1_initial_data = fixel_1_fetched.data;

% fixel2 initial position
fixel_2_cursor = exec(dbConn, fixel2_query);
fixel_2_fetched = fetch(fixel_2_cursor, 1);
fixel2_initial_data = fixel_2_fetched.data;

% fixel3 initial position
fixel_3_cursor = exec(dbConn, fixel3_query);
fixel_3_fetched = fetch(fixel_3_cursor, 1);
fixel3_initial_data = fixel_3_fetched.data;

% shape initial position
shape_position_cursor = exec(dbConn, shape_position_query);
shape_position_fetched = fetch(shape_position_cursor, 1);
shape_initial_position_data = shape_position_fetched.data;

% shape initial rotation
shape_orientation_cursor = exec(dbConn, shape_orientation_query);
shape_orientation_fetched = fetch(shape_orientation_cursor, 1);
shape_initial_rotation_data = shape_orientation_fetched.data;

% actuator initial position
actuator_position_cursor = exec(dbConn, actuator_position_query);
actuator_position_fetched = fetch(actuator_position_cursor, 1);
actuator_position_initial_data = actuator_position_fetched.data;

%actuator initial orientation
actuator_orientation_cursor = exec(dbConn, actuator_orientation_query);
actuator_orientation_fetched = fetch(actuator_orientation_cursor, 1);
actuator_orientation_initial_data = actuator_orientation_fetched.data;

% Now take the java objects and convert them to matlab objects
fixel1_initial = PostgresqlToMatlabArray(cell2mat(fixel1_initial_data(1)));
fixel2_initial = PostgresqlToMatlabArray(cell2mat(fixel2_initial_data(1)));
fixel3_initial = PostgresqlToMatlabArray(cell2mat(fixel3_initial_data(1)));
shape_initial_position = PostgresqlToMatlabArray(cell2mat(shape_initial_position_data(1)));
shape_initial_orientation = cell2mat(shape_initial_rotation_data(1));
actuator_position_initial = PostgresqlToMatlabArray(cell2mat(actuator_position_initial_data(1)));
actuator_orientation_initial = cell2mat(actuator_orientation_initial_data(1));

% Load xml template for DVC2D scene
template_filename = 'scene_template.xml';
template = xmlread(template_filename);

% Retrieve the "geometry" node
geometry_node = Retrieve_Geometry_Node(template);

% Get Fixel1 node
fixel1_node = Get_Child_Node_With_Attribute(geometry_node, 'name="fixel1"');

% Get Fixel2 node
fixel2_node = Get_Child_Node_With_Attribute(geometry_node, 'name="fixel2"');

% Get Fixel3 node
fixel3_node = Get_Child_Node_With_Attribute(geometry_node, 'name="fixel3"');

% Get Shape node
shape_node = Get_Child_Node_With_Attribute(geometry_node, 'name="shape"');

% Get Actuator node
actuator_node = Get_Child_Node_With_Attribute(geometry_node, 'name="actuator"');

%Set shape matrix
shape_initial(1) = shape_initial_position(1);
shape_initial(2) = shape_initial_position(2);
shape_initial(3) = shape_initial_orientation(1);

%Set actuator matrix
actuator_initial(1) = actuator_position_initial(1);
actuator_initial(2) = actuator_position_initial(2);
actuator_initial(3) = actuator_orientation_intial(1);

% Set "initialPosition" preferences using helper function
SetInitialPosition(fixel1_node, fixel1_initial);
SetInitialPosition(fixel2_node, fixel2_initial);
SetInitialPosition(fixel3_node, fixel3_initial);
SetInitialPosition(shape_node, shape_initial);
SetInitialPosition(actuator_node, actuator_initial);

% Save our changes
xmlwrite(strcat(strcat('dakota_prefs_', num2str(experiment_id)), '.xml'), template);

end

function child_node = Get_Child_Node_With_Attribute(parent_node, attribute)

    children = parent_node.getChildNodes();

    for c=0:children.getLength() - 1
        
        if children.item(c).hasAttributes()
            
            attributes_of_child_node = children.item(c).getAttributes();
            
            for d=0:attributes_of_child_node.getLength() - 1
                if attributes_of_child_node.item(d) == attribute
                    child_node = children.item(c);
                end
            end
            
        end
    end

end

% Helper function to set initial position of objects in scene
function SetInitialPosition(geometric_object_node, initial_position)  
    
    % Get "initialPosition" node
    initialPosition_node = Get_Child_Node_With_Attribute(geometric_object_node, 'name="initialPosition"');
    
    %Get x, y, theta children of this node  
    initial_x_position_node = Get_Child_Node_With_Attribute(initialPosition_node, 'name="x"');
    initial_y_position_node = Get_Child_Node_With_Attribute(initialPosition_node, 'name="y"');
    initial_theta_position_node = Get_Child_Node_With_Attribute(initialPosition_node, 'name="t"');
    
    % Get the attributes for each x, y, theta nodes
    initial_x_position_attributes = initial_x_position_node.getAttributes();
    initial_y_position_attributes = initial_y_position_node.getAttributes();
    initial_theta_position_attributes = initial_theta_position_node.getAttributes();
    
    % Prepare the strings for updating the XML document
    new_x_val = num2str(initial_position(1));%sprintf('value="%f"', initial_position(1));
    new_y_val = num2str(initial_position(2));%sprintf('value="%f"', initial_position(2));
    new_theta_val = num2str(initial_position(3));%sprintf('value="%f"', initial_position(3));
    
    % Get the values in the XML document
    x_value = initial_x_position_attributes.item(2);
    y_value = initial_y_position_attributes.item(2);
    theta_val = initial_theta_position_attributes.item(2);
    
    % Set the position values
    x_value.setNodeValue(new_x_val);
    y_value.setNodeValue(new_y_val);
    theta_val.setNodeValue(new_theta_val);
end

% Helper function to retrieve Geometry node
function [geometry_node] = Retrieve_Geometry_Node(template)

%This will get all the nodes in the template xml file
nodelist = template.getElementsByTagName('pref');

    %This will iterate over all the nodes until it reads a node that is
    %"Geometry"
    for i=0:nodelist.getLength() - 1
        attribute_list = nodelist.item(i).getAttributes();
        
        for j = 0:attribute_list.getLength() - 1
            % Check to see if we've found geometry
            if strcmp(attribute_list.item(j), 'name="geometry"')
                % If we've found geometry, get all the children. All of the
                % direct children represent all of the geometrical objects
                % in the scene. This is what we must return.
                
                geometry_node = nodelist.item(i);
            end
        end
    end
end