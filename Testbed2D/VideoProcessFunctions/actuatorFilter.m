
function [rGreenCenterF, rGreenSpeed, rGreenOrient, STARTID, ENDID] =  actuatorFilter(z, TIMESTEP)

%% KALMAN FILTERING THE DATA
% MATRICIES IN THE MODEL, CONSTANT IN THIS CASE
% X_{k+1} = F*X_k + B*u_{k+1} + w_k
% z_{k+1} = H*X_{k+1} + v_k
%
F = [1 0 TIMESTEP 0;
	 0 1 0        TIMESTEP;
	 0 0 1	      0;
	 0 0 0        1; ];
B = 0; % NO CONTROL OR INPUT HERE
H = [	1 0 0 0;
	    0 1 0 0; ];

% NOISE SIGNAL COVARIANCES
%
Q1 = [  0.0001	0	0	0;
	0	0.0001	0	0;
	0	0	0.1	0;
	0	0	0	0.1; ];   % ACCELERATION PHASE, ASSUME BIGGER MODEL NOISE
Q2 = [	0.000001	0	0	0;
	0	0.000001	0	0;
	0	0	0.000001	0;
	0	0	0	0.000001; ]; % CONSTANT SPEED PHASE
R  = [	0.15	0;
	0	0.15 ];			  % OBSERVATION NOISE
ACC_TIME = size(z, 1) / 3;				  % ROUGH ESTIMATE OF ACCELERATION TIME

% INITIAL VALUES FOR STATE AND COVARIANCE
% STATE VECTOR DEFINITION [X Y V_X V_Y]
%
X = [	z(1, 1) z(1, 2) 0 0 ]';
P = [	R [0 0; 0 0;]
	    0 0 0 0;
	    0 0 0 0; ]; %THE INITIAL VELOCITY ARE KNOWN FOR SURE TO BE ZERO, BUT POSITION NOT

% BEGIN THE FILTERING LOOP
%
for i = 2:size(z, 1)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% THE PREDICTION PHASE
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	X(:, i) = F * X(:, i-1);
	if i < ACC_TIME
		P = F * P * F' + Q1;
	else
		P = F * P * F' + Q2;
	end	
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% THE UPDATE PHASE
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	Y = z(i, 1:2)' - H * X(:, i); 	% RESIDUAL
        S = H * P * H' + R; 		% RESIDUAL COVARIANCE
	K = P * H'/ S;		% OPTIMAL KALMAN GAIN
	X(:, i) = X(:, i) + K * Y;	% UPDATE THE STATE
        P = P - K * H * P;		% UPDATE THE COVARIANCE	

end



%% Extract important filter parameter based on filtered trajectory

xVel = median(X(3, :));
yVel = median(X(4, :));
vel = sqrt(X(3, :).*X(3, :) + X(4, :).*X(4, :));
rGreenOrient = atan2(yVel, xVel); %angle is important
rGreenSpeed = median(vel); %stable velocity

rGreenCenterF(:, 1) = X(1, :)';
rGreenCenterF(:, 2) = X(2, :)';
rGreenCenterF(:, 3) = z(:, 3); %save the filtered actuator movement for later simulation and filtering use

[STARTID, ENDID] = locateTimeRange( vel );

%% Plot and Compare
global dataDir

h = figure; hold on; title('Filtering Actuator Movement - Trajectory')
i=1:size(z,1);
plot(X(1, :), X(2, :), 'r');
plot(z(:, 1), z(:, 2), 'g');
legend('filtered', 'observed');
axis equal
saveas(h, [dataDir 'aTrajectory.fig'], 'fig');
saveas(h, [dataDir 'aTrajectory.png'], 'png');

h = figure; hold on; title('Filtering Actuator Movement - Position')
plot(i, X(1, :), 'r');
plot(i, z(:, 1), 'g');
plot(i, X(2, :), 'b');
plot(i, z(:, 2), 'k');
legend('filtered X', 'observed X', 'filtered Y', 'observed Y');
[startIDlineX, ~] = dsxy2figxy(gca, STARTID, 0);
[endIDlineX, ~] = dsxy2figxy(gca, ENDID, 0);
axun = get(gca,'Units');
set(gca,'Units','normalized');  % Make axes units normalized 
axpos = get(gca,'Position');    % Get axes position
annotation('line',[startIDlineX startIDlineX], [axpos(2) axpos(2)+axpos(4)], 'LineStyle' , ':');
text(startIDlineX-0.03,axpos(2),'START', 'Units', 'normalized');
annotation('line',[endIDlineX endIDlineX], [axpos(2) axpos(2)+axpos(4)], 'LineStyle' , ':');
text(endIDlineX,axpos(2),'END', 'Units', 'normalized');
set(gca,'Units',axun);
saveas(h, [dataDir 'aXY.fig'], 'fig');
saveas(h, [dataDir 'aXY.png'], 'png');

h = figure; title('Filtering Actuator Movement - Velocity'), hold on
plot(i, X(3, :), 'r');
plot(i, X(4, :), 'b');
Vel = sqrt(X(3, :).^2 + X(4, :).^2);
plot(i, Vel, 'g');
legend('v_x', 'v_y', 'v');
[startIDlineX, ~] = dsxy2figxy(gca, STARTID, 0);
[endIDlineX, ~] = dsxy2figxy(gca, ENDID, 0);
axun = get(gca,'Units');
set(gca,'Units','normalized');  % Make axes units normalized 
axpos = get(gca,'Position');    % Get axes position
set(gca,'Units',axun);
annotation('line',[startIDlineX startIDlineX], [axpos(2) axpos(2)+axpos(4)], 'LineStyle' , ':');
text(startIDlineX-0.03,axpos(2),'START', 'Units', 'normalized');
annotation('line',[endIDlineX endIDlineX], [axpos(2) axpos(2)+axpos(4)], 'LineStyle' , ':');
text(endIDlineX,axpos(2),'END', 'Units', 'normalized');
saveas(h, [dataDir 'aVelocity.fig'], 'fig');
saveas(h, [dataDir 'aVelocity.png'], 'png');

end

