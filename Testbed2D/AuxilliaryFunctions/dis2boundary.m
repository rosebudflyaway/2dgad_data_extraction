function [ minDis ] = dis2boundary( point, pXY, pTheta, polygon)
% Calculate the distance from point to the polygon centered at pXY
% pXY is the polygon's center coordinate
% polygon is the geometry data of the polygon

% transform polygon from local coordinate to global coordinate

polygonG = local2global( polygon, pXY(1), pXY(2), pTheta );

polygonN = size(polygonG, 1);

% calculate distance from point to all segment, find the smallest
minDis = 10000;
for i=1:polygonN
    if i <= polygonN-1
        dis = dis2Segment( point, polygonG(i, :), polygonG(i+1, :));
    else
        dis = dis2Segment( point, polygonG(i, :), polygonG(1, :));  
    end
    if dis < minDis
        minDis = dis;
    end
end


