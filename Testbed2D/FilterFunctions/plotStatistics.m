function plotStatistics()
load('plot/filterStatistics.mat')
% Plot contact modes comparison
contactmodes = zeros(38, 6);
wmse = zeros(38, 5);
for i = 1:38
    contactmodes(i, :) = [statAll{i}.expFinalContactMode statAll{i}.sContactMode statAll{i}.fContactMode1 statAll{i}.fContactMode3 statAll{i}.fContactMode2 statAll{i}.fContactMode4];
    
    wmse(i, 1) = calcWMSE([statAll{i}.rObCenter(:, 1:2) statAll{i}.rObOrient],  [statAll{i}.sObCenter(:, 1:2)   statAll{i}.sObOrient],  statAll{i}.STARTID, statAll{i}.ENDID);
    wmse(i, 2) = calcWMSE([statAll{i}.rObCenter(:, 1:2) statAll{i}.rObOrient],  [statAll{i}.fObCenter1(:, 1:2) statAll{i}.fObOrient1], statAll{i}.STARTID, statAll{i}.ENDID);
    wmse(i, 3) = calcWMSE([statAll{i}.rObCenter(:, 1:2) statAll{i}.rObOrient],  [statAll{i}.fObCenter3(:, 1:2) statAll{i}.fObOrient3], statAll{i}.STARTID, statAll{i}.ENDID);
    wmse(i, 4) = calcWMSE([statAll{i}.rObCenter(:, 1:2) statAll{i}.rObOrient],  [statAll{i}.fObCenter2(:, 1:2) statAll{i}.fObOrient2], statAll{i}.STARTID, statAll{i}.ENDID);
    wmse(i, 5) = calcWMSE([statAll{i}.rObCenter(:, 1:2) statAll{i}.rObOrient],  [statAll{i}.fObCenter4(:, 1:2) statAll{i}.fObOrient4], statAll{i}.STARTID, statAll{i}.ENDID);
end
plotContactModes(contactmodes);
%plotWMSE(wmse);
end

function plotWMSE(error)
markersize = 10;
units = 'pixels';
width = 1000; % width of one column
height = 657;
font  = 'Times New Roman';
fontsize = 24;
LegendStrings = {' NS', ' PF_{(v&t)}', ' PF_{(none)}',  ' PF_{(t only)}',  ' KF'};
markers = {'o', 's', '^', 'd', 'v'};

fig('units', units, 'width', width, 'height', height, 'font', font, 'fontsize', fontsize);
xlabel('Experiment ID')
ylabel('WMSE')
title('WMSE')
hold on
% for i=1:5
%     plot(error(:, i), ...
%     markers{i}, ...
%     'MarkerEdgeColor', colors{i}, ...
%     'MarkerFaceColor', colors{i}, ...
%     'MarkerSize', markersize);
% end

stemComps  = stem(error);
stemColorMap(1, :) = [0 0 0];
stemColorMap(2, :) = [.4 1 1];
stemColorMap(3, :) = [1 .4 1];
stemColorMap(4, :) = [1 0 0];
stemColorMap(5, :) = [0 0 1];

for i = 1:5
    set(stemComps(i), ...
        'MarkerFaceColor', stemColorMap(i, :), ...
        'MarkerEdgeColor', stemColorMap(i, :), ...
        'MarkerSize', markersize, ...
        'Marker',  markers{i}, ...
        'LineStyle',  ':', ...
        'LineWidth', 0.2);
end

legendhl = legend(LegendStrings);

input('Please adjust legend box position and press any key when done');
legend(legendhl, 'boxoff');
export_fig(['plot/wmse_comp.png'], '-painters', '-q100', '-a2');
export_fig(['plot/wmse_comp.pdf'], '-painters', '-q100', '-a2');
end

function plotContactModes(contactmodes)
markersize1 = 60;
markersize2 = 10;
units = 'pixels';
width = 700; % width of one column
height = 460;
font  = 'Times New Roman';
fontsize = 26;
color1 = [0.75, 0.75, 1];
markers  = {'d', 'v', 'o', '^'};

%% Captions
LegendStrings = {'Experiment', ' NS', ' PF_{(v&t)}', ' PF_{(none)}', ' PF_{(t only)}',  ' KF'};
TitleStrings = {'(a) Experiment vs. NS', '(b) Experiment vs. PF_{(v&t)}', '(c) Experiment vs. PF_{(none)}',  '(d) Experiment vs PF_{(t only)}', '(e) KF'};


for i = 1:4
    % subplot(4, 1, i)
    f(i) = fig('units', units, 'width', width, 'height', height, 'font', font, 'fontsize', fontsize);
    xlabel('Experiment ID')
    ylabel('Final Contact Modes')
    hold on
    plot(contactmodes(:, 1),  ...
        '.' , ...
        'Color'         , color1 , ...
        'MarkerSize', markersize1 );
    
    stem(contactmodes(:, i+1), ...
        markers{i}, ...
        'LineStyle', ':', ...
        'Color', 'k', ...
        'MarkerFaceColor', 'red',...
        'MarkerEdgeColor', 'red', ...
        'MarkerSize', markersize2);
    
    legendhl(i) = legend(LegendStrings{1}, LegendStrings{i+1}, 'Location', 'NorthWest');
    title(TitleStrings{i})
    axis([0 40 0 10])
end

input('Please adjust legend box position and press any key when done');
for i = 1:4
    legend(legendhl(i), 'boxoff');
    export_fig(f(i), ['plot/cm_comp_' num2str(i) '.png'], '-painters', '-q100', '-a2');
    export_fig(f(i), ['plot/cm_comp_' num2str(i) '.pdf'], '-painters', '-q100', '-a2');
end
end