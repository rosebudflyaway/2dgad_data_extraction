function [ contactModes contactModeStrings] = listFinalContactModes( expID, simID )

configure;

%% Load data from the database
dbQueryFilterIDs;
dbImportExperiment;
dbImportVideo;
dbImportSimulation;

if ~isempty(filter_ID1)
    [~, ~, ~, ~ , ~, ~, fContactMode1] = dbImportFilterFunction(filter_ID1);
end
if ~isempty(filter_ID2)
    [~, ~, ~, ~ , ~, ~, fContactMode2] = dbImportFilterFunction(filter_ID2);
end
if ~isempty(filter_ID3)
    [~, ~, ~, ~ , ~, ~, fContactMode3] = dbImportFilterFunction(filter_ID3);
end
if ~isempty(filter_ID4)
    [~, ~, ~, ~ , ~, fContactMode4] = dbImportKalmanFilterFunction(filter_ID4);
end

contactModes = [expFinalContactMode sContactMode fContactMode1 fContactMode2 fContactMode3 fContactMode4];

contactModeStrings = cell(1,6);
for i = 1:6
    contactModeStrings{1, i} = contactMode2Str(contactModes(1, i));
end

end

