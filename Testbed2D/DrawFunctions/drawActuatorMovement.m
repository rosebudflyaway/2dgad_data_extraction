function  drawActuatorMovement(greenC, rCenter, ZA)
% keep record of actuator movement history and plot the actuator movement
% greenC : green sticker's coordinate
% rCenter : real world coodinate
% ZA : real world height
persistent hnd hnd2 hnd3
persistent count greenCord 
FPS = 30;

%% Keep record of all the positions

if isempty(count)
    count = 1;
    greenCord = zeros(2, 500);
else
    count = count + 1;
end
greenCord(:,count) = greenC(:);
gRH(:, count) = greenC(:);


%% Do filtering to get the actuator direction
if count >= 2
    
    %Calculate the parameters in pixel coordinates
    polyCoef = polyfit(greenCord(1,1:count), greenCord(2,1:count), 1);
    xx = [greenCord(1,1) greenCord(1,count)];
    yy = polyval(polyCoef, xx);
    orient = [xx(2) - xx(1), yy(2) - yy(1)];
    orient = orient ./ norm(orient, 2); %unify the length
    if isempty(hnd3)
        hnd3 = quiver(greenC(1), greenC(2), orient(1), orient(2), 100, '-w','LineWidth',2);
    else
        set(hnd3, 'XData', greenC(1), 'YData', greenC(2), 'UData', orient(1), 'VData', orient(2));
    end    
end

% %% Plot the centroid
if isempty(hnd)
    hnd = plot(greenC(1), greenC(2),'o','LineWidth',1,...
                          'MarkerEdgeColor','w',...
                          'MarkerFaceColor','w',...
                          'MarkerSize',5);
else
    set(hnd, 'XData', greenC(1), 'YData', greenC(2));
end

%% Output the real world coordinates below the graph
temp = strcat('Actuator:  ', '(', num2str(rCenter(1)), ', ', ...
                               num2str(rCenter(2)), ', ', num2str(ZA),')');
if isempty(hnd2)                        
    hnd2 = text(768, 800, temp, 'color', 'k', 'Fontsize', 9);
else
    set(hnd2, 'String', temp);
end
  
end
