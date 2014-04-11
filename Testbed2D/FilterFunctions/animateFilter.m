function animateFilter(filter_ID, expID, simID, startFrameID)

%%Import filter data
close all
configure;

global objGeometry actGeometry

% Load data from the database
dbImportFilter;
dbImportExperiment;
dbImportVideo;
%dbImportSimulation;
global systemParameters
dbImportSystemParameters;


% Load debug data from the debug file
global dataPath
videoFilePath = strrep(videoFilePath, '\', '/');
ind = findstr(videoFilePath, '.avi');
if isempty(ind)
    dataDir = [dataPath, videoFilePath, '/'];
else
    dataDir = [dataPath, videoFilePath(1:ind(1)-1), '/'];
end
DEBUGFILE = [dataDir num2str(filter_ID) '_debug.mat'];
load(DEBUGFILE, 'ptAll', 'wtAll', 'ptParaAll', 'wtParaAll', 'contactModeAll');

%% Prepare for animation


dimX = 6;
particleN = 500;

isRecord = false;
outputVideoFile1 = [dataDir num2str(filter_ID) '_filter.avi'];
outputVideoFile2 = [dataDir num2str(filter_ID) '_para.avi'];

%% Animate

% fLen = ENDID - STARTID + 1;
% pt = ptAll(1:dimX, :);
% wt = wtAll(1, :);
% ptPara = ptParaAll(1:4, :);
% wtPara = wtParaAll(1, :);
% 
% 
% scrsz = get(0, 'ScreenSize');
% h1 = figure('OuterPosition', [1 scrsz(2)+ scrsz(4)/2 scrsz(3) scrsz(4)/2]);
% h11 = subplot(1,3,1);
% axis equal;
% hold on; title('Particle filtering Trajectory');
% % plot the observed value
% plot(rObCenter(STARTID:end, 1), rObCenter(STARTID:end, 2), 'g');
% 
% % plot the particle values
% pPs1 = scatter(pt(1, :), pt(2, :), 6, wt, 'filled');
% colormap(cool(128));
% colorbar
% 
% % plot the mean value
% plot(fObCenter(1, 1), fObCenter(1, 2), 'r');
% % plot the simulation value
% plot(sObCenter(1, 1), sObCenter(1, 2), 'k');   % data from nominal simulation
% legend('Observed', 'Particles', 'Filtered Mean', 'Nominal Simulation');
% 
% h12 = subplot(1, 3, 2);
% hold on; title('Particle filtering Angle Trajectory');
% % plot the observed orient
% plot(rObOrient(STARTID:end)*180/pi, 'g');
% % plot the
% pPs2 = scatter(repmat(1, 1, particleN), pt(3, :)*180/pi, 6, wt, 'filled');
% colormap(cool(128));
% colorbar
% plot(1, fObOrient(1)*180/pi, 'r');
% plot(1, sObOrient(1)*180/pi, 'k');
% legend('Observed', 'Particles', 'Filtered Mean', 'Nominal Simulation');
% 
% 
% h13 = subplot(1,3,3);
% hold on; title('Particle filtering Average Result Animation');
% aPosCtrlCurrent = [rGreenCenter(STARTID, 1:2) rGreenOrient];
% drawCurrentFrame(h13, aPosCtrlCurrent, [rObCenter(STARTID, 1:2) rObOrient(STARTID)], rPegsCenter);
% 
% h2 = figure('OuterPosition', [1 scrsz(2)+50 scrsz(3) scrsz(4)/2-50]);
% h21 = subplot(1, 4, 1);
% hold on;
% pPara1 = scatter(repmat(1, 1, particleN), ptPara(1, :), 6, wt, 'filled');
% colormap(cool(128));
% colorbar
% 
% plot(1, Phat(1, 1), 'r');
% plot(1:fLen, repmat(systemParameters.Us, 1, fLen), 'k');
% 
% legend('Particles', 'Filtered mean', 'Nominal Simulation')
% 
% h22 = subplot(1, 4, 2);
% hold on;
% pPara2 = scatter(repmat(1, 1, particleN), ptPara(2, :), 6, wt, 'filled');
% colormap(cool(128));
% colorbar
% 
% plot(1, Phat(2, 1), 'r');
% plot(1:fLen, repmat(systemParameters.Up, 1, fLen), 'k');
% 
% legend('Particles', 'Filtered mean', 'Nominal Simulation')
% 
% 
% h23 = subplot(1, 4, 3);
% hold on;
% pPara3 = scatter(repmat(1, 1, particleN), ptPara(3, :), 6, wt, 'filled');
% colormap(cool(128));
% colorbar
% 
% plot(1, Phat(3, 1), 'r');
% plot(1:fLen, repmat(systemParameters.Uf, 1, fLen), 'k');
% 
% legend('Particles', 'Filtered mean', 'Nominal Simulation')
% 
% 
% h24 = subplot(1, 4, 4);
% hold on;
% pPara4 = scatter(repmat(1, 1, particleN), ptPara(4, :), 6, wt, 'filled');
% colormap(cool(128));
% colorbar
% 
% plot(1, Phat(4, 1), 'r');
% plot(1:fLen, repmat(systemParameters.Rtri, 1, fLen), 'k');
% 
% legend('Particles', 'Filtered mean', 'Nominal Simulation')
% 
% if isRecord
%     filterAvi = avifile(outputVideoFile1, 'compression', 'none');
%     paraAvi = avifile(outputVideoFile2, 'compression', 'none');
%     ffr = getframe(h1);
%     filterAvi = addframe(filterAvi, ffr);
%     pfr = getframe(h2);
%     paraAvi = addframe(paraAvi, pfr);
% end
% 
% if ~exist('startFrameID', 'var')
%     startFrameID = 1 + 1;
% else
%     startFrameID = startFrameID + 1;
% end

% for i = startFrameID:fLen
%     
%     pt = ptAll((i-1)*dimX + 1 : i*dimX, :);
%     wt = wtAll(i, :);
%     ptPara = ptParaAll((i-1)*4 + 1 : i*4, :);
%     wtPara = wtParaAll(i, :);
%     
%     sI = i;
%     fI = i;
%     rI = i + STARTID - 1;
%     
%     if sI > numel(sObOrient), sI = numel(sObOrient); end    
%     
%     figure(h1)
%     subplot(h11);
%     plot(fObCenter(fI, 1), fObCenter(fI, 2), 'r');
%     plot(sObCenter(sI, 1), sObCenter(sI, 2), 'k');   % data from nominal simulation
%     set(pPs1, 'XData', pt(1, :), 'YData', pt(2, :), 'CData', wt);
%     
%     subplot(h12);
%     plot(i, fObOrient(fI)*180/pi, 'r');
%     plot(i, sObOrient(sI)*180/pi, 'k');   % data from nominal simulation
%     set(pPs2, 'XData', repmat(i, 1, particleN), 'YData', pt(3, :)*180/pi, 'CData', wt);
%     
%     aPosCtrlCurrent = [rGreenCenter(rI, 1:2) rGreenOrient];
%     drawCurrentFrame(h13, aPosCtrlCurrent, [fObCenter(fI, 1:2) fObOrient(fI)], rPegsCenter);
%     
%     figure(h2)
%     subplot(1,4,1)
%     set(pPara1, 'XData', repmat(i, 1, particleN), 'YData', ptPara(1, :), 'CData', wtPara);
%     plot(i-1:i, Phat(1, i-1:i), 'r');
%     
%     subplot(1,4,2)
%     set(pPara2, 'XData', repmat(i, 1, particleN), 'YData', ptPara(2, :), 'CData', wtPara);
%     plot(i-1:i, Phat(2, i-1:i), 'r');
%     
%     subplot(1,4,3)
%     set(pPara3, 'XData', repmat(i, 1, particleN), 'YData', ptPara(3, :), 'CData', wtPara);
%     plot(i-1:i, Phat(3, i-1:i), 'r');
%     
%     subplot(1,4,4)
%     set(pPara4, 'XData', repmat(i, 1, particleN), 'YData', ptPara(4, :), 'CData', wtPara);
%     plot(i-1:i, Phat(4, i-1:i), 'r');
%     
%     drawnow;
%     
%     if isRecord
%         ffr = getframe(h1);
%         filterAvi = addframe(filterAvi, ffr);
%         pfr = getframe(h2);
%         paraAvi = addframe(paraAvi, pfr);
%     end
%     
%   %  pause(ANIMPAUSETIME);
% end
% 
% if isRecord
%     filterAvi = close(filterAvi);
%     paraAvi = close(paraAvi);
% end

%% Most detailed Visualization
animateExp = false;
fullExperiment = true;
overlayWithImage = true;
outputVideoFile = [];

animateWithImage(expID, filter_ID, animateExp, fullExperiment, overlayWithImage, outputVideoFile);

end
