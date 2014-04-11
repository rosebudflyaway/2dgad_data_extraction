function [ contact_array ] = Convert_Tactile_Bytes_To_Contact_Arrays( byte_array )
% This will convert a contact byte to a 3 X 1 contact array (GRB)

    for i=1:length(byte_array)
        contact_array(i, 1) = bitand(byte_array(i), 4)/4;
        contact_array(i, 2) = bitand(byte_array(i), 2)/2;
        contact_array(i, 3) = bitand(byte_array(i), 1)/1;
    end
end

