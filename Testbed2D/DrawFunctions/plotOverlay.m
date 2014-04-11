function [figH offset] = plotOverlay(gCtr, gOrient, oCtr, oOrient, pegCenter, objGeometry, actGeometry, calibPara, objH, actH, imageFile, cropOrNot, cropDimension, occludedOrNot, rRedCenter, rBlueCenter)

global pegH overlayLineWidth DEBUG cropRegion lineColor;
font  = 'Times New Roman';
fontsize = 13;
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

% Load the calibration parameter
Rc = calibPara.Rc;
Tc = calibPara.Tc;
cc = calibPara.cc;
fc = calibPara.fc;
kc = calibPara.kc;
alpha_c = calibPara.alpha_c;


% Calculate the corner in real world
oCorner = cornerConversion(oCtr(1:2), oOrient, objGeometry');
aCorner = cornerConversion(gCtr(1:2), gOrient, actGeometry');
f1Corner = cornerConversion(pegCenter(1, 1:2), 0, B3');
f2Corner = cornerConversion(pegCenter(2, 1:2), 0, B3');
f3Corner = cornerConversion(pegCenter(3, 1:2), 0, B3');

% Project back to image space
oCorner(3, :) = objH; aCorner(3, :) = actH; f1Corner(3, :) = pegH; f2Corner(3, :) = pegH; f3Corner(3, :) = pegH;
oCorner = project_points2(oCorner, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
aCorner = project_points2(aCorner, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
f1Corner = project_points2(f1Corner, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
f2Corner = project_points2(f2Corner, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
f3Corner = project_points2(f3Corner, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);

oCenter = oCtr(:);
oCenter(3) = objH;
aCenter = gCtr(:);
aCenter(3) = actH;
f1Center = pegCenter(1, 1:2)';
f1Center(3) = pegH;
f2Center = pegCenter(2, 1:2)';
f2Center(3) = pegH;
f3Center = pegCenter(3, 1:2)';
f3Center(3) = pegH;
oCenter = project_points2(oCenter, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
aCenter = project_points2(aCenter, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
f1Center = project_points2(f1Center, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
f2Center = project_points2(f2Center, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
f3Center = project_points2(f3Center, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);

% Load the image and display
if ~DEBUG
    figH = fig('units', 'pixels', 'width', 500, 'height', 600, 'font',font,'fontsize',fontsize);
    %subplot_tight(1, 1, 1);
else
    figH = figure;
end
imgOrigionalRGB = imread(imageFile);



if cropOrNot
    picCenter = oCenter;
    if isempty(cropRegion)
        cropRegion = double(calculateRegion2( picCenter, cropDimension, [1 1 size(imgOrigionalRGB, 2) size(imgOrigionalRGB, 1)]));
    end
    imshow(imgOrigionalRGB(cropRegion(2):cropRegion(4), cropRegion(1):cropRegion(3), :), 'Border', 'loose', 'InitialMagnification', 64);
    hold on;
    
    offset = [-cropRegion(1)+1 -cropRegion(2)+1]';
    
    if occludedOrNot
        plotMarkerCover(figH, rRedCenter', rBlueCenter', calibPara, objH, offset);
    end
    
%     sHnd2 = plot(1,1,'b','LineWidth',overlayLineWidth);
    sHnd1 = plot(1,1,lineColor,'LineWidth',overlayLineWidth);
%     sHnd3 = plot(1,1,'g','LineWidth',overlayLineWidth);
%     sHnd4 = plot(1,1,'g','LineWidth',overlayLineWidth);
%     sHnd5 = plot(1,1,'g','LineWidth',overlayLineWidth);
%     
    
    plotRectangle(oCorner + repmat(offset, 1, size(oCorner, 2)), sHnd1);
%     plotRectangle(aCorner + repmat(offset, 1, size(aCorner, 2)), sHnd2);
%     plotRectangle(f1Corner + repmat(offset, 1, size(f1Corner, 2)), sHnd3);
%     plotRectangle(f2Corner + repmat(offset, 1, size(f2Corner, 2)), sHnd4);
%     plotRectangle(f3Corner + repmat(offset, 1, size(f3Corner, 2)), sHnd5);
    
else
    imshow(imgOrigionalRGB);
    hold on;
    
    offset = [0 0]';
    
    if occludedOrNot
        plotMarkerCover(figH, rRedCenter', rBlueCenter', calibPara, objH, offset);
    end
    
    sHnd2 = plot(1,1,'b','LineWidth',overlayLineWidth);
    sHnd1 = plot(1,1,'r','LineWidth',overlayLineWidth);
    sHnd3 = plot(1,1,'g','LineWidth',overlayLineWidth);
    sHnd4 = plot(1,1,'g','LineWidth',overlayLineWidth);
    sHnd5 = plot(1,1,'g','LineWidth',overlayLineWidth);
    
    % Plot rectangle
    plotRectangle(oCorner, sHnd1);
    plotRectangle(aCorner, sHnd2);
    plotRectangle(f1Corner, sHnd3);
    plotRectangle(f2Corner, sHnd4);
    plotRectangle(f3Corner, sHnd5);
end

end