function plotFilterParameters(expID, simID, nameID)

global imageCount DEBUG
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
                occludeRange = occludeRange2;
end
if ~isempty(filter_ID3)
    [fObCenter3 fObOrient3 useTactile3 isOcclude3 occludeRange3 Phat3 fContactMode3] = dbImportFilterFunction(filter_ID3);
                occludeRange = occludeRange3;
end
if ~isempty(filter_ID4)
    [fObCenter4 fObOrient4 useTactile4 isOcclude4 occludeRange4 fContactMode4] = dbImportKalmanFilterFunction(filter_ID4);
                occludeRange = occludeRange4;
end

%% plot config

%fontsize = 18;
markersize = 6;
lineWidth = 1.5;
lineWidth2 = 1;
units = 'inches';
width = 4.8; % width of one column
height = 3.4;
font  = 'Times New Roman';
fontsize = 18;
scalefactor = 0.667;
scalefactor2 = 0.5;
dirname = 'html';
filename = 'formatOutput';

%% Captions
LegendStrings = {' Observed', ' NS', ' PF_{(v&t)}', ' PF_{(t only)}',  ' PF_{(none)}', ' KF'};
LegendStrings2 = {' PF_{(v&t)}', ' PF_{(t only)}'};
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
%% Plot the parameter

yltext = {'', '', '', '(mm)'};
titles = {'(a) \mu_s', '(b) \mu_p ', '(c) \mu_f', '(d) d_{tri}'};
name = ['s', 'p', 'f', 'd'];
if ~DEBUG
    fig('units',units,'width', width*2,'font',font,'fontsize',fontsize);
else
    figure
end
for i = 1:4
    fh(i) = subplot(2, 2, i);
    hold on
    if ~isempty(filter_ID1)
        h1(i) = plot(fI, Phat1(i, fI), 'c--', 'LineWidth', lineWidth,'markersize', markersize, 'Color', 'b');
    end
    if ~isempty(filter_ID2)
        h2(i) = plot(fI, Phat2(i, fI), 'r.-', 'LineWidth', lineWidth2,'markersize', markersize, 'Color', 'g');
    end
%     if ~isempty(filter_ID3)
%         h3(i) = plot(fI, Phat3(i, fI), 'm.-', 'LineWidth', lineWidth2,'markersize', markersize, 'Color', 'r');
%     end

    set(fh(i), 'Color', 'white')
    set(gca, 'TickDir', 'in');
    set(gca, 'Box', 'on');
    
    xlabel('Time (Steps)');
    ylabel(yltext{i});
    title(titles{i});
    
    if ~isempty(filter_ID2) || ~isempty(filter_ID3) || ~isempty(filter_ID4)
        lim = axis;
        plot([occludeRange(1)-STARTID+1 occludeRange(1)-STARTID+1], [lim(3) lim(4)], 'k:');
        plot([occludeRange(2)-STARTID+1 occludeRange(2)-STARTID+1], [lim(3) lim(4)], 'k:');
        text(occludeRange(1)-STARTID+1, lim(4), '\rightarrow', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'Top');
        text(occludeRange(2)-STARTID+1, lim(4), '\leftarrow', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'Top');
        text((occludeRange(1)-STARTID+1+occludeRange(2)-STARTID+1)/2, lim(4), 'Occluded', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'Top', 'fontsize', 13);
        xlim([lim(1) lim(2)]);
        ylim([lim(3) lim(4)]);
    end
end

hl = legend(LegendStrings2, 'Location', 'Best');
currentPos = get(hl, 'Position');
newPosx = 0.5 - currentPos(3)/2;
newPosy = 0.49 - currentPos(4)/2;
newPos= [newPosx newPosy currentPos(3) currentPos(4)];
set(hl, 'Position', newPos);
confirm = input('Please adjust legend box position and press any key when done');
legend(hl, 'boxoff');

if ~DEBUG
    export_fig([dataPath 'Filtr' num2str(expID) '_formatted_para' '.png'], '-painters', '-q100', '-a2');
    export_fig([dataPath 'Filtr' num2str(expID) '_formatted_para' '.pdf'], '-painters', '-q100', '-a1');
    export_fig(formImageName(imageCount, dirname, filename), '-painters', '-q100', '-a2');
    imageCount = imageCount + 1;
end