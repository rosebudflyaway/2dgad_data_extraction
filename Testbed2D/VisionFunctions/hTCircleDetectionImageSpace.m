function [center, R, x, y] = hTCircleDetectionImageSpace(I)
% return the circle center in the real world

   STABLERADDIF = 0.5;
   
%% Find the edge from the graph through finding 1 in the bw image
   [y, x]= find(I); %return row and column indexes

   
%% calculate the coefficients of the equation
% x^2 + y^2 + a(1)*x + a(2)*y + a(3) = 0

% calculate the center first
   a = [x y ones(size(x))]\(-(x.^2+y.^2));
   centerX = -.5*a(1);
   centerY = -.5*a(2);
   R = sqrt((a(1)^2+a(2)^2)/4 - a(3));
   
% remove points that're too far from the center
   dis2Center = sqrt((x-centerX).^2+(y-centerY).^2);
   
   possibleInd = (dis2Center <= max(mean(dis2Center),(mean(dis2Center) + R)/2.0));
   x = x(possibleInd);
   y = y(possibleInd);
   a = [x y ones(size(x))]\(-(x.^2+y.^2));
   centerX = -.5*a(1);
   centerY = -.5*a(2);
   center = [centerX centerY]';
   newR = sqrt((a(1)^2+a(2)^2)/4 - a(3));
       
   while ( abs(R-newR) > STABLERADDIF)
       R = newR;
       dis2Center = sqrt((x-centerX).^2+(y-centerY).^2);
       possibleInd = (dis2Center <max(mean(dis2Center),(mean(dis2Center) + R)/2.0));
       x = x(possibleInd);
       y = y(possibleInd);
       if numel(x) < 3 || numel(y) < 3, break; end 
       a=[x y ones(size(x))]\(-(x.^2+y.^2));
       centerX = -.5*a(1);
       centerY = -.5*a(2);
       center = [centerX centerY]';
       newR = sqrt((a(1)^2+a(2)^2)/4 - a(3));
   end
end