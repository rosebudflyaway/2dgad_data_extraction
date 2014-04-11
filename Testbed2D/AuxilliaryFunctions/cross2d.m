% Computes a 2D cross product between two vectors
% The vectors must be of size 2
function z = cross2d(x, y)
z = x(1) * y(2) - x(2) * y(1); 
end