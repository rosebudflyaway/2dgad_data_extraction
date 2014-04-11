function stat = dumpFilterExperiment(expID, simID, nameID)

configure;

%% Load data from the database
dbQueryFilterIDs;
dbImportExperiment;
dbImportVideo;
dbImportSimulation;

if ~isempty(filter_ID1)
    [stat.fObCenter1 stat.fObOrient1 stat.useTactile1 stat.isOcclude1 stat.occludeRange1 stat.Phat1 stat.fContactMode1] = dbImportFilterFunction(filter_ID1);
end
if ~isempty(filter_ID2)
    [stat.fObCenter2 stat.fObOrient2 stat.useTactile2 stat.isOcclude2 stat.occludeRange2 stat.Phat2 stat.fContactMode2] = dbImportFilterFunction(filter_ID2);
end
if ~isempty(filter_ID3)
    [stat.fObCenter3 stat.fObOrient3 stat.useTactile3 stat.isOcclude3 stat.occludeRange3 stat.Phat3 stat.fContactMode3] = dbImportFilterFunction(filter_ID3);
end
if ~isempty(filter_ID4)
    [stat.fObCenter4 stat.fObOrient4 stat.useTactile4 stat.isOcclude4 stat.occludeRange4 stat.fContactMode4] = dbImportKalmanFilterFunction(filter_ID4);
end


stat.expFinalContactMode = expFinalContactMode;
stat.sContactMode = sContactMode;

stat.STARTID = STARTID;
stat.ENDID = ENDID;
stat.sObCenter = sObCenter;
stat.rObCenter = rObCenter;
stat.sObOrient = sObOrient;
stat.rObOrient = rObOrient;


end