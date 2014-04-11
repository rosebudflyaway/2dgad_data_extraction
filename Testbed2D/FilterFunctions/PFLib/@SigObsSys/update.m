function obj = update(obj)
% function obj = update(obj)
% Signal noise and observation noise are simulated, and the system
% is updated.

obj.x = obj.f(obj.x) + drawSamples(obj.w);
obj.y = obj.h(obj.x) + drawSamples(obj.v);
