% configure for the video processing
global DEBUG hasSynTactile PAUSETIME PAUSEFRAMEINDEX SIMPAUSETIME ANIMPAUSETIME RESAMPCOND;
global PARAMETERFILENAME CALIBBASEINDEX FRAMERATE DYNAMICREGIONWIDTH STICKERREGIONWIDTH;
global pegH pegR;
global RED BLUE GREEN;
global dataPath videoPath imagePath;
global REDHUE BLUEHUE GREENHUE hueTolerance;
global lineWidth overlayLineWidth

%%%%%%%%%%%%%%%%%%%%%% Please Change %%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Parent Video Path
% videoPath = 'D:/2dGAD_Video/';
% % Parent Image Path
% imagePath = 'D:/2dGAD_Image/';
% % Parent Result Plot path
% dataPath = 'D:/2dGAD_Plot/';
% 
% Parent Video Path
videoPath = '~/Desktop/Emma_code/2dGAD_Video/';
% Parent Image Path
imagePath = '~/Desktop/Emma_code/2dGAD_Image/';
% Parent Result Plot path
dataPath = '~/Desktop/Emma_code/2dGAD_Plot/';

% Debug the vision detection process
DEBUG = false;
% Pause time for debugging
PAUSETIME = 1; %  second
% Pause frame index for debugging
PAUSEFRAMEINDEX = [];
% Add Synthetic tactile information
hasSynTactile = true; 
% SIMULATION PAUSE TIME
SIMPAUSETIME = 0.01;
% FILTER ANIMATION PAUSE TIME
ANIMPAUSETIME = 0.01;
% RESAMPLE Condition Threshold
RESAMPCOND = 0.3;

%%%%%%%%%%%%%%%%%% Less possible to change %%%%%%%%%%%%%%%%%
% Calibration parameter file name
PARAMETERFILENAME = 'cameraCalibration/1280_720/Calib_Results.mat';
% Calibration base index
CALIBBASEINDEX = 1; 
% Sensory data Sampling Rate
FRAMERATE = 30;
% Width of the Region-to-search for time l+1 centered at the position of
% time l, depends on the object velocity
DYNAMICREGIONWIDTH = 300;
% Width of the Region-to-extract when we roughly locate the sticker, depend
% on how big the sticker look in the image
STICKERREGIONWIDTH = 60;
% Height of the pegs
pegH = 51.0794;
% Radius of the peg
pegR = 4.7625; %5.2000; %4.7625;
% Hue of the stickers
REDHUE = 0.97;
BLUEHUE = 0.60;
GREENHUE = 0.38;
% HUE Tolerance
hueTolerance = 0.03;
% Animation line width
overlayLineWidth = 2;
lineWidth = 2;

%%%%%%%%%%%%%%%%%%% Please not change %%%%%%%%%%%%%%%%%%%%
% Mark different colors
RED = 1;
BLUE = 2;
GREEN = 3;