function [ filter_id ] = launchFilter(expID, objID, actID, simID, isOcclude, useTactile)
reset(RandStream.getDefaultStream);


global yObTraj yTactile systemParameters;
global objData actGeometry
global rPegsCenter
global DEBUG
global rObCenter rObOrient STARTID ENDID occludeRange

%% experiment configuration
% expID = 63;
system_parameter_ID = 4;
% objID = 12;
% actID = 13;
% simID = 44;




%% Load data from database

dbImportExperiment;
dbImportVideo;
dbImportSystemParameters;
dbImportObjectGeometry;
dbImportActuatorGeometry;
dbImportSimulation;
configure;
objData.objGeometry = objGeometry;
objData.objMass = objMass;
objData.objMOI = objMOI;
objData.is_circular = is_circular;
objData.objRadius = objRadius;


%% prepare for particle filter

f = @ffun_pf;
h = @hfun_pf;

% Particle Number
particleN = 500;

% Initial covariance
initCov = diag([1e-1 1e-1 1e-4 ...
    1e-10 1e-10 1e-13]);

% Define system transition noise
%epss = 20;
epss = 20;
covW = diag([epss/1000 epss/1000 ...
    10*epss/100000]); %process noise covariance
meanW = [0 0 0];

% Define observation noise
meanV = [0 0 0];
covV = diag([0.5 0.5 0.001]);
%covV = diag([0.5 0.5 0.001]);
% Particle Filter Parameter
resampleInt = 4;%resampleInt = 2;
resampleAlgo = 'fcn_ResampResid';

% System Parameter
dimX = 6;
dimY = 4;


% Max parameter
paramax = [1   1   0.5 100.0];
paramin = [0.1 0.1 0.2 10.0];


%% Initialize state vector
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


% Prepare for filter
Xhat = zeros(dimX, fLen+1);
Phat = zeros(4,    fLen+1);

Xhat(:, 1) = [object_initial_position(1:2) object_initial_rotation 0 0 0];
Phat(:, 1) = [systemParameters.Us systemParameters.Up systemParameters.Uf systemParameters.Rtri ];
YObTraj = [rObCenter(STARTID:ENDID, 1:2)';
    rObOrient(STARTID:ENDID)'];
if ~isempty(tactileSensorReads)
    YTactile = tactileSensorReads(STARTID:ENDID, :)';
else
    YTactile = synTactileReads(STARTID:ENDID, :)';
end

para0 = [systemParameters.Us systemParameters.Up systemParameters.Uf systemParameters.Rtri];
global WPara
%Generate fixed para perturbations
if max(paramin - para0) > 0 || min(paramax - para0) < 0 || max(paramin - paramax) > 0
    error('Parameter range inconsistent! Please use different value.');
end
WPara = drawUniformSample(max(- para0, paramin - para0), paramax - para0, particleN);
%WPara(1, :) = 0;
%WPara(3, :) = 0;
%WPara(4, :) = 0;

%% Construct particle filter
wDistr = GaussianDistr(meanW, covW);
vDistr = GaussianDistr(meanV, covV);

sysBlock = SigObsSys(f, h, wDistr, vDistr, Xhat(:, 1));
initDistr = GaussianDistr(Xhat(:, 1), initCov);
opts = setPFOptions('NumPart', particleN, ...
    'ResampAlgo', resampleAlgo, ...
    'ResampPeriod', resampleInt);
theFltr = PF_Simple(sysBlock, initDistr, opts); %constructing the particle filter

ptAll = zeros(dimX*fLen, particleN);
wtAll = zeros(fLen, particleN);
ptParaAll = zeros(4*fLen, particleN);
wtParaAll = zeros(fLen, particleN);
contactModeAll = zeros(fLen, particleN);
touchModeAll = zeros(fLen, particleN);
closureAll = zeros(fLen, particleN);
logicAll = zeros(fLen, 1);


kFVAll = abs(kalmanFilter);

%% Run the filter

for i = 1:fLen
    
    if mod(i, 100) == 0
        disp(['step' num2str(i)]);
    end
    stepID = i + STARTID - 1;
    aPosCtrl = [rGreenCenterF(stepID, 1:2) rGreenOrient;
        rGreenCenterF(stepID - 1, 1:2) rGreenOrient];
    
    if i > 1
        yObTraj = [YObTraj(:, i) YObTraj(:, i-1)];
    else
        yObTraj = [YObTraj(:, i) YObTraj(:, i)];
    end
    yTactile = YTactile(:, i);
    
%     if max(yObTraj(:, 2) - yObTraj(:, 1)) > 1e-1
%         logicAll(i) = 1;
%     elseif max(yObTraj(:, 2) - yObTraj(:, 1)) < 1e-2
%         logicAll(i) = -1;
%     else
%         logicAll(i) = 0;
%     end
    kFV = kFVAll(:, i);
    if max(kFV) > 1.2
        logicAll(i) = 1;
    elseif max(kFV) < 0.5
        logicAll(i) = -1;
    else
        logicAll(i) = 0;
    end
    
    if isOcclude && stepID >= occludeRange(1) && stepID <= occludeRange(2)
        if useTactile
            theFltr = updateOcclude(theFltr, aPosCtrl, Phat(:, i), kFV);
        else
            theFltr = updateOccludeWithoutTactile(theFltr, aPosCtrl, Phat(:, i));
        end
    else
        theFltr = updateWithoutOcclude(theFltr, aPosCtrl, kFV);
    end
    
    if i < fLen
        DEBUG = false;
    else
        DEBUG = true;
    end
    
    [Xhat(:, i+1) Phat(:, i+1) pt wt P ptPara wtPara contactMode, fContactMode, touchMode, closure] = retrieveData(theFltr, aPosCtrl);
    
    ptAll(dimX * (i-1) + 1: dimX * i, :) = pt;
    wtAll(i, :) = wt(:)';
    ptParaAll(4 * (i-1)+1:4*i, :) = ptPara;
    wtParaAll(i, :) = wtPara(:)';
    contactModeAll(i, :) = contactMode;
    touchModeAll(i, :) = touchMode;
    closureAll(i, :) = closure;
    
end

%fContactMode

%% Export the filter result
fObCenter = Xhat(1:2, :);
fObCenter(3, :) = object_initial_position(3);
fObOrient = Xhat(3, :);

%% Plot the filtered trajectory
global dataPath
videoFilePath = strrep(videoFilePath, '\', '/');
ind = findstr(videoFilePath, '.avi');
if isempty(ind)
    dataDir = [dataPath, videoFilePath, '/'];
else
    dataDir = [dataPath, videoFilePath(1:ind(1)-1), '/'];
end

if ~isdir(dataDir)
    mkdir(dataDir);
end

j = 1:fLen;
h1 = figure; hold on; title('Particle filtering - X');
plot(j, YObTraj(1, j), 'g'); %  simulated observation data
plot(j, Xhat(1, j), 'r');   % filtered mean data
plot(1:size(sObCenter, 1), sObCenter(:, 1), 'k');   % data from pure simulation
legend('Observed', 'Filtered Mean', 'Nominal Simulation');
saveas(h1,[dataDir 'pfx.fig'], 'fig');
saveas(h1,[dataDir 'pfx.png'], 'png');

h2 = figure; hold on; title('Particle filtering - Y');
plot(j, YObTraj(2, j), 'g'); %  simulated observation data
plot(j, Xhat(2, j), 'r');   % filtered mean data
plot(1:size(sObCenter, 1), sObCenter(:, 2), 'k');   % data from pure simulation
legend('Observed', 'Filtered Mean', 'Nominal Simulation');
saveas(h2,[dataDir 'pfy.fig'], 'fig');
saveas(h2,[dataDir 'pfy.png'], 'png');

h3 = figure; hold on; title('Particle filtering - \theta');
plot(j, YObTraj(3, j), 'g'); %  simulated observation data
plot(j, Xhat(3, j), 'r');   % filtered mean data
plot(1:size(sObCenter, 1), sObOrient(:), 'k');   % data from pure simulation
legend('Observed', 'Filtered Mean', 'Nominal Simulation');
saveas(h3,[dataDir 'pftheta.fig'], 'fig');
saveas(h3,[dataDir 'pftheta.png'], 'png');

h4 = figure;
subplot(2, 2, 1), title('Particle filter Parameter Estimation - \mu_s');
plot(j, Phat(1, j));
subplot(2, 2, 2), title('Particle filter Parameter Estimation - \mu_p')
plot(j, Phat(2, j));
subplot(2, 2, 3), title('Particle filter Parameter Estimation - \mu_f')
plot(j, Phat(3, j));
subplot(2, 2, 4), title('Particle filter Parameter Estimation - d_tri')
plot(j, Phat(4, j));
saveas(h4,[dataDir 'pfparameter.fig'], 'fig');
saveas(h4,[dataDir 'pfparameter.png'], 'png');

%% Export the result
dbExportFilter;

save([dataDir num2str(filter_id) '_debug.mat'], 'ptAll', 'wtAll', 'ptParaAll', 'wtParaAll', 'contactModeAll', 'touchModeAll', 'closureAll', 'logicAll');


    

end


function v = kalmanFilter
        
        global rObCenter rObOrient STARTID ENDID
        
        z = [rObCenter(STARTID:ENDID, 1:2) rObOrient(STARTID:ENDID)];
        fLen = ENDID - STARTID + 1;
        
        %% KALMAN FILTERING THE DATA
        TIMESTEP = 1/30;
        
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
        
        R1  = [	0.0001     0       0;
            0	    0.0001    0;
            0       0       0.000001];			  % OBSERVATION NOISE
        
        
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
        
        % fObCenter = X(1:2, :);
        % fObCenter(3, :) = rObCenter(3, 1);
        % fObOrient = X(3, :);
        v = X(4:6, 2:end);
        
    end

