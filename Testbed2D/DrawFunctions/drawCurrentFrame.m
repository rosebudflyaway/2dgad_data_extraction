function drawCurrentFrame(figureH, aPosCtrl, objPos, fixels)

global sHnd1 sHnd2 sHnd3 sHnd4 sHnd5
global figH
global pegH SIMPAUSETIME lineWidth;
global objGeometry actGeometry

B3 =    [   4.76 -0.00;
    4.53 -1.47;
    3.85 -2.80;
    2.80 -3.85;
    1.47 -4.53;
    0.00 -4.76;
    -1.47 -4.53;
    -2.80 -3.85;
    -3.85 -2.80;
    -4.53 -1.47;
    -4.76 -0.00;
    -4.53 1.47;
    -3.85 2.80;
    -2.80 3.85;
    -1.47 4.53;
    -0.00 4.76;
    1.47 4.53;
    2.80 3.85;
    3.85 2.80;
    4.53 1.47;];

B1 = objGeometry;
B2 = actGeometry;




subplot(figureH);
hold on, axis equal, axis([-180 120 -50 250]);
if isempty(sHnd1) || isempty(figH) || figH ~= figureH
    sHnd1 = plot(1,1,'r','LineWidth',2);
    sHnd2 = plot(1,1,'b','LineWidth',2);
    sHnd3 = plot(1,1,'g','LineWidth',2);
    sHnd4 = plot(1,1,'g','LineWidth',2);
    sHnd5 = plot(1,1,'g','LineWidth',2);
    figH = figureH;
end
% Calculate the corner in real world
sObjectCorner = cornerConversion(objPos(1:2), objPos(3), B1');
sActuatorCorner = cornerConversion(aPosCtrl(1, 1:2), aPosCtrl(1,3), B2');
sFixel1Corner = cornerConversion(fixels(1, 1:2), 0, B3');
sFixel2Corner = cornerConversion(fixels(2, 1:2), 0, B3');
sFixel3Corner = cornerConversion(fixels(3, 1:2), 0, B3');

% Plot rectangle
plotRectangle(sObjectCorner, sHnd1);
plotRectangle(sActuatorCorner, sHnd2);
plotRectangle(sFixel1Corner, sHnd3);
plotRectangle(sFixel2Corner, sHnd4);
plotRectangle(sFixel3Corner, sHnd5);

end