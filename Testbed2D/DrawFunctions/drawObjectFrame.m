function drawObjectFrame(redC, blueC, rCenter, rTheta, Z)
% plot the local frame on the object
% redC : the center coordinate of red sticker
% blueC : the center coordinate of blue sticker
% rCenter : the real world coordinate of the center of the object
% rTheta : the real world orientation of the object
% Z : the surface height in real world


persistent hnd0 hnd1 hnd2 hnd3 hnd4 hnd5
% DELTA = 12;  % text distance from the axis
%% draw the axes      

middleC = (redC + blueC)/2;

xO = middleC(1); % red sticker set as the origin
yO = middleC(2);

xY = redC(1);
yY = redC(2);

T = [xY-xO, yY-yO]*[0 1;-1 0]; %rotate 90 counterclockwise to get y axis

xX = xO + T(1);
yX = yO + T(2);

tmp = [xX-xO yX-yO]; %unify the length
orientX = tmp./sqrt(sum(tmp.*tmp));

tmp = [xY-xO yY-yO];
orientY = tmp./sqrt(sum(tmp.*tmp)); 

if isempty(hnd1)
  %  hnd0 = plot([redC(1); blueC(1)], [redC(2); blueC(2)], 'y-', 'linewidth', 2);
    hnd1 = quiver(xO, yO, orientX(1), orientX(2), 60, '-b', 'LineWidth', 2);
    hnd2 = quiver(xO, yO, orientY(1), orientY(2), 60, '-b', 'LineWidth', 2); 
else
   % set(hnd0, 'XData', [redC(1); blueC(1)], 'YData', [redC(2); blueC(2)]);
    set(hnd1, 'XData', xO, 'YData', yO, 'UData', orientX(1), 'VData', orientX(2));
    set(hnd2, 'XData', xO, 'YData', yO, 'UData', orientY(1), 'VData', orientY(2));
end

%% output the frame text

% Locate the origin point's annotation position
% cX1 = (xX + xY)/2;
% cY1 = (yX + yY)/2;
% t1 = [xO-cX1, yO-cY1];
% uO = t1/norm(t1,2);
% text(xO + DELTA/2*uO(1),yO + DELTA/2*uO(2),'o','color','y','Fontsize',10);
% 
% % Locate the x axis' annotation position
% cX2 = (xO+xX)/2;
% cY2 = (yO+yX)/2;
% t2 = [cX2-xO, cY2-yO]*[0 1; -1 0];
% uX = t2/norm(t2,2);
% text(xX + DELTA*uX(1), yX + DELTA*uX(2), 'x','color','y','Fontsize',10);
% 
% % Locate the y axis' annotation position
% cX3 = (xO+xY)/2;
% cY3 = (yO+yY)/2;
% t3 = [cX3-xO, cY3-yO]*[0 -1; 1 0];
% uY = t3/norm(t3,2);
% text(xY + DELTA*uY(1), yY + DELTA*uY(2), 'y','color','y','Fontsize',10);

% %% Draw the centroid and head vector of the object
% 
% obCenterX = (redC(1) + blueC(1))/2;
% obCenterY = (redC(2) + blueC(2))/2;
% obOrient = [blueC(1)-redC(1), blueC(2)-redC(2)]*[0 -1; 1 0];
% obOrient = obOrient/norm(obOrient,2);   % unify the orientation vector
% if isempty(hnd3)
% hnd3 = plot(obCenterX,obCenterY,'o','LineWidth',1,...
%                           'MarkerEdgeColor','k',...
%                           'MarkerFaceColor','k',...
%                           'MarkerSize',5);
% else
%     set(hnd3, 'XData', obCenterX, 'YData', obCenterY);
% end
% 
% if isempty(hnd4)
%     hnd4 = quiver(obCenterX, obCenterY, obOrient(1), obOrient(2), 120, '-k','LineWidth',2);
% else
%     set(hnd4, 'XData', obCenterX, 'YData', obCenterY, 'UData', obOrient(1), 'VData', obOrient(2));
% end
% 
% %% Output the description text for the object 
% temp = strcat('Object Center:  ', '(', num2str(rCenter(1)), ', ', ...
%                                num2str(rCenter(2)), ', ', num2str(Z),'), Angle:  ', ...
%                                num2str(rTheta));
% if isempty(hnd5)                        
%     hnd5 = text(768, 788, temp, 'color', 'k', 'Fontsize', 9);
% else
%     set(hnd5, 'String', temp);
% end
% %uC = -1*obOrient;  
% % Locate the centroid annotation position
% % Locate the orientation annotation position
% %text(obCenterX + DELTA*uC(1), obCenterY + DELTA*uC(2), ...
% %     temp1, 'color', 'y', 'Fontsize', 8);
% %text(obCenterX + DELTA*uC(1), obCenterY + DELTA*uC(2) + DELTA, ...
% %    temp2, 'color', 'y', 'Fontsize', 8);
end