function drawArrow(startX, startY, endX, endY, varargin)
% plot arrow and support the definition of line style 

rotateAngle = pi/6;
length = 12;

orient = [startX-endX, startY-endY];
orient = orient/norm(orient, 2);

upSideOrient = orient*[cos(rotateAngle) sin(rotateAngle);
                      -sin(rotateAngle) cos(rotateAngle)];
                  
downSideOrient = orient*[cos(rotateAngle) -sin(rotateAngle);
                         sin(rotateAngle) cos(rotateAngle)];

upEnd = [endX endY] + upSideOrient * length;
downEnd = [endX endY] + downSideOrient * length;

hold on;
plot([startX; endX], [startY; endY], varargin{:});
plot([endX; upEnd(1)], [endY; upEnd(2)], varargin{:});
%plot([upEnd(1); downEnd(1)], [upEnd(2); downEnd(2)], varargin{:});
plot([endX; downEnd(1)], [endY; downEnd(2)], varargin{:});

end