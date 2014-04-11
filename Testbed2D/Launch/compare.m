%% Define the experiment to process
expID = 167
simID = 109

%% Global Def
configure;

%% Animate the experiment
animateExp = false;
% fullExperiment = true;
% overlayWithImage = true;
% outputVideoFile = [];
% 
% animate(expID, simID, animateExp, fullExperiment, overlayWithImage, outputVideoFile);

%% Plot the statistics
if ~animateExp
    plotSimExpComparison(expID, simID);
else
    plotExpTrajectory(expID);
end
