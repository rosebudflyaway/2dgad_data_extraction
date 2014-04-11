function [ cornerF ] = cornerConversion(center, orient, cornerM)
% the coordinate transformation of corners
% orient is in radian, cornerM is coordinates in local coordinate system
% center is the local frame origin's position in global frame

cornerM(3,:) = 1;

% orient = orient*pi/180;
transformM = [ cos(orient) -sin(orient)  center(1);
               sin(orient)  cos(orient)  center(2);
               0            0            1       ];

cornerF = transformM * cornerM;

end

