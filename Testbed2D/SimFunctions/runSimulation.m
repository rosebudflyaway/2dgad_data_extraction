function runSimulation(expID, system_parameter_ID)
%% Import corresponding experiment information
configure;

dbImportVideo;

%% Import simulation parameter
global systemParameters
dbImportSystemParameters;

%% Geometry and fixel configuration

global B1 B2
B1 = objGeometry;
B2 = actGeometry;
global fixels
fixels = rPegsCenter(:, 1:2);


%% Record Data structure
frameN = numel(rObOrient);
sObCenter = zeros(frameN-STARTID+1, 3);
sObOrient = zeros(frameN-STARTID+1, 1);

%% Launch simulation
% costruct the actuator information stuct
fprintf('Running Simulation ...\n');
aPosCtrl = [rGreenCenterF(STARTID, 1:2) rGreenOrient;
            rGreenCenterF(STARTID, 1:2) rGreenOrient];
[x ~] = ffun([object_initial_position(1:2) object_initial_rotation 0 0 0], aPosCtrl, objMass, objMOI, is_circular, objRadius);
sObCenter(1, :) = [ x(1:2)' rObCenter(1, 3)] ;
sObOrient(1) = x(3);

simLen = frameN + 1 - STARTID;
for i = STARTID+1:frameN
    aPosCtrl = [rGreenCenterF(i, 1:2)     rGreenOrient;
                rGreenCenterF(i-1, 1:2)   rGreenOrient;];
    [x failed sContactMode] = ffun(x, aPosCtrl, objMass, objMOI, is_circular, objRadius);
    sObCenter(i - STARTID + 1, :) = [ x(1:2)' rObCenter(i, 3)] ;
    sObOrient(i - STARTID + 1) = x(3);
    if failed
        simLen = i - STARTID + 1;
        break;
    end
end

sGreenCenter = rGreenCenterF(STARTID:STARTID+simLen-1, :);
sGreenCenter(end, :) = (sGreenCenter(end-1, :) + sGreenCenter(end, :))/2;
%Shrink the simulation trajectory as the simulation length
sObCenter = sObCenter(1:simLen, :);%
sObOrient = sObOrient(1:simLen, :);
fprintf('Simulation done\n');

%% Write the information to database
dbExportSimulation

end