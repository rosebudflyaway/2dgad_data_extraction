function [ region ] = calculateRegion( center, REGIONWIDTH, BOUNDRY )
%Calculate a region given the center, region width, and the image boundary
%   Detailed explanation goes here
x = center(1);
y = center(2);

leftX = x - REGIONWIDTH/2;
rightX = x + REGIONWIDTH/2;
upperY = y - REGIONWIDTH/2;
bottomY = y + REGIONWIDTH/2;


if leftX < BOUNDRY(1), leftX = BOUNDRY(1); end
if rightX > BOUNDRY(3), rightX = BOUNDRY(3); end
if upperY < BOUNDRY(2), upperY = BOUNDRY(2); end
if bottomY > BOUNDRY(4), bottomY = BOUNDRY(4); end

region = uint16([leftX,  upperY, rightX, bottomY]);

end

