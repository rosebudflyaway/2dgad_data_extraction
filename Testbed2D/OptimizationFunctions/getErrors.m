function [err] = getErrors(expID, sObCenter, sObOrient)
%% Import all data from GAD
%dbImportSimulation;
configure;
dbImportExperiment;
dbImportVideo;  % This scripts need expID

expObCenter = rObCenter(STARTID: end, :);
expObOrient = rObOrient(STARTID: end);
expObQ = [expObCenter expObOrient]';
simObQ = [sObCenter sObOrient]';
N = length(expObOrient);

secondTermInErr = 0;
for i = 1 : N
    stepErr = expObQ(:, i) - simObQ(:, i);
    secondTermInErr = secondTermInErr + stepErr' * stepErr;
end
expObQ = expObQ(:);
simObQ = simObQ(:);

err = (1 / N) * ((expObQ - simObQ)' * (expObQ - simObQ) + secondTermInErr);
end