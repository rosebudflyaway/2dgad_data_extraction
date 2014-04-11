%This script serves to read the sensors from the Arduino, and prints
%whether or not contact has been made

ardInst = arduino('COM4');
ardInst.analogRead(0);
contact = 0;

while(contact == 0)
    val = ardInst.analogRead(0);
    fprintf('%d \n',val);
    if(val > 50)
        contact = 1;
    end
end

delete(ardInst);

% To do:
% Asked Zoidberg if he had a soldering iron and some higher gauge wire I could borrow to
% mount sensors to the testbed in the morning
% 
% Need to figure out a threshold for the tactile sensor
% 
% Need to timestamp?
% 
% Need to calibrate the sensors with known weights
% 
% Need to filter out more garbage
% 
% Need to make documentation
% 
% Need to read paper for the meeting
% 
% Need to start working with the hand
