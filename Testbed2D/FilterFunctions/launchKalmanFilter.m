
function [ filter_id ] = launchKalmanFilter(expID, isOcclude)

%global occludeRange

configure;

%% Load data from database
dbImportExperiment;
dbImportVideo;

z = [rObCenter(STARTID:ENDID, 1:2) rObOrient(STARTID:ENDID)];
%occludeRange = [ floor(STARTID + (ENDID-STARTID)*3/4)  ENDID];
fLen = ENDID - STARTID + 1;
%isOcclude = true;
occludeRangeBase = [ floor(STARTID + (ENDID-STARTID)*3/4)+1  ENDID];
occludeRange = occludeRangeBase;

% Locate the occlude range, make sure occlusion happen before 
if ~isempty(tactileSensorReads)
    for i=1:occludeRangeBase(1)
        tmp = tactileSensorReads(i, :);
        if tmp(1) == 0 && tmp(2) == 0 && tmp(3) == 0
            occludeRange(1) = i;
        else
            break;
        end
    end
end

system_parameter_ID = 4;
%% KALMAN FILTERING THE DATA
TIMESTEP = 1/FRAMERATE;

% MATRICIES IN THE MODEL, CONSTANT IN THIS CASE
% X_{k+1} = F*X_k + B*u_{k+1} + w_k
% z_{k+1} = H*X_{k+1} + v_k
%
F = [1 0 0 TIMESTEP 0 0;
	 0 1 0 0 TIMESTEP 0;
     0 0 1 0 0 TIMESTEP;
	 0 0 0 1 0 0;
	 0 0 0 0 1 0;
     0 0 0 0 0 1];
 
B = 0; % NO CONTROL OR INPUT HERE
H = [1 0 0 0 0 0;
	 0 1 0 0 0 0;
     0 0 1 0 0 0];

% NOISE SIGNAL COVARIANCES
%
Q1 = [  0.0001	0	0	0   0   0;
        0	0.0001	0	0   0   0;
        0	0	0.00001	0   0   0;
        0	0	0       0.01 0   0;
        0   0   0       0   0.01 0;
        0   0   0       0   0   0.001];

R1  = [	0.4     0       0;
        0	    0.4    0;
        0       0       0.1];			  % OBSERVATION NOISE


% INITIAL VALUES FOR STATE AND COVARIANCE
% STATE VECTOR DEFINITION [X Y V_X V_Y]
%
X = zeros(6, fLen+1);
X(:, 1) = [	z(1, 1) z(1, 2) z(1, 3) 0 0 0]';
P = [	R1 [0 0 0; 0 0 0; 0 0 0;]
        0 0 0 0 0 0;
        0 0 0 0 0 0;
        0 0 0 0 0 0]; %THE INITIAL VELOCITY ARE KNOWN FOR SURE TO BE ZERO, BUT POSITION NOT

% BEGIN THE FILTERING LOOP
%
for i = 1:fLen

    if isOcclude && i > occludeRange(1)-STARTID+1 && i < occludeRange(2)-STARTID+1
        
        X(:, i+1) = F * X(:, i);
        
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % THE PREDICTION PHASE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        X(:, i+1) = F * X(:, i);
        P = F * P * F' + Q1;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % THE UPDATE PHASE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        Y = z(i, :)' - H * X(:, i+1); 	% RESIDUAL
        S = H * P * H' + R1; 		% RESIDUAL COVARIANCE
        K = P * H'/ S;		% OPTIMAL KALMAN GAIN
        X(:, i+1) = X(:, i+1) + K * Y;	% UPDATE THE STATE
        P = P - K * H * P;		% UPDATE THE COVARIANCE	
    end
	

end

fObCenter = X(1:2, :);
fObCenter(3, :) = rObCenter(3, 1);
fObOrient = X(3, :);
fContactMode = 8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot and Compare
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
global dataPath
videoFilePath = strrep(videoFilePath, '\', '/');
ind = findstr(videoFilePath, '.avi');
if isempty(ind)
    dataDir = [dataPath, videoFilePath, '/'];
else
    dataDir = [dataPath, videoFilePath(1:ind(1)-1), '/'];
end


j = 1:fLen;
h1 = figure; hold on; title('Kalman filtering - X');
plot(j, z(j, 1), 'g'); %  simulated observation data
plot(j, X(1, j), 'r');   % filtered mean data
legend('Observed', 'Filtered Mean');
saveas(h1,[dataDir 'kfx.fig'], 'fig');
saveas(h1,[dataDir 'kfx.png'], 'png');

h2 = figure; hold on; title('Kalman filtering - Y');
plot(j, z(j, 2), 'g'); %  simulated observation data
plot(j, X(2, j), 'r');   % filtered mean data
legend('Observed', 'Filtered Mean');
saveas(h2,[dataDir 'kfy.fig'], 'fig');
saveas(h2,[dataDir 'kfy.png'], 'png');

h3 = figure; hold on; title('Kalman filtering - \theta');
plot(j, z(j, 3), 'g'); %  simulated observation data
plot(j, X(3, j), 'r');   % filtered mean data
legend('Observed', 'Filtered Mean');
saveas(h3,[dataDir 'kftheta.fig'], 'fig');
saveas(h3,[dataDir 'kftheta.png'], 'png');



%% Export the result
dbExportKalmanFilter;

end

