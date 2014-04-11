%Dump statistics from database into a local mat file for plot for papers

expIDs = [142 149:152 155:156 167:169 138 139 144:148 157:159 161:166 126:132 134:136 140:141];

expN = numel(expIDs);

objID = 17;
objIDs = [repmat(18, 1, 11) repmat(17, 1, 15) repmat(12, 1, 12)];
actID = 13;
actIDs = repmat(actID, 1, expN);

simIDs = [102:111 101 100 85:92 94:99 72:83] ;

configure;
statAll = cell(38, 1);
for i =1:38
     disp(['Processing exp ' num2str(i) ' ... ']);
     statAll{i} = dumpFilterExperiment(expIDs(i), simIDs(i), i);
end
save('filterStatistics', 'statAll')