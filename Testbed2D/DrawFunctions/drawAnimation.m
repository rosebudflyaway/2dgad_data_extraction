function drawAnimation(outputVideoFile, gCtr, gOrient, oCtr, oOrient, pegCenter, objGeometry, actGeometry, overlayWithImage, calibPara, objH, actH, imageFileList)
% Three ways to call the function
%
% drawAnimation(gCtr, gOrient, oCtr, oOrient, pegCenter, objGeometry,
% actGeometry, false);
%
% drawAnimation(gCtr, gOrient, oCtr, oOrient, pegCenter, objGeometry,
% actGeometry, true, calibPara, objH, actH, imageFileList)
%
% drawAnimation(gCtr, gOrient, oCtr, oOrient, pegCenter, objGeometry,
% actGeometry, true, calibPara, objH, actH, imageFileList, outputVideoFile)
%
%
global pegH SIMPAUSETIME lineWidth sensorReads;

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

if ~isempty(outputVideoFile)
    mov = avifile(outputVideoFile,'compression','none');
    %makes outputVideoFile w/ Indeo 5
end
if overlayWithImage
    
    % Load the calibration parameter
    Rc = calibPara.Rc;
    Tc = calibPara.Tc;
    cc = calibPara.cc;
    fc = calibPara.fc;
    kc = calibPara.kc;
    alpha_c = calibPara.alpha_c;
    
    % Load the image and display
    hf = figure;
    imgOrigionalRGB = imread(imageFileList{1});
    fHdl = imshow(imgOrigionalRGB);
    hold on;
    drawGridFrame;
    
    frameN = size(imageFileList, 1);
else
    hf = figure; hold on, axis equal, axis([-100 300 -100 300]);
    frameN = numel(oOrient);
end
tN = size(sensorReads, 1);
sensorReadModes = sensorReads(:, 1) * 4 + sensorReads(:, 2) * 2 + sensorReads(:, 3) * 1;

sHnd1 = plot(1,1,'r','LineWidth',lineWidth);
sHnd2 = plot(1,1,'b','LineWidth',lineWidth);
sHnd3 = plot(1,1,'g','LineWidth',lineWidth);
sHnd4 = plot(1,1,'g','LineWidth',lineWidth);
sHnd5 = plot(1,1,'g','LineWidth',lineWidth);


dataN = numel(oOrient);

bigN = max(frameN, dataN);

for j = 1:bigN

    oI = j;
    fI = j;
    
    if oI > dataN
        oI = dataN;
    end
    
    if fI > frameN
        fI = frameN;
    end
    
    disp(['step' num2str(j)]);
    
    % Calculate the corner in real world
    oCorner = cornerConversion(oCtr(oI, 1:2), oOrient(oI), objGeometry');
    aCorner = cornerConversion(gCtr(oI, 1:2), gOrient, actGeometry');
    f1Corner = cornerConversion(pegCenter(1, 1:2), 0, B3');
    f2Corner = cornerConversion(pegCenter(2, 1:2), 0, B3');
    f3Corner = cornerConversion(pegCenter(3, 1:2), 0, B3');
    
    if overlayWithImage
        imgOrigionalRGB = imread(imageFileList{fI});
        set(fHdl, 'CData', imgOrigionalRGB);
        % Project back to image space
        oCorner(3, :) = objH; aCorner(3, :) = actH; f1Corner(3, :) = pegH; f2Corner(3, :) = pegH; f3Corner(3, :) = pegH;
        oCorner = project_points2(oCorner, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
        aCorner = project_points2(aCorner, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
        f1Corner = project_points2(f1Corner, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
        f2Corner = project_points2(f2Corner, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
        f3Corner = project_points2(f3Corner, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
    end
    
    % Plot rectangle
    plotRectangle(oCorner, sHnd1);
    plotRectangle(aCorner, sHnd2);
    plotRectangle(f1Corner, sHnd3);
    plotRectangle(f2Corner, sHnd4);
    plotRectangle(f3Corner, sHnd5);
    
    if j <= tN
        title(contactMode2Str(sensorReadModes(j)));
    else
        title('');
    end
    if  ~isempty(outputVideoFile)
        f2 = getframe(hf); % gets the gcf
        mov = addframe(mov,f2); % adds the frame into mov
    end    
    pause(SIMPAUSETIME);
    closeToTouch = j+5;
    if closeToTouch > numel(sensorReadModes)
        closeToTouch = numel(sensorReadModes);
    end
%     if j > tN || sensorReadModes(closeToTouch) > 0
%         evalResponse = input('Press any key to continue');
%     end
end
if ~isempty(outputVideoFile)
    mov = close(mov); % closes the mov
end
end