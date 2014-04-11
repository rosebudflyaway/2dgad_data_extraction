%% Particle Filter Results
% Filtering Results from Thirty-Eight Experiment with Real Tactile Sensor Reads
%%
%expIDs = [66:73 63:64];
% expIDs = [138 142 149:152 155:156 167:169];
% expN = numel(expIDs);
% 
% objID = 18;
% objIDs = repmat(objID, 1, expN);
% actID = 13;
% actIDs = repmat(actID, 1, expN);
% 
% simIDs = [101:111] ;

expIDs = [142 149:152 155:156 167:169 138 139 144:148 157:159 161:166 126:132 134:136 140:141];

expN = numel(expIDs);

objID = 17;
objIDs = [repmat(18, 1, 11) repmat(17, 1, 15) repmat(12, 1, 12)];
actID = 13;
actIDs = repmat(actID, 1, expN);

simIDs = [102:111 101 100 85:92 94:99 72:83] ;

global imageCount DEBUG
imageCount = 1;
configure;


%% Experiment 1
% *Estimated Trajectory*
i=28;
plotFilterExperiment(expIDs(i), simIDs(i), i);
%
%*Estimated Parameter*
if ~DEBUG
   plotFilterParameters(expIDs(i), simIDs(i), i);
end
%% 
% *Overlay Comparison at the end of the experiment:*
%plotFilterOverlayComparison(expIDs(i), simIDs(i), i);
%%
% *Final Contact Modes*
[contactModes contactModeStrings] = listFinalContactModes(expIDs(i), simIDs(i));
r = {['Experiment ' num2str(i)]};
c = {'experiment','simulation','pf: no occlusion','pf: occluded with Tactile','pf: occluded without Tactile', 'kf: occluded'};
makeHtmlTable(contactModes,contactModeStrings,r,c);


if ~DEBUG
    % Use high quality picture
    sourcedirname = 'html';
    destdirname = 'FilterFunctions\html';
    filename = 'formatOutput';
    for imI = 1:imageCount
        sourcefile = formImageName(imI, sourcedirname, filename);
        destfile = formImageName(imI, destdirname, filename);
        [text result ] = system(['copy ' sourcefile ' ' destfile]);
    end
end

