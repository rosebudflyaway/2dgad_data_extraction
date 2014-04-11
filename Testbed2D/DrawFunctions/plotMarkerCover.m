function plotMarkerCover(figH, mCtr1, mCtr2, calibPara, objH, offset)

figure(figH);

coverRadius = 22;
coverColor = [0.514,0.455,0.333];

% Load the calibration parameter
Rc = calibPara.Rc;
Tc = calibPara.Tc;
cc = calibPara.cc;
fc = calibPara.fc;
kc = calibPara.kc;
alpha_c = calibPara.alpha_c;

% Project back to image space
mCtr1(3, :) = objH;
mCtr2(3, :) = objH; 

m1Center = project_points2(mCtr1, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);
m2Center = project_points2(mCtr2, rodrigues(Rc), Tc, fc, cc, kc, alpha_c);

m1Center = m1Center + offset(:);
m2Center = m2Center + offset(:);

rectangle('Position', [m1Center(1) - coverRadius, m1Center(2)-coverRadius, coverRadius*2, coverRadius*2], 'curvature', [1,1], 'FaceColor', coverColor, 'EdgeColor', coverColor);

rectangle('Position', [m2Center(1) - coverRadius, m2Center(2)-coverRadius, coverRadius*2, coverRadius*2], 'curvature', [1,1], 'FaceColor', coverColor, 'EdgeColor', coverColor);


end