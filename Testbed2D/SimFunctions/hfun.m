function y = hfun(x)
x=x(:)';
vel = x(4)*x(5)*x(6);
if vel >= 1e-5
    isStop = false;
else
    isStop = true;
end
y = [x(1:3) isStop]';