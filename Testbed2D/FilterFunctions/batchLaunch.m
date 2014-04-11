diary on
matlabpool open local 4

expIDs = [138 142 149:152 155:156 167:169 139 144:148 157:159 161:166 126:132 134:136 140:141];

expN = numel(expIDs);

objID = 17;
objIDs = [repmat(18, 1, 11) repmat(17, 1, 15) repmat(12, 1, 12)];
actID = 13;
actIDs = repmat(actID, 1, expN);

simIDs = [101:111 100 85:92 94:99 72:83] ;
%% experiment configuration
filterIDs = [];

%% loop

for i = 28:28
    expID = expIDs(i)
    close all
%     
%     isOcclude = false;
%     useTactile = true;
%     filter_id = launchFilter(expIDs(i), objIDs(i), actIDs(i), simIDs(i), isOcclude, useTactile);
%   %  animateFilter(filter_id, expIDs(i), simIDs(i), 220);
%     filterIDs = [filterIDs filter_id];
    
%     isOcclude = true;
%     useTactile = true;
%     filter_id = launchFilter(expIDs(i), objIDs(i), actIDs(i), simIDs(i), isOcclude, useTactile);
%     %animateFilter(filter_id, expIDs(i), simIDs(i));
%     filterIDs = [filterIDs filter_id];
    
    isOcclude = true;
    useTactile = false;
    filter_id = launchFilter(expIDs(i), objIDs(i), actIDs(i), simIDs(i), isOcclude, useTactile);
   % animateFilter(filter_id, expIDs(i), simIDs(i));
    filterIDs = [filterIDs filter_id];
%     
%     filter_id = launchKalmanFilter(expIDs(i), isOcclude);
% 	filterIDs = [filterIDs filter_id];
end

% for i = 10:3:13
% %     expID = expIDs(i)
% %     close all
% %     
% %     isOcclude = false;
% %     useTactile = true;
% %     filter_id = launchFilter(expIDs(i), objIDs(i), actIDs(i), simIDs(i), isOcclude, useTactile);
% %    %animateFilter(filter_id, expIDs(i), simIDs(i), 220);
% %     filterIDs = [filterIDs filter_id];
%     
%     isOcclude = true;
%     useTactile = true;
%     filter_id = launchFilter(expIDs(i), objIDs(i), actIDs(i), simIDs(i), isOcclude, useTactile);
%     %animateFilter(filter_id, expIDs(i), simIDs(i));
%     filterIDs = [filterIDs filter_id];
%     
%     isOcclude = true;
%     useTactile = false;
%     filter_id = launchFilter(expIDs(i), objIDs(i), actIDs(i), simIDs(i), isOcclude, useTactile);
%    % animateFilter(filter_id, expIDs(i), simIDs(i));
%     filterIDs = [filterIDs filter_id];
%     
%     filter_id = launchKalmanFilter(expIDs(i), isOcclude);
% 	filterIDs = [filterIDs filter_id];
% end


filterIDs
matlabpool close

diary off