%% This is the scripts to run and get the data needed for GAMS
[expID, objID, actID] = setExpID();
configure;
dbImportExperiment;
dbImportVideo;  % This scripts need expID
 
%%
load('data.mat');
% after import the video, then get the qbar 
rObCenterExp = rObCenter(STARTID:end, 1:2);
rObOrientExp = rObOrient(STARTID:end);

expql = [rObCenter(frame:frame+1, 1:2) rObOrient(frame:frame+1, 1)];
%expql1 = rObOrient(frame:frame+1, 1)
expql
ql
