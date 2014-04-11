function plotFilterExperiment(expID, simID, filter_ID)
configure;
% Load data from the database
dbImportFilter;
dbImportExperiment;
dbImportVideo;
dbImportSimulation;

%% plot config
fontsize = 18;
markerSize = 5;
lineWidth = 2.5;
LegendString = {' Observed', ' Filtered',  ' Nominal Simulation.'};
TitleString = {'x', 'y', '\theta'};
FileNameString = {'x', 'y', 'theta'};
YLabelString = {'x (mm)', 'y (mm)', '\theta (radian)'};
commontitle = ['Experiment No. ' num2str(expID) ': Filtering Object Movement - '];
isYLabelOn = true;
if ~isYLabelOn
    afFigurePosition = [0.1 0.1 2.4 2.5];
else
    afFigurePosition = [0.1 0.1 2.4 2.5];
end

rI = STARTID:ENDID;
sI = 1:size(sObCenter, 1);
fI = 1:size(fObCenter, 1);

%% Plot job
for m=1:3
    hs(m) = figure;
    title([commontitle TitleString{m}]), hold on;
    
    if m<3
        plot(rI-STARTID+1, rObCenter(rI, m), 'g-', 'linewidth', lineWidth); %  observation data
        plot(fI, fObCenter(fI, m), 'r-', 'linewidth', lineWidth);   % filtered mean data
        plot(sI, sObCenter(sI, m), 'b--', 'linewidth', lineWidth); % pure simulation result
    else
        plot(rI-STARTID+1, rObOrient(rI, 1), 'g-', 'linewidth', lineWidth); %  observation data
        plot(fI, fObOrient(fI, 1), 'r-', 'linewidth', lineWidth);   % filtered mean data
        plot(sI, sObOrient(sI, 1), 'b--', 'linewidth', lineWidth); % pure simulation result
    end
    hl(m) = legend(LegendString, 'Location', 'Best');
    
    xlabel('Time (step)');
    
    if isYLabelOn
        ylabel(YLabelString{m});
    end
    % set(gca,'XLim',[100 380])
    %    set(gca, 'FontSize', fontsize, 'FontName', 'Times New Roman');
    %    xh = get(gca, 'xlabel');
    %    yh = get(gca, 'ylabel');
    %    th = get(gca, 'title');
    %     set(xh, 'FontSize', fontsize, 'FontName', 'Times New Roman');
    %     set(yh, 'FontSize', fontsize, 'FontName', 'Times New Roman');
    %     set(th, 'FontSize', fontsize, 'FontName', 'Times New Roman');
    set(gca, 'FontSize', fontsize);
    xh = get(gca, 'xlabel');
    yh = get(gca, 'ylabel');
    th = get(gca, 'title');
    set(xh, 'FontSize', fontsize);
    set(yh, 'FontSize', fontsize);
    set(th, 'FontSize', fontsize);
    % old = get(gca, 'Position');
    %     if ~isYLabelOn
    %         set(gca, 'Position', [old(1)+0.02 old(2)+0.05 old(3) old(4)-0.1]);
    %     else
    %         set(gca, 'Position', [0.2 old(2)+0.05 old(3) old(4)-0.1]);
    %     end
    
    
    %set(gcf, 'Units', 'inches');
    %set(gcf, 'Position', [0 0 400 300]);
    %set(gcf, 'PaperPositionMode', 'auto');
    
    
    global dataPath
    videoFilePath = strrep(videoFilePath, '\', '/');
    ind = findstr(videoFilePath, '.avi');
    if isempty(ind)
        dataDir = [dataPath, videoFilePath, '/'];
    else
        dataDir = [dataPath, videoFilePath(1:ind(1)-1), '/'];
    end
    dataDir
    print(gcf, '-depsc2', [dataDir 'formatted' num2str(m)]);
    saveas(gcf, [dataDir FileNameString{m} '.png'], 'png');
    print(gcf, '-dpng', [dataPath 'Filtr' num2str(filter_ID) '_formatted_' FileNameString{m}]);
end


%% Plot the parameter
%% calculate mse
bigSize = 14;
smallSize = 12;

yltext = {'', '', '', '(mm)'};
titles = {'\mu_s', '\mu_p ', '\mu_f', 'd_{tri}'};
name = ['s', 'p', 'f', 'd'];
figure;

for i = 1:4
    fh(i) = subplot(2, 2, i);
    hold on
    h(i) = plot(fI, Phat(i, fI), 'g');
    %  h2(i) = plot(fI, repmat(ParameterRecord(i, 100), 1, simN-99), 'y');
    
    set(fh(i), 'Color', 'white')
    set(gca, 'TickDir', 'in');
    set(gca, 'FontSize', smallSize)
    set(gca, 'Box', 'on');
    
    xlabel('Time (Steps)', 'FontSize', bigSize);
    ylabel(yltext{i}, 'FontSize', bigSize);
    title(titles{i},  'FontSize', bigSize);
    set(h(i), 'LineStyle', '-', 'LineWidth', 1.0, 'Color', 'g');
    set(h(i), 'Marker', 'o', 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', 'g', 'MarkerSize', 6.0);
    %set(h2(i), 'LineStyle', '--', 'LineWidth', 2.0, 'Color', 'y');
    %lg(i) = legend('PF', 'Sim', 'Location', 'Best');
    %set(lg(i), 'FontSize', bigSize);
    %set(gcf, 'PaperPosition', [0.25 2.5 12 3])
     
end
saveas(gcf, [dataPath 'Filtr' num2str(filter_ID) '_formatted_para'], 'png')
   
end