
%% get the vertices coordinate in image space
videoDir = 'video\forJeremyCalibration\301';
imageDir = 'images\1.tif';
ObjectHeight = 45.466;
PAUSETIME = 5;
% request the number of vertices
vNum = input('Please input the number of the polygon vertices: ');

if ~isdir([videoDir '\images'])
    mkdir([videoDir '\images']);
end
if ~exist([videoDir '\' imageDir], 'file')
    videofile = dir(strcat(videoDir,'\*.avi'));
    videoName = videofile.name;
    videoName = strcat(videoDir,'\', videoName);
    mov = aviread(videoName, 2);
    strtemp = strcat(videoDir, '\images\1.tif');
    imwrite(mov.cdata(:,:,:),strtemp,'tif'); 
end

imgFile = imread([videoDir '\' imageDir]);
figure, imshow(imgFile), title('Please click to identify the vertices clockwise:');
set(gcf, 'Position', get(0, 'ScreenSize')); % Maximize figure.
hold on;

i = 1;
vX = zeros(1, vNum);
vY = zeros(1, vNum);

while i <= vNum
    [vx, vy] = ginput(1);
    vX(i) = vx;
    vY(i) = vy;
    plot(vx, vy, 'ro', 'MarkerEdgeColor','r',...
                       'MarkerFaceColor','r',...
                       'MarkerSize',4);
    if i > 1
        plot(vX(i-1:i), vY(i-1:i), 'g-', 'LineWidth',2);
    end
    i = i+1;
end
plot([vX(vNum),vX(1)], [vY(vNum),vY(1)], 'g-', 'LineWidth',2);
pause(PAUSETIME/2);

%% get the stickers' coordinate in image space
global cc fc kc alpha_c Rc Tc; %#ok<*NUSED> for coordinate conversion between real world coordinate and affine coordinate
global imgOrigionalRGB imageSize imgOrigionalR imgOrigionalG imgOrigionalB

CALIB_BASE_INDEX = 25;
PARAMETERFILENAME = 'calibration\Calib_Results.mat';
load(PARAMETERFILENAME, 'cc');
load(PARAMETERFILENAME, 'fc');
load(PARAMETERFILENAME, 'kc');
load(PARAMETERFILENAME, 'alpha_c');
load(PARAMETERFILENAME, ['Rc_' num2str(CALIB_BASE_INDEX)]);
load(PARAMETERFILENAME, ['Tc_' num2str(CALIB_BASE_INDEX)]);
Rc = eval(['Rc_' num2str(CALIB_BASE_INDEX)]);
Tc = eval(['Tc_' num2str(CALIB_BASE_INDEX)]);

imgOrigionalRGB = imgFile;
imgOrigionalR = imgFile(:,:,1);
imgOrigionalG = imgFile(:,:,2);
imgOrigionalB = imgFile(:,:,3);
imageSize = size(imgOrigionalR);

RED = 1;
BLUE = 2;
redCenter = Rough_Sticker_Locate(RED);
pause(PAUSETIME);
blueCenter = Rough_Sticker_Locate(BLUE);
pause(PAUSETIME);
[rRedCenter, redCenter] = Finer_Sticker_Locate(RED, redCenter, ObjectHeight, true);    % Finer location relys on either the rough estimate of redX redY blueX blueY greenX greenY
pause(PAUSETIME);
[rBlueCenter, blueCenter] = Finer_Sticker_Locate(BLUE, blueCenter, ObjectHeight, true);   % or the finer estimate value from last step, and after finer location, the value will be 
pause(PAUSETIME);

% Real World Coordinates of the object posture
rObCenter = (rBlueCenter + rRedCenter)/2;
rObOrient = atan2(rBlueCenter(2) - rRedCenter(2), rBlueCenter(1) - rRedCenter(1)) + pi/2;
if rObOrient > pi, rObOrient = rObOrient - 2*pi; end    % standarize the orientation angle   


%% calculate the geometry

% get the vertices' real world coordinate
rVert = Coordinate_Inverse([vX; vY], ObjectHeight);
% coordinate transformation
% from global to local
tranM = [cos(rObOrient) -sin(rObOrient) rObCenter(1)
         sin(rObOrient)  cos(rObOrient) rObCenter(2)
         0               0              1];
rVert(3, :) = 1;
geoVert = tranM\rVert;

geoFile = [videoDir '\' 'geometry.txt'];
fid1 = fopen(geoFile, 'w');
fprintf(fid1, '%d\n\n', vNum);
for i=1:vNum
    fprintf(fid1, '%.2f %.2f\n', geoVert(1, i), geoVert(2, i));
end

%% calculate the center of gravity

x = geoVert(1, :);
y = geoVert(2, :);

x = [x x(1)];
y = [y y(1)];

% plot in real world size
figure, title('the shape'), hold on, axis equal;
plot(x, y, 'g-', 'LineWidth',2);

% calculate the area
area = 0;
for i=1:vNum
    area = area + 0.5*(x(i)*y(i+1) - x(i+1)*y(i));
end
disp('The area of the shape is');
disp(abs(area));

% calculate the centroid of the polygon
cx = 0;
cy = 0;
for i=1:vNum
    cx = cx+1/6/area*(x(i)+x(i+1))*(x(i)*y(i+1)-x(i+1)*y(i));
    cy = cy+1/6/area*(y(i)+y(i+1))*(x(i)*y(i+1)-x(i+1)*y(i));                
end

disp('The centroid is');
disp(cx);
disp(cy);
plot(cx, cy, 'r*');
plot(0, 0, 'bo');
fprintf(fid1, '\nGeomToBody: %.2f %.2f\n', cx, cy);
fclose(fid1);

g2bFile = [videoDir '\' 'GeomToBody.txt'];
fid1 = fopen(g2bFile, 'w');
fprintf(fid1, '%.2f %.2f\n', cx, cy);
fclose(fid1);


disp('done');


