function  plotSimExpComparisonMy(expID, sObCenter, sObOrient)
%% Import all data from GAD
%dbImportSimulation;
configure;
dbImportExperiment;
dbImportVideo;  % This scripts need expID
%% Plot and write out the file
%rObCenterExp = rObCenter(STARTID:end, 1:2);
%rObOrientExp = rObOrient(STARTID:end);
sObCenter_fischerNewton = sObCenter;
sObOrient_fischerNewton = sObOrient;
% save('rObCenterExp.mat', 'rObCenterExp');
% save('rObOrientExp.mat', 'rObOrientExp');
% save('sObCenter_fischerNewton.mat', 'sObCenter_fischerNewton');
% save('sObOrient_fischerNewton.mat', 'sObOrient_fischerNewton');
simLen = size(sObCenter, 1);
figure;
plot(1:size(rObCenter,1)-STARTID+1, rObCenter(STARTID:end, 1),'r');
hold on;
plot(1:simLen, sObCenter(:, 1),'g');
hold off;
xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Unit:(mm)', 'FontSize', 14, 'FontWeight', 'bold');
title('Simulation vs Experiment -- Shape Center Coordinate X', 'FontSize', 14, 'FontWeight', 'bold');
axis auto
legend('Experiment','Simulation', 'Location', 'SouthWest');

%subplot(1,3,2), hold on, 
figure;
plot(1:size(rObCenter,1)-STARTID+1, rObCenter(STARTID:end, 2),'r');
hold on;
plot(1:simLen, sObCenter(:,2),'g');
hold off;
xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Unit:(mm)', 'FontSize', 14, 'FontWeight', 'bold');
title('Simulation vs Experiment -- Shape Center Coordinate Y', 'FontSize', 14, 'FontWeight', 'bold')
axis auto
legend('Experiment','Simulation',  'Location', 'SouthWest');

%subplot(1,3,3), hold on, 
figure;
plot(1:size(rObCenter,1)-STARTID+1, rObOrient(STARTID:end),'r');
hold on;
plot(1:simLen, sObOrient,'g');
hold off;
xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Unit:(radians)', 'FontSize', 14, 'FontWeight', 'bold');
title('Simulation vs Experiment -- Shape Theta', 'FontSize', 14, 'FontWeight', 'bold');
ylim([-pi pi]);
axis auto
legend('Experiment','Simulation',  'Location', 'SouthWest');

%% Export the plot
% global dataPath
% videoFilePath = strrep(videoFilePath, '\', '/');
% ind = findstr(videoFilePath, '.avi');
% if isempty(ind)
%     dataDir = [dataPath, videoFilePath, '/'];
% else
%     dataDir = [dataPath, videoFilePath(1:ind(1)-1), '/'];
% end
% 
% if ~isdir(dataDir)
%     mkdir(dataDir);
% end
% saveas(h,[dataDir 'comparison.fig'], 'fig');
% saveas(h,[dataDir 'comparison.png'], 'png');
% %end
% 

