function plotFilterExperiment(expID, simID, nameID)

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
lineWidth = 2;
lineWidth2 = 1.5;
units = 'pixels';
width = 1100; % width of one column
height = 550;
font  = 'Times New Roman';
fontsize = 22;
scalefactor = 0.667;
scalefactor2 = 0.5;
dirname = 'html';
filename = 'formatOutput';

%% Captions
LegendStrings = {' Observed', ' NS', ' PF_{(v&t)}', ' PF_{(t only)}',  ' PF_{(none)}', ' KF'};
LegendStrings2 = {' PF_{(v&t)}', ' PF_{(t only)}',  ' PF_{(none)}'};
TitleStrings = {'(a) NS', '(b) PF_{(v&t)}', '(c) PF_{(t only)}', '(d) PF_{(none)}', '(e) KF'};

TitleString = {'(a) x', '(b) y', '(c) \theta'};
FileNameString = {'x', 'y', 'theta'};
YLabelString = {'x (mm)', 'y (mm)', '\theta (radian)'};
commontitle = [''];%['Exp. No ' num2str(nameID) ': Filtering Object Movement - '];
isYLabelOn = true;


%% Plot job
% Index
rI = STARTID:ENDID;
sI = 1:size(sObCenter, 1);
fI = 1:size(fObCenter1, 1)-1;

color0 = [0 1 0];
color1 = [0  0 0];
color2 = [.4 1 1];
color3 = [1 0 0];
color4 = [1 .4 1];
color5 = [0 0 1]; 

for m=1:3
    if ~DEBUG
        hs(m) = fig('units',units,'width',width, 'height', height,'font',font,'fontsize',fontsize);
    else
        hs(m) = figure;
    end
    title([commontitle TitleString{m}]), hold on;
    if ~DEBUG
        set( hs(m), 'Renderer', 'painters');
    end
    if m<3
        plot(rI-STARTID+1, rObCenter(rI, m), ...    
            'LineStyle'       , 'none',  ...
            'Marker'          , '.'         , ...
            'Color'           , color0 , ... 
            'LineWidth', lineWidth2, 'MarkerSize', markersize); %  observation data
        plot(sI, sObCenter(sI, m), ...    
            'linestyle'       , ':',  ...
            'color'           , color1 , ... 
            'linewidth', lineWidth); % pure simulation result
        if ~isempty(filter_ID1)
            plot(fI, fObCenter1(fI, m)      , ...    
            'linestyle'       , '-',  ...
            'color'           , color2 , ... 
            'linewidth', lineWidth2);   % filtered mean data
        end
        if ~isempty(filter_ID2)
            plot(fI, fObCenter2(fI, m)      , ...    
            'linestyle'       , '-',  ...
            'color'           , color3 , ... 
            'linewidth', lineWidth);   % filtered mean data
        end
        if ~isempty(filter_ID3)
            plot(fI, fObCenter3(fI, m)      , ...    
            'linestyle'       , '-',  ...
            'color'           , color4 , ... 
            'linewidth', lineWidth2, 'markersize', 2);   % filtered mean data
        end
        if ~isempty(filter_ID4)
            plot(fI, fObCenter4(fI, m)      , ...    
            'linestyle'       , '-.',  ...
            'color'           , color5 , ... 
            'linewidth', lineWidth2);   % filtered mean data
        end
    else
         plot(rI-STARTID+1, rObOrient(rI, 1)      , ...    
            'LineStyle'       , 'none',  ...
            'Marker'          , '.'         , ...
            'color'           , color0 , ... 
            'linewidth', lineWidth2, 'markersize', markersize); %  observation data
        plot(sI, sObOrient(sI, 1)      , ...    
            'linestyle'       , ':'         , ...
            'color'           , color1 , ... 
            'linewidth', lineWidth); % pure simulation result
        if ~isempty(filter_ID1)
            plot(fI, fObOrient1(fI, 1)      , ...    
            'linestyle'       , '-'         , ...
            'color'           , color2 , ... 
            'linewidth', lineWidth2);   % filtered mean data
        end
        if ~isempty(filter_ID2)
            plot(fI, fObOrient2(fI, 1)      , ...    
            'linestyle'       , '-'         , ...
            'color'           , color3 , ... 
            'linewidth', lineWidth);   % filtered mean data
        end
        if ~isempty(filter_ID3)
            plot(fI, fObOrient3(fI, 1)      , ...    
            'linestyle'       , ':'         , ...
            'color'           , color4 , ... 
            'linewidth', lineWidth, 'markersize', 2);   % filtered mean data
        end
        if ~isempty(filter_ID4)
            plot(fI, fObOrient4(fI, 1)      , ...    
            'linestyle'       , '-.'         , ...
            'color'           , color5 , ... 
            'linewidth', lineWidth2);   % filtered mean data
        end
    end
    xlabel('Time (step)');
    
    if isYLabelOn
        ylabel(YLabelString{m});
    end
    
    LegendString = LegendStrings(1:2);
    if ~isempty(filter_ID1)
        LegendString = [LegendString LegendStrings(3)];
    end
    if ~isempty(filter_ID2)
        occludeRange = occludeRange2;
        LegendString = [LegendString LegendStrings(4)];
    end
    if ~isempty(filter_ID3)
        occludeRange = occludeRange3;
        LegendString = [LegendString LegendStrings(5)];
    end
    if ~isempty(filter_ID4)
        occludeRange = occludeRange4;
        LegendString = [LegendString LegendStrings(6)];
    end
    if ~isempty(filter_ID2) || ~isempty(filter_ID3) || ~isempty(filter_ID4)
        lim = axis;
        plot([occludeRange(1)-STARTID+1 occludeRange(1)-STARTID+1], [lim(3) lim(4)], 'k:');
        plot([occludeRange(2)-STARTID+1 occludeRange(2)-STARTID+1], [lim(3) lim(4)], 'k:');
        text(occludeRange(1)-STARTID+1, lim(4), '\rightarrow', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'Top');
        text(occludeRange(2)-STARTID+1, lim(4), '\leftarrow', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'Top');
        text((occludeRange(1)-STARTID+1+occludeRange(2)-STARTID+1)/2, lim(4), 'Occluded', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'Top');
    end
    hl(m) = legend(LegendString, 'Location', 'Best');
    

    confirm = input('Please adjust legend box position and press any key when done');
    legend(hl(m), 'boxoff');
    
    if ~DEBUG
        global dataPath
        videoFilePath = strrep(videoFilePath, '\', '/');
        ind = findstr(videoFilePath, '.avi');
        if isempty(ind)
            dataDir = [dataPath, videoFilePath, '/'];
        else
            dataDir = [dataPath, videoFilePath(1:ind(1)-1), '/'];
        end
        dataDir;
        export_fig([dataPath 'Filtr' num2str(expID) '_formatted_' FileNameString{m} '.png'], '-painters', '-q100', '-a2');
        export_fig([dataPath 'Filtr' num2str(expID) '_formatted_' FileNameString{m} '.pdf'], '-painters', '-q100', '-a1');
        export_fig(formImageName(imageCount, dirname, filename), '-painters', '-q100', '-a2');
        imageCount = imageCount + 1;
    end
end
end