function [ dis ] = dis2Segment( p, p1, p2 )
% calculate the distance from point p to segment (p1, p2)
%   Detailed explanation goes here

v = p2 - p1;
w = p - p1;

c1 = sum(w.*v);
if c1 <= 0
    dis = norm(p-p1, 2);
    return
end

c2 = sum(v.*v);
if c2 <= c1
    dis = norm(p-p2, 2);
    return
end

b = c1 / c2;
pb = p1 + b*v;
dis = norm(p-pb, 2);


end

