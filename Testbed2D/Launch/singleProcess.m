
%% Clear the workspace

%% Define the experiment to process
expID = 167;
objID = 12;
actID = 13;

%% Process the video and save all information to the database
%processExperiment(expID, objID, actID);
%postProcessExperiment(expID);

%% Simulation parameter id
 system_parameter_ID = 4;
  %% Launch Simulation
  runSimulation(expID, system_parameter_ID);
  plotSimExpComparisonMy(expID);

%[sObCenter, sObOrient] = runSimulationMy(expID, system_parameter_ID);
% plotSimExpComparisonMy(expID, sObCenter, sObOrient);
% runSimulationMy;
% plotSimExpComparisonMy;