function plotRectangle(corner, Hnd)
% update a rectangle plot using new corner data

x = corner(1,:);
y = corner(2,:);
X = [x x(1)];
Y = [y y(1)];

set(Hnd, 'XData', X, 'YData', Y);
end

