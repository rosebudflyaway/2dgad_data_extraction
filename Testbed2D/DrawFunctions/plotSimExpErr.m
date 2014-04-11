% Save data from multiple solvers and  the corresponding experiment.
% Then load the data into matlab workspace and plot them all on one plot 
 
% plot the error as the absolute error and relative error
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
 
% Y data
AllSolverData = [rObCenterExp(:, 2)  sObCenter_capsim(:, 2)  sObCenter_fischerNewton(:, 2) sObCenter_minmap(:, 2) ...
                   sObCenter_ip(:, 2)  sObCenter_Lemke(:, 2)  sObCenter_PATH(:, 2)];
numCols = size(AllSolverData, 2) - 1;
expDataInMat  =  repmat(rObCenterExp(:, 2), 1, numCols); 
AbsoluteYError = abs(AllSolverData(:, 2:end) - expDataInMat);
RelativeYError = AbsoluteYError ./ abs(expDataInMat); 
numColumn = size(AbsoluteYError, 2);

figure;
handleArrayX = [];
for i = 1 : numColumn
    h = plot(1:simLen, AbsoluteYError(:, i), 'Color', color2use(i,:), 'LineStyle', ...
        LineStyles{mod(i, 3)+1});
    handleArrayX = [handleArrayX; h];
    hold on;
end
newhandleArrayX = addmarkers(handleArrayX, 10);
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Unit:(mm)', 'FontSize', 12, 'FontWeight', 'bold');
title('Absolute error between the simulated and experimental Y coordinate', 'FontSize', 12, 'FontWeight', 'bold');
axis auto
legend(newhandleArrayX, 'Nonsmooth Newton (FB)', 'Nonsmooth Newton (CCK)', 'Nonsmooth Newton (min)', ...
       'Interior-point',  'Lemke', 'PATH solver', 'Location', 'NorthWest');
%fig2pdf('PositionYAbsError');   

AllSolverOrient = [rObOrientExp sObOrient_capsim  sObOrient_fischerNewton  sObOrient_minmap ...
                   sObOrient_ip  sObOrient_Lemke   sObOrient_PATH ];               
numCols = size(AllSolverOrient, 2) - 1;
expDataOriMat = repmat(rObOrientExp, 1, numCols);
AbsoluteOriError = abs(AllSolverOrient(:, 2:end) - expDataOriMat);
RelativeOriError = AbsoluteOriError ./ abs(expDataOriMat);

figure;
handleArrayT = [];
for i = 1 : numColumn
    ht = plot(1:simLen, AbsoluteOriError(:, i), 'Color', color2use(i, :), 'LineStyle', ...
        LineStyles{mod(i, 3)+1});
    handleArrayT = [handleArrayT; ht]; 
    hold on;
end
newhandleArrayT = addmarkers(handleArrayT, 12);
xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Unit:(radians)', 'FontSize', 14, 'FontWeight', 'bold');
title('Absolute error between the simulated and experimental oritation theta', 'FontSize', 12, 'FontWeight', 'bold');
ylim([-pi pi]);
axis auto
legend(newhandleArrayT, 'Nonsmooth Newton (FB)', 'Nonsmooth Newton (CCK)', 'Nonsmooth Newton (min)', ...
       'Interior-point',   'Lemke', 'PATH solver', 'Location', 'NorthWest');
%    
fig2pdf('OrientationError');
