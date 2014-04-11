%matlabpool open local 2

expIDs = 141;
expN = numel(expIDs);

objID = 12;
objIDs = repmat(objID, 1, expN);
actID = 13;
actIDs = repmat(actID, 1, expN);

simIDs = [83] ;
%% experiment configuration
filterIDs = [];

for i = 1:1
    isOcclude = false;
    useTactile = true;
    filter_id = launchFilter(expIDs(i), objIDs(i), actIDs(i), simIDs(i), isOcclude, useTactile);
%    animateFilter(filter_id, expIDs(i), simIDs(i));
    filterIDs = [filterIDs filter_id];
    
%     isOcclude = false;
%     useTactile = true;
%     filter_id = launchFilter(expIDs(i), objIDs(i), actIDs(i), simIDs(i), isOcclude, useTactile);
%     animateFilter(filter_id, expIDs(i), simIDs(i));
%     filterIDs = [filterIDs filter_id];
%     
%     isOcclude = true;
%     useTactile = true;
%     filter_id = launchFilter(expIDs(i), objIDs(i), actIDs(i), simIDs(i), isOcclude, useTactile);
%     animateFilter(filter_id, expIDs(i), simIDs(i));
%     filterIDs = [filterIDs filter_id];
end

filterIDs
%matlabpool close
