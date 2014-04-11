function [ gCenter] = bodyToGeom( bCenter, orient, g2b )
% work out the center of gravity's coordinate based on its posture

g2b = g2b(:);
b2g = -g2b;
b2g(3,:) = 1;

transformM = [ cos(orient) -sin(orient)  bCenter(1);
               sin(orient)  cos(orient)  bCenter(2);
               0            0            1       ];

gCenter = transformM * b2g;
gCenter = gCenter(1:2)';
end

