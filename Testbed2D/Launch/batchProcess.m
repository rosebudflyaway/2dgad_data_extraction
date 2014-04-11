%% Define the experiment to process
expIDs = [138 142 149:152 155:156 167:169];
%expIDs = [139 144:148 157:166];
expN = numel(expIDs);

objID = 18;
objIDs = repmat(objID, 1, expN);
actID = 13;
actIDs = repmat(actID, 1, expN);
global positiveReadDis
global negativeReadDis
positiveReadDis = [];
negativeReadDis = [];

%% Process the videos and save all information to the database
for i = 1:expN
    processExperiment(expIDs(i), objIDs(i), actIDs(i));
     expIDs(i)
%     postProcessExperiment(expIDs(i));
     drawnow;
     pause(5);
end

% %% % Simulation parameter id
system_parameter_ID = 4;
system_parameter_IDs = repmat(system_parameter_ID, 1, expN);

%% Launch Simulation
for i = 1:expN
    runSimulation(expIDs(i), system_parameter_IDs(i));
end