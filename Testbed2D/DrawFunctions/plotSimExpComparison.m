function plotSimExpComparison(expID, simID)
%% Import all data from GAD
dbImportSimulation;
dbImportExperiment;
dbImportVideo;

%% Plot and write out the file
scrsz = get(0, 'ScreenSize');
h = figure('OuterPosition', [1 scrsz(2) scrsz(3) scrsz(4)]);
simLen = size(sObCenter, 1);
subplot(1,3,1), hold on, title('Simulation vs Experiment -- Shape Center Coordinate X')
plot(1:size(rObCenter,1)-STARTID+1, rObCenter(STARTID:end, 1),'r');
plot(1:simLen, sObCenter(:, 1),'g');
xlabel('Time (s)')
ylabel('Unit:(mm)')
axis auto
legend('Experiment','Simulation');

subplot(1,3,2), hold on, title('Simulation vs Experiment -- Shape Center Coordinate Y')
plot(1:size(rObCenter,1)-STARTID+1, rObCenter(STARTID:end, 2),'r');
plot(1:simLen, sObCenter(:,2),'g');
xlabel('Time (s)')
ylabel('Unit:(mm)')
axis auto
legend('Experiment','Simulation');

subplot(1,3,3), hold on, title('Simulation vs Experiment -- Shape Theta')

plot(1:size(rObCenter,1)-STARTID+1, rObOrient(STARTID:end),'r');
plot(1:simLen, sObOrient,'g');
xlabel('Time (s)')
ylabel('Unit:(radians)')
ylim([-pi pi]);
axis auto
legend('Experiment','Simulation');


%% Export the plot
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
saveas(h,[dataDir 'comparison.fig'], 'fig');
saveas(h,[dataDir 'comparison.png'], 'png');
end
