function Query_Tactile_Sensor_Callback( camera_obj, event, arduino_object )

    global tactileBytes

    % Calculate size of cell array
    array_length = length(tactileBytes);

    tactileBytes{array_length + 1} = Query_Tactile_Sensor(arduino_object);

end

