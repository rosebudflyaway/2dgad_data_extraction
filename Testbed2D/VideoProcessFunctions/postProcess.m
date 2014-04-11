function [rGreenCenterF, rGreenSpeed, rGreenOrient, STARTID, ENDID, actuatorStart] = postProcess(TIMES, rGreenCenter)

%% Filter the actuator movement
TIMESTEP = (TIMES(end)-TIMES(1))/size(TIMES(:), 1);
[rGreenCenterF, rGreenSpeed, rGreenOrient, STARTID, ENDID] =  actuatorFilter(rGreenCenter, TIMESTEP);
actuatorStart = rGreenCenterF(STARTID, :);

end

