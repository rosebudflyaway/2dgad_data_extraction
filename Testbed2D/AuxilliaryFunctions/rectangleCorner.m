function [ cornerF ] = rectangleCorner(center, orient, width, height, anchor)
% work out the corners' coordinates of a rectangle given posture information
% orient is in radians
% anchor denote the relative position of local coordinate system's origin
% 0 : rectangle center
% 1 : rectangle upper middle point
% 2 : rectangle bottom middle point
% 3 : rectangle left middle point
% 4 : rectangle right middle point

switch anchor,
    case 0, %center
        cornerM = [-width/2  height/2 1; 
                    width/2  height/2 1;
                    width/2 -height/2 1;
                   -width/2 -height/2 1]';
       % orient = orient*pi/180;
        transformM = [ sin(orient) cos(orient)  center(1);
                      -cos(orient) sin(orient)  center(2);
                       0           0            1       ];

        cornerF = transformM * cornerM;
    case 1, %uppercenter
        cornerM = [-width/2  0 1; 
                    width/2  0 1;
                    width/2 -height 1;
                   -width/2 -height 1]';
       % orient = orient*pi/180;
        transformM = [ sin(orient) cos(orient)  center(1);
                      -cos(orient) sin(orient)  center(2);
                       0           0            1       ];

        cornerF = transformM * cornerM;
   case 2, %bottom center
        cornerM = [-width/2  height 1; 
                    width/2  height 1;
                    width/2  0 1;
                   -width/2  0 1]';
       % orient = orient*pi/180;
        transformM = [ sin(orient) cos(orient)  center(1);
                      -cos(orient) sin(orient)  center(2);
                       0           0            1       ];

        cornerF = transformM * cornerM;
        
   case 3, %leftcenter
        cornerM = [0      height/2 1; 
                   width  height/2 1;
                   width -height/2 1;
                   0     -height/2 1]';
       % orient = orient*pi/180;
        transformM = [ sin(orient) cos(orient)  center(1);
                      -cos(orient) sin(orient)  center(2);
                       0           0            1       ];

        cornerF = transformM * cornerM;
    case 4, %rightcenter
        cornerM = [-width  height/2 1; 
                    0      height/2 1;
                    0     -height/2 1;
                   -width -height/2 1]';
       % orient = orient*pi/180;
        transformM = [ sin(orient) cos(orient)  center(1);
                      -cos(orient) sin(orient)  center(2);
                       0           0            1       ];

        cornerF = transformM * cornerM;
end
end

