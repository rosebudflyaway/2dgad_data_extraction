function [ fangle ] = formatAngle( angle, isRAD )
% format the angle to (-pi, pi] or (-180, 180]

if isRAD
    while angle > pi
        angle = angle - 2*pi;
    end
    while angle <= -pi
        angle = angle + 2*pi;
    end
else
    while angle > 180
        angle = angle - 360;
    end
    while angle <= -180
        angle = angle + 360;
    end
end

fangle = angle;

end

