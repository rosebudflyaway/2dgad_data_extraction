% Generate DVC Geometry file for different round actuator fingertip
function Filename=roundfingergenerator(Offset, R, dpath, sceneName)


%% Variables Definition
PointsN = 42; % Polygon vertices' # for the finger
upperpointsN = PointsN - 2; % The # of vertices in the upper circular part 

D = 14.351; % Half of Fingertip's bottom width, units(mm) 
DB = 2*D; % Distance from fingertip's bottom to the coordinate origin( not necessarily coincides with the circle center)
HB = 3*D; % Height of the bottom square
% R = 14.351; % Fingertip upper circle's radii, units(mm)
isSQUARE = true;
sampleMode = 1; %1:equal center angle 2: equal x interval 3: equal y interval
% Offset = 0; % Offset from the actuator's center to the circle center, units(mm)
% Offset = 2.54; % 0.1 inches
% Offset = 5.08; % 0.2 inches
IR = 11.6078/2;
dpath
Filename = sprintf([dpath '/' sceneName '_actuator_%.3f_%.3f.pdat'], Offset, R);


%% Handle the square points
if R == 100 && isSQUARE
    w=14.351;
    x=[w+Offset w+Offset -w+Offset -w+Offset];
    y=[HB-DB -DB -DB HB-DB];
%     hold on
    [x y] = RotateXY(pi/2, x, y);
%     plot(x,y,'k');
%     plot(0,0,'r');
    ang=0:0.01:2*pi;
sx=IR*cos(ang);
sy=IR*sin(ang);
% plot(sx,sy,'r');
    axis equal
    fid = fopen(Filename, 'w');
    fprintf(fid, '4\n\n'); 
    for i=1:4
        fprintf(fid, '%f %f\n',x(i),y(i));
    end
    fprintf(fid, '\n\n#Finger Radii: %f Offset: %f Bottom width: %f\n', R, Offset, 2*w);
    fclose(fid);
    return;
end


%% Generate the sample points
% Generate the points in the upper circle

% This is the equal-centerangle points
if sampleMode == 1
    H = sqrt(R^2 - D^2); %
    angle = 2*asin(D/R);
    step = -angle/(upperpointsN-1);
    theta = (pi/2+angle/2):step:(pi/2-angle/2);
    x = Offset + cos(theta)*R;
    y = sin(theta)*R - H + HB - DB;
end

% This is for the equal-x points
if sampleMode == 2
    H = sqrt(R^2 - D^2); %
    step = 2*D/(upperpointsN-1);
    x0 = -D:step:D;
    x = Offset + x0;
    y = sqrt(R*R - x0.^2) - H + HB - DB;
end

% This is the equal-y points
if sampleMode == 3
    upperpointsN = upperpointsN + 1;
    PointsN = PointsN + 1;
    H = sqrt(R^2 - D^2); %
    step = 2*(R-H)/(upperpointsN-1);
    y0_left = H:step:R-step;
    y0_right = R-step:-step:H;
    y0 = [y0_left R y0_right];
    y = y0 - H + HB - DB;
    xleft = -sqrt(R*R - y0_left.^2);
    xright = +sqrt(R*R - y0_right.^2);
    x = [xleft 0 xright] + Offset;    
end

% points fr the bottom square
xLB = -D + Offset;
xRB = D + Offset;
yLB = -DB;
yRB = -DB;

% Generate the series and plot
X = [xLB' x(:)' xRB']';
Y = [yLB' y(:)' yRB']';
plot(X,Y,'b*');
hold on
plot(0,0,'r*');
axis equal

[X Y] = RotateXY(pi/2, X, Y);
plot(X,Y,'k');

ang=0:0.01:2*pi;
sx=IR*cos(ang);
sy=IR*sin(ang);
% plot(sx,sy,'r');
    

%% Write to goemetry file
fid = fopen(Filename, 'w');
fprintf(fid, '%d\n\n', PointsN); 
for i=1:size(X,1)
    fprintf(fid, '%f %f\n',X(i),Y(i));
end
fprintf(fid, '\n\n#Finger Radii: %f Offset: %f Bottom width: %f\n', R, Offset, 2*D);
fclose(fid);