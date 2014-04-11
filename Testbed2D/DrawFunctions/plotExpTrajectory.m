function plotExpTrajectory(expID)

%% Import all data from GAD
dbImportExperiment;
dbImportVideo;

%% Plot and write out the file
scrsz = get(0, 'ScreenSize');
h = figure('OuterPosition', [1 scrsz(2) scrsz(3) scrsz(4)]);
subplot(1,3,1), hold on, title('Experiment -- Shape Center Coordinate X')
plot(1:size(rObCenter,1), rObCenter(:, 1),'r');
xlabel('Time (s)')
ylabel('Unit:(mm)')
axis auto

subplot(1,3,2), hold on, title('Experiment -- Shape Center Coordinate Y')
plot(1:size(rObCenter,1), rObCenter(:, 2),'r');
xlabel('Time (s)')
ylabel('Unit:(mm)')
axis auto

subplot(1,3,3), hold on, title('Experiment -- Shape Theta')
plot(1:size(rObCenter,1), rObOrient,'r');
xlabel('Time (s)')
ylabel('Unit:(radians)')
axis auto


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
saveas(h,[dataDir 'expTrajectory.fig'], 'fig');
saveas(h,[dataDir 'expTrajectory.png'], 'png');
end
