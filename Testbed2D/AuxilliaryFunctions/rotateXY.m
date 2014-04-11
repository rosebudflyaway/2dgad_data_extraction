function [ X, Y ] = rotateXY( theta, x, y )
%RotateXY   Rotate the body coordinate frame
%
%SYNOPSIS: [X Y] = RotateXY(Theta, X, Y)
%
%INPUT:     theta - angle of rotation
%           x - x coordinate(s) of point(s) on the body
%           y - y coordinate(s) of point(s) on the body
%
%OUTPUT:    X - x coordinate(s) of point(s) after rotation
%           Y - y coordinate(s) of point(s) after rotation

x = x(:);
y = y(:);

X = x*cos(theta) + y*sin(theta);
Y = -x*sin(theta) + y*cos(theta);

end

