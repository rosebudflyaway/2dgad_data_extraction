function [ STARTID ENDID ] = locateTimeRange( vel )
% Given the speed seri, locate the stable moving range

vel = vel(:);

stableSpeed = median(vel);


% compare to the stable speed
thresh = stableSpeed * 0.05; % threshold to decide whether the speed enters the stable phase
ind = abs(vel - stableSpeed) < thresh;

if sum(ind) < 0.15*numel(vel) % the mean value is not a good estimate 
   stableSpeed = vel(floor(numel(vel)/2)); 
   ind = abs(vel - stableSpeed) < thresh;
end

% Split the seri in half
len = size(vel, 1);
halfLen = floor(len/2);


% find the end of a long unstable range in the first half of the seri
unstableEnd = 0;
for i = 1: halfLen
    if ind(i) == 0 && (unstableEnd + 1 == i || ind(i-1) == 0)
        unstableEnd = i;
    end
end
STARTID = unstableEnd + 1;

% find the start of the last deccelarating phase
thresh = - stableSpeed * 0.05; % threshold to decide whether the speed enters the stable phase
ind = (vel - stableSpeed < thresh);
unstableStart = len + 1;
for i = len:-1:halfLen+1
    if ind(i) == 1 && (unstableStart - 1 == i)
        unstableStart = i;
    end
end
ENDID = unstableStart -1;

end

