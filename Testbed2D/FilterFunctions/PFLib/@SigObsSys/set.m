function obj = set(obj, x)
% function obj = set(obj, x)
% Set the value of x. Useful for setting different initial values.

if length(obj.x) == length(x)
  obj.x = x;
  obj.y = obj.h(x) + drawSamples(obj.v);
else
  error('wrong size in setting the state');
end;

