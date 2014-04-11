%% Clear the workspace
clear all; close all; clc;
%% Define the experiment to process
%expIDs = [138 142 149:152 155:156 167:169];  % 10 experiments
expIDs = [138];
%expIDs = [139 144:148 157:166];
expN = numel(expIDs);

objID = 18;
objIDs = repmat(objID, 1, expN);
actID = 13;
actIDs = repmat(actID, 1, expN);
results = [];
for muP = 0.1 : 0.1 : 1.0
    for muF = 0.1 : 0.1 : 1.0
        for triRadius = 5 : 10 : 70
            for muS  = 0.1 : 0.1 : 1.0
                err = 0;
                % For each parameter combination, run for all the
                % experiments 
                for expNum = 1 : expN
                    expID = expIDs(expNum);
                    system_parameters = struct();
                    system_parameters.Us = muS;
                    system_parameters.Up = muP;
                    system_parameters.Uf = muF;
                    system_parameters.Rtri = triRadius;                    
                    [sObCenter, sObOrient] = runSimulationWithSampleParams(expID, system_parameters);
                    [oneExpErr] = getErrors(expID, sObCenter, sObOrient);
                    % ADD the err from each experiment
                    err = err + oneExpErr;
                end
                % normalized over the number of experiments
                err = err / expN;
                % save the final results as for each parameter combinations
                results = [results; muP, muF, triRadius, muS, err];
            end
        end
    end
end

[minErr, index] = min(results(:, end));
optimalParams = results(index, 1:4);
fprintf('The minimum error is: %f\n', minErr);
fprintf('The optimal parametrs are: \n');
optimalParams 