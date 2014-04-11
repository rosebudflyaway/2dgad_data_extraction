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
 

load('nc_capsim.mat');
load('nc_fischerNewton.mat');
load('nc_ip.mat');
load('nc_Lemke.mat');
load('nc_minmap.mat');
load('nc_PATH.mat');
 

simLen = length(rObOrientExp);
color2use = lines(8);
LineStyles = {'--', '-', ':'};  % 3
LineMarkers = {'+', 'o', '*', 'x', 'square', 'p', ' <', 'x', 'square'}; %9
AllSolverData = [rObCenterExp  sObCenter_capsim(:, 1:2)  sObCenter_fischerNewton(:, 1:2) sObCenter_minmap(:, 1:2) ...
                   sObCenter_ip(:, 1:2)  sObCenter_Lemke(:, 1:2)  sObCenter_PATH(:, 1:2)];
numContacts = [nc_capsim nc_fischerNewton nc_minmap nc_ip nc_Lemke  nc_PATH];
numColumn = size(AllSolverData, 2);
numContacts(numContacts>3) = 3;
figure;
handleContactsX = [];
for i = 1 : size(numContacts, 2)
    h = plot(1:simLen, numContacts(:, i), 'Color', color2use(i,:), 'LineStyle', ...
        LineStyles{mod(i, 3)+1});
    handleContactsX = [handleContactsX; h];
    hold on;
end
newhandleContactsX = addmarkers(handleContactsX, 10);
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Number of Contacts', 'FontSize', 12, 'FontWeight', 'bold');
title('Number of contacts at each simulation step', 'FontSize', 12, 'FontWeight', 'bold');
axis auto
legend(newhandleContactsX, 'Nonsmooth Newton (FB)', 'Nonsmooth Newton (CCK)', 'Nonsmooth Newton (min)', ...
       'Interior-point',  'Lemke', 'PATH solver', 'Location', 'NorthWest');
fig2pdf('contacts');   
      


figure;
handleArrayX = [];
for i = 1 : numColumn/2
    h = plot(1:simLen, AllSolverData(:, 2*i-1), 'Color', color2use(i,:), 'LineStyle', ...
        LineStyles{mod(i, 3)+1});
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

 