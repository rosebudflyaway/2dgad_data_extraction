function plotPolygon(verts, geomCenterPos)
% UNTITLED Summary of this function goes here
% Detailed explanation goes here

% load the data

   orient = geomCenterPos(3);
% convert the corners 
   verts(3, :) = 1;   
   transformM = [ cos(orient) -sin(orient)  geomCenterPos(1);
                  sin(orient)  cos(orient)  geomCenterPos(2);
                  0            0            1       ];
   cornerF = transformM * verts;
   cornerF = [cornerF cornerF(:,1)]; 
% plot the 
   plot(cornerF(1,:), cornerF(2,:));
   hold on;
   plot(geomCenterPos(1), geomCenterPos(2), 'r*');
   axis equal
   
end

