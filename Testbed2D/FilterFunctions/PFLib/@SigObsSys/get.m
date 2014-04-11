function [x, y, f, h, w, v, df, dh] = get(obj)
% function [x, y, f, h, w, v] = get(obj)
% Read out the object's components

x = obj.x;
y = obj.y;
f = obj.f;
h = obj.h;
w = obj.w;
v = obj.v;
df = obj.df;
dh = obj.dh;

