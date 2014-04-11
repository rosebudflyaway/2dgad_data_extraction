% Rotate a 2D vector 90 degrees counterclockwise. 
function y = Rotate_Half_Pi(x)
y = x;
y(1) =  x(2);
y(2) = -x(1);
end