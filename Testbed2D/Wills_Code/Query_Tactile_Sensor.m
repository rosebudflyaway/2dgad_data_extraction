function tactile_byte = Query_Tactile_Sensor(arduino_object)
% This function will query the arduino to determie binary contact data

    threshold = 900;
    tactile_byte = 0;
    
    red_pin = 0;
    green_pin = 1;
    blue_pin = 2;

    red_pin_val = arduino_object.analogRead(red_pin);
    %fprintf('red pin: %d \n', red_pin_val);

    green_pin_val = arduino_object.analogRead(green_pin);
    %fprintf('green pin: %d \n', green_pin_val);

    blue_pin_val = arduino_object.analogRead(blue_pin);
    %fprintf('blue pin: %d \n', blue_pin_val);

    if blue_pin_val > threshold
        tactile_byte = bitxor(tactile_byte, 1);
    end

    if red_pin_val > threshold
        tactile_byte = bitxor(tactile_byte, 2);
    end

    if green_pin_val > threshold
        tactile_byte = bitxor(tactile_byte, 4);
    end
end

