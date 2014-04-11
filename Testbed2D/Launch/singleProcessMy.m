
%% Clear the workspace

%% Define the experiment to process
[expID, objID, actID] = setExpID();

%% Simulation parameter id
system_parameter_ID = 4;
nc = [];
[sObCenter, sObOrient, contactInfo] = runSimulationMy(nc, expID, system_parameter_ID);
contactInfo
 