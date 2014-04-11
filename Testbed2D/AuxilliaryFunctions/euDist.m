function d = EuDist(x, y)
% Calculate the Euclidean distance between vection x and y
x = x(:);
y = y(:);
m = size(x, 1);

t = abs(x - y);
d = sqrt(sum(t.^2));

end