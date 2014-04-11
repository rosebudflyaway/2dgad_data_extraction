function plotFilterOverlayComparison(expID, simID, nameID)
global imageCount DEBUG lineColor
configure;

%% Load data from the database
dbQueryFilterIDs;
dbImportExperiment;
dbImportVideo;
dbImportSimulation;

if ~isempty(filter_ID1)
    [fObCenter1 fObOrient1 useTactile1 isOcclude1 occludeRange1 Phat1 fContactMode1] = dbImportFilterFunction(filter_ID1);
end
if ~isempty(filter_ID2)
    [fObCenter2 fObOrient2 useTactile2 isOcclude2 occludeRange2 Phat2 fContactMode2] = dbImportFilterFunction(filter_ID2);
end
if ~isempty(filter_ID3)
    [fObCenter3 fObOrient3 useTactile3 isOcclude3 occludeRange3 Phat3 fContactMode3] = dbImportFilterFunction(filter_ID3);
end
if ~isempty(filter_ID4)
    [fObCenter4 fObOrient4 useTactile4 isOcclude4 occludeRange4 fContactMode4] = dbImportKalmanFilterFunction(filter_ID4);
end

%% plot config

%fontsize = 18;
markersize = 6;
lineWidth = 1;
lineWidth2 = 0.25;
units = 'inches';
width = 4.8; % width of one column
height = 3.4;
font  = 'Times New Roman';
fontsize = 9;
scalefactor = 0.667;
scalefactor2 = 0.5;
dirname = 'html';
filename = 'formatOutput';

%% Captions
LegendStrings = {' Observed', ' NS', ' PF_{(v&t)}', ' PF_{(t only)}',  ' PF_{(none)}', ' KF'};
LegendStrings2 = {' PF_{(v&t)}', ' PF_{(t only)}',  ' PF_{(none)}'};
TitleStrings = {'(a) NS', '(b) PF_{(v&t)}', '(c) PF_{(t only)}', '(d) PF_{(none)}', '(e) KF'}

TitleString = {'x', 'y', '\theta'};
FileNameString = {'x', 'y', 'theta'};
YLabelString = {'x (mm)', 'y (mm)', '\theta (radian)'};
commontitle = ['Exp. No ' num2str(nameID) ': Filtering Object Movement - '];
isYLabelOn = true;


%% Plot job
% Index
rI = STARTID:ENDID;
sI = 1:size(sObCenter, 1);
fI = 1:size(fObCenter1, 1)-1;
%% Generate the image comparison at the last timestep

cropOrNot = true;
cropDimension = [350 540];
videoFilePath = strrep(videoFilePath, '\', '/');
ind = findstr(videoFilePath, '.avi');
if isempty(ind)
    imageDir = [imagePath, videoFilePath];
else
    imageDir = [imagePath, videoFilePath(1:ind(1)-1)];
end
imageFile = strcat(imageDir, '/', num2str(ENDID), '.', 'tif');
calibPara = loadCalibration(PARAMETERFILENAME);
lineColor = 'k';
figH1 = plotOverlay(rGreenCenter(ENDID, :), rGreenOrient, sObCenter(end, :), sObOrient(end), rPegsCenter, objGeometry, actGeometry, calibPara, objHeight, actHeight, imageFile, cropOrNot, cropDimension, false);
title(TitleStrings{1});
if ~DEBUG
    export_fig([dataPath 'Filtr' num2str(expID) '_comparison_sim' '.png'], '-painters', '-q100', '-a2');
    export_fig([dataPath 'Filtr' num2str(expID) '_comparison_sim' '.eps'], '-painters', '-q100', '-a2');
    export_fig(formImageName(imageCount, dirname, filename), '-painters', '-q100', '-a2');
    imageCount = imageCount + 1;
end

if ~isempty(filter_ID1)
    lineColor = 'c';
    figH2 = plotOverlay(rGreenCenter(ENDID, :), rGreenOrient, fObCenter1(end, :), fObOrient1(end), rPegsCenter, objGeometry, actGeometry, calibPara, objHeight, actHeight, imageFile, cropOrNot, cropDimension, false);
    title(TitleStrings{2});
    if ~DEBUG
        export_fig([dataPath 'Filtr' num2str(expID) '_comparison_pf_noOcc' '.png'], '-painters', '-q100', '-a2');
        export_fig([dataPath 'Filtr' num2str(expID) '_comparison_pf_noOcc' '.eps'], '-painters', '-q100', '-a2');
        export_fig(formImageName(imageCount, dirname, filename), '-painters', '-q100', '-a2');
        imageCount = imageCount + 1;
    end
end
if ~isempty(filter_ID2)
    lineColor = 'r';
    [figH3 offset] = plotOverlay(rGreenCenter(ENDID, :), rGreenOrient, fObCenter2(end, :), fObOrient2(end), rPegsCenter, objGeometry, actGeometry, calibPara, objHeight, actHeight, imageFile, cropOrNot, cropDimension, true, rRedCenter(ENDID, :), rBlueCenter(ENDID, :));
	%plotMarkerCover(figH3, rRedCenter(ENDID, :)', rBlueCenter(ENDID, :)', calibPara, objHeight, offset);
	
    title(TitleStrings{3});
    
    if ~DEBUG
        export_fig([dataPath 'Filtr' num2str(expID) '_comparison_pf_Occ_Tactile' '.png'], '-painters', '-q100', '-a2');
        export_fig([dataPath 'Filtr' num2str(expID) '_comparison_pf_Occ_Tactile' '.eps'], '-painters', '-q100', '-a2');
        export_fig(formImageName(imageCount, dirname, filename), '-painters', '-q100', '-a2');
        imageCount = imageCount + 1;
    end
end
if ~isempty(filter_ID3)
    lineColor = 'm';
    [figH4 offset] = plotOverlay(rGreenCenter(ENDID, :), rGreenOrient, fObCenter3(end, :), fObOrient3(end), rPegsCenter, objGeometry, actGeometry, calibPara, objHeight, actHeight, imageFile, cropOrNot, cropDimension, true, rRedCenter(ENDID, :), rBlueCenter(ENDID, :));
    %plotMarkerCover(figH4, rRedCenter(ENDID, :)', rBlueCenter(ENDID, :)', calibPara, objHeight, offset);
	title(TitleStrings{4});
    if ~DEBUG
        export_fig([dataPath 'Filtr' num2str(expID) '_comparison_pf_Occ_noTactile' '.png'], '-painters', '-q100', '-a2');
        export_fig([dataPath 'Filtr' num2str(expID) '_comparison_pf_Occ_noTactile' '.eps'], '-painters', '-q100', '-a2');
        export_fig(formImageName(imageCount, dirname, filename), '-painters', '-q100', '-a2');
        imageCount = imageCount + 1;
    end
end
if ~isempty(filter_ID4)
    lineColor = 'b';
    [figH5 offset] = plotOverlay(rGreenCenter(ENDID, :), rGreenOrient, fObCenter4(end, :), fObOrient4(end), rPegsCenter, objGeometry, actGeometry, calibPara, objHeight, actHeight, imageFile, cropOrNot, cropDimension, true, rRedCenter(ENDID, :), rBlueCenter(ENDID, :));
	%plotMarkerCover(figH5, rRedCenter(ENDID, :)', rBlueCenter(ENDID, :)', calibPara, objHeight, offset);
    title(TitleStrings{5});
    if ~DEBUG
        export_fig([dataPath 'Filtr' num2str(expID) '_comparison_kf' '.png'], '-painters', '-q100', '-a2');
        export_fig([dataPath 'Filtr' num2str(expID) '_comparison_kf' '.eps'], '-painters', '-q100', '-a2');
        export_fig(formImageName(imageCount, dirname, filename), '-painters', '-q100', '-a2');
        imageCount = imageCount + 1;
    end
end