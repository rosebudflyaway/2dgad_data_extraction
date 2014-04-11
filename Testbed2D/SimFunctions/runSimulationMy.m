function [sObCenter, sObOrient, contactInfo] = runSimulationMy(nc, expID, system_parameter_ID)
%% Import corresponding experiment information
configure;
dbImportVideo;
global rObPos;
global m_numContacts;
rObPos = [rObCenter(:, 1:2), rObOrient];
 
%% Import simulation parameter
global systemParameters 
dbImportSystemParameters;  % use 'system_parameter_ID'
%% Geometry and fixel configuration
global B1 B2
B1 = objGeometry;  % object geometry;  
B2 = actGeometry;  % actuator geometry
global fixels
fixels = rPegsCenter(:, 1:2);

%% Record Data structure
% rObOrient, STARTID, ENDID, rGreenCenterF, rGreenCenter, are from
% dbImportVideo
frameN = numel(rObOrient);             % number of frames
sObCenter = zeros(frameN-STARTID+1, 3);
sObOrient = zeros(frameN-STARTID+1, 1);

%% Launch simulation
% costruct the actuator information stuct
fprintf('Running Simulation ...\n');
aPosCtrl = [rGreenCenterF(STARTID, 1:2) rGreenOrient;
            rGreenCenterF(STARTID, 1:2) rGreenOrient];

% These information in the input arguments are all from dbImportVideo 
[x nc ~] = ffunMy(nc, [object_initial_position(1:2) object_initial_rotation 0 0 0],...
                  aPosCtrl, objMass, objMOI, is_circular, objRadius, STARTID);
contactInfo = [STARTID, m_numContacts];
simLen = frameN + 1 - STARTID;

for i = STARTID+1:frameN-2
    aPosCtrl = [rGreenCenterF(i, 1:2)     rGreenOrient;
                rGreenCenterF(i-1, 1:2)   rGreenOrient;];
    frameNum = i;
    [x nc failed sContactMode] = ffunMy(nc, x, aPosCtrl, objMass, objMOI, is_circular, objRadius, frameNum);
    sObCenter(i - STARTID + 1, :) = [ x(1:2)' rObCenter(i, 3)] ;
    sObOrient(i - STARTID + 1) = x(3);
    contactInfo = [contactInfo; i, m_numContacts];
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
end
%% Write the information to database
% dbExportSimulation
 
 

