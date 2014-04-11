function [rRedCtr, rBlueCtr, rGreenCtr, rObCtr, rObOri, rPegsCtr, redCtr, blueCtr, greenCtr] ...
    = imageProcess(calibPara, objH, actH, redCtr, blueCtr, greenCtr, requestPegCoords, DEBUG)

%% Define global variables
close all;
disp('Initializing processing ....');

global imgOrigionalRGB
global RED BLUE GREEN
global PAUSETIME
global pegH

imageSize = size(imgOrigionalRGB(:,:,1));

%% Locate the region of different stickers
global DYNAMICREGIONWIDTH STICKERREGIONWIDTH
if isempty(redCtr)
    redRegion = [1, 1, imageSize(2), imageSize(1)];
else
    redRegion = calculateRegion( redCtr, DYNAMICREGIONWIDTH, [1, 1, imageSize(2), imageSize(1)]);
end

if isempty(blueCtr)
    blueRegion = [1, 1, imageSize(2), imageSize(1)];
else
    blueRegion = calculateRegion( blueCtr, DYNAMICREGIONWIDTH, [1, 1, imageSize(2), imageSize(1)]);
end

if isempty(greenCtr)
    greenRegion = [1, 1, imageSize(2), imageSize(1)];
else
    greenRegion = calculateRegion( greenCtr, DYNAMICREGIONWIDTH, [1, 1, imageSize(2), imageSize(1)]);
end

%% Roughly Locate the stickers with/o pegs
if requestPegCoords
    % Roughly locate Red Sticker
    [redCtr redPegCtr] = roughStickerLocate(RED, redRegion, DEBUG, true);
    redCtr = redCtr + double([redRegion(1)-1 redRegion(2)-1]');
    redPegCtr = redPegCtr + double([redRegion(1)-1 redRegion(2)-1]');
    if DEBUG,  pause(PAUSETIME); end
    % Roughly locate Blue Sticker
    [blueCtr bluePegCtr] = roughStickerLocate(BLUE, blueRegion, DEBUG, true);
    blueCtr = blueCtr + double([blueRegion(1)-1 blueRegion(2)-1]');
    bluePegCtr = bluePegCtr + double([blueRegion(1)-1 blueRegion(2)-1]');
    if DEBUG,  pause(PAUSETIME); end
    % Roughly locate Green Sticker
    [greenCtr greenPegCtr] = roughStickerLocate(GREEN, greenRegion, DEBUG, true);
    greenCtr = greenCtr + double([greenRegion(1)-1 greenRegion(2)-1]');
    greenPegCtr = greenPegCtr + double([greenRegion(1)-1 greenRegion(2)-1]');
    if DEBUG,  pause(PAUSETIME); end
else
    [redCtr ~] = roughStickerLocate(RED, redRegion, DEBUG, false);
    redCtr = redCtr + double([redRegion(1)-1 redRegion(2)-1]');
    if DEBUG,  pause(PAUSETIME); end
    % Roughly locate Blue Sticker
    [blueCtr ~] = roughStickerLocate(BLUE, blueRegion, DEBUG, false);
    blueCtr = blueCtr + double([blueRegion(1)-1 blueRegion(2)-1]');
    if DEBUG,  pause(PAUSETIME); end
    % Roughly locate Green Sticker
    [greenCtr ~] = roughStickerLocate(GREEN, greenRegion, DEBUG, false);
    greenCtr = greenCtr + double([greenRegion(1)-1 greenRegion(2)-1]');
    if DEBUG,  pause(PAUSETIME); end
end


%% Finer locate
redRegion = calculateRegion( redCtr, STICKERREGIONWIDTH, [1, 1, imageSize(2), imageSize(1)]);
redOffset = double([redRegion(1)-1 redRegion(2)-1]');
blueRegion = calculateRegion( blueCtr, STICKERREGIONWIDTH, [1, 1, imageSize(2), imageSize(1)]);
blueOffset = double([blueRegion(1)-1 blueRegion(2)-1]');
greenRegion = calculateRegion( greenCtr, STICKERREGIONWIDTH, [1, 1, imageSize(2), imageSize(1)]);
greenOffset =  double([greenRegion(1)-1 greenRegion(2)-1]');

[rRedCtr, redCtr] = fineStickerLocate(RED, redRegion, redOffset, objH, DEBUG, calibPara);    % Finer location relys on either the rough estimate of redX redY blueX blueY greenX greenY
if DEBUG,  pause(PAUSETIME); end
[rBlueCtr, blueCtr] = fineStickerLocate(BLUE, blueRegion, blueOffset, objH, DEBUG, calibPara);   % or the finer estimate value from last step, and after finer location, the value will be
if DEBUG,  pause(PAUSETIME); end
[rGreenCtr, greenCtr] = fineStickerLocate(GREEN, greenRegion, greenOffset, actH, DEBUG, calibPara);  % updated too.
if DEBUG,  pause(PAUSETIME); close all; end

%% Finer locate pegs if necessary
if requestPegCoords
    redPegRegion = calculateRegion( redPegCtr, STICKERREGIONWIDTH/2, [1, 1, imageSize(2), imageSize(1)]);
    redPegOffset = double([redPegRegion(1)-1 redPegRegion(2)-1]');
    bluePegRegion = calculateRegion( bluePegCtr, STICKERREGIONWIDTH/2, [1, 1, imageSize(2), imageSize(1)]);
    bluePegOffset = double([bluePegRegion(1)-1 bluePegRegion(2)-1]');
    greenPegRegion = calculateRegion( greenPegCtr, STICKERREGIONWIDTH/2, [1, 1, imageSize(2), imageSize(1)]);
    greenPegOffset =  double([greenPegRegion(1)-1 greenPegRegion(2)-1]');
    
    [rRedPegCtr, redPegCtr] = fineStickerLocate(RED, redPegRegion, redPegOffset, pegH, DEBUG, calibPara);    % Finer location relys on either the rough estimate of redX redY blueX blueY greenX greenY
    if DEBUG,  pause(PAUSETIME); end
    [rBluePegCtr, bluePegCtr] = fineStickerLocate(BLUE, bluePegRegion, bluePegOffset, pegH, DEBUG, calibPara);   % or the finer estimate value from last step, and after finer location, the value will be
    if DEBUG,  pause(PAUSETIME); end
    [rGreenPegCtr, greenPegCtr] = fineStickerLocate(GREEN, greenPegRegion, greenPegOffset, pegH, DEBUG, calibPara);  % updated too.
    if DEBUG,  pause(PAUSETIME); close all; end
    
    pegsCtr = [greenPegCtr'; redPegCtr'; bluePegCtr';];
    rPegsCtr = [rGreenPegCtr'; rRedPegCtr'; rBluePegCtr';];
else
    rPegsCtr = [];
end

%% Real World Coordinate
rObCtr = (rBlueCtr + rRedCtr)/2;
rObOri = atan2(rBlueCtr(2) - rRedCtr(2), rBlueCtr(1) - rRedCtr(1)) + pi/2;
if rObOri > pi, rObOri = rObOri - 2*pi; end    % standarize the orientation angle

% %geom to body Ctr transform
% if ~isempty(g2b)
%     rObCtr(1:2) = geomToBody( rObCtr, rObOri, g2b);
% end
end

