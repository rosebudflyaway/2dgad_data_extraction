% Save data from multiple solvers and  the corresponding experiment.
% Then load the data into matlab workspace and plot them all on one plot 

%% Import all data from .mat file
load('rObCenterExp.mat');
load('rObOrientExp.mat');
load('sObCenter_capsim.mat');
load('sObCenter_fischerNewton.mat');
load('sObCenter_ip.mat');
load('sObCenter_Lemke.mat');
load('sObCenter_minmap.mat');
load('sObCenter_PATH.mat');
%load('sObCenter_pgs.mat');

load('sObOrient_capsim.mat');
load('sObOrient_fischerNewton.mat');
load('sObOrient_ip.mat');
load('sObOrient_Lemke.mat');
load('sObOrient_minmap.mat');
load('sObOrient_PATH.mat');
%load('sObOrient_pgs.mat');

simLen = length(rObOrientExp);
color2use = lines(8);
%cstring = 'rgbcmk';
LineStyles = {'--', '-', ':'};  % 3
LineMarkers = {'+', 'o', '*', 'x', 'square', 'p', ' <', 'x', 'square'}; %9
% AllSolverData = [rObCenterExp  sObCenter_capsim(:, 1:2)  sObCenter_fischerNewton(:, 1:2) sObCenter_minmap(:, 1:2) ...
%                    sObCenter_ip(:, 1:2)  sObCenter_pgs(:, 1:2) sObCenter_Lemke(:, 1:2)  sObCenter_PATH(:, 1:2)];
% AllSolverOrient = [rObOrientExp sObOrient_capsim  sObOrient_fischerNewton  sObOrient_minmap ...
%                    sObOrient_ip sObOrient_pgs  sObOrient_Lemke   sObOrient_PATH ];
AllSolverData = [rObCenterExp  sObCenter_capsim(:, 1:2)  sObCenter_fischerNewton(:, 1:2) sObCenter_minmap(:, 1:2) ...
                   sObCenter_ip(:, 1:2)  sObCenter_Lemke(:, 1:2)  sObCenter_PATH(:, 1:2)];
AllSolverOrient = [rObOrientExp sObOrient_capsim  sObOrient_fischerNewton  sObOrient_minmap ...
                   sObOrient_ip  sObOrient_Lemke   sObOrient_PATH ];               
numColumn = size(AllSolverData, 2);
lineWidthArray = 0.5*ones(size(AllSolverData, 1), 1);
lineWidthArray(1) = 2;
figure;
handleArrayX = [];
for i = 1 : numColumn/2
    h = plot(1:simLen, AllSolverData(:, 2*i-1), 'Color', color2use(i,:), 'LineStyle', ...
        LineStyles{mod(i, 3)+1}, 'LineWidth', lineWidthArray(i));
    handleArrayX = [handleArrayX; h];
    hold on;
end
newhandleArrayX = addmarkers(handleArrayX, 10);
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Unit:(mm)', 'FontSize', 12, 'FontWeight', 'bold');
title('Simulation vs Experiment -- Shape Center Coordinate X', 'FontSize', 12, 'FontWeight', 'bold');
axis auto
legend(newhandleArrayX, 'Experiment','Nonsmooth Newton (FB)', 'Nonsmooth Newton (CCK)', 'Nonsmooth Newton (min)', ...
       'Interior-point',  'Lemke', 'PATH solver', 'Location', 'NorthWest');
fig2pdf('PositionX');   
      
figure;
handleArrayY = [];
for i = 1 : numColumn/2
    hy = plot(1:simLen, AllSolverData(:, 2*i), 'Color', color2use(i, :), 'LineStyle', ...
        LineStyles{mod(i, 3)+1}, 'LineWidth', lineWidthArray(i));
    handleArrayY = [handleArrayY; hy]; 
    hold on;
end
newhandleArrayY = addmarkers(handleArrayY, 12);
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Unit:(mm)', 'FontSize', 14, 'FontWeight', 'bold');
title('Simulation vs Experiment -- Shape Center Coordinate Y', 'FontSize', 12, 'FontWeight', 'bold');
axis auto
legend(newhandleArrayY, 'Experiment','Nonsmooth Newton (FB)', 'Nonsmooth Newton (CCK)', 'Nonsmooth Newton (min)',...
       'Interior-point',  'Lemke', 'PATH solver', 'Location', 'NorthEast');  
fig2pdf('PositionY');
 
figure;
handleArrayT = [];
for i = 1 : numColumn/2
    ht = plot(1:simLen, AllSolverOrient(:, i), 'Color', color2use(i, :), 'LineStyle', ...
        LineStyles{mod(i, 3)+1},  'LineWidth', lineWidthArray(i));
    handleArrayT = [handleArrayT; ht]; 
    hold on;
end
newhandleArrayT = addmarkers(handleArrayT, 12);
xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Unit:(radians)', 'FontSize', 14, 'FontWeight', 'bold');
title('Simulation vs Experiment -- Shape Theta', 'FontSize', 14, 'FontWeight', 'bold');
ylim([-pi pi]);
axis auto
legend(newhandleArrayT, 'Experiment', 'Nonsmooth Newton (FB)', 'Nonsmooth Newton (CCK)', 'Nonsmooth Newton (min)', ...
       'Interior-point',   'Lemke', 'PATH solver', 'Location', 'SouthWest');
   
fig2pdf('Orientation');
 