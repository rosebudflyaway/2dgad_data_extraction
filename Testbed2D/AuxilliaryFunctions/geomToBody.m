function [ bCenter] = geomToBody( gCenter, orient, g2b )
% work out the center of gravity's coordinate based on its posture

g2b = g2b(:);
g2b(3,:) = 1;

transformM = [ cos(orient) -sin(orient)  gCenter(1);
               sin(orient)  cos(orient)  gCenter(2);
               0            0            1       ];

bCenter = transformM * g2b;
bCenter = bCenter(1:2);
end

