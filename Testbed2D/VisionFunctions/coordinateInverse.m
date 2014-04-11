function xx_m = coordinateInverse(x_kk_m, Z_BASE, calibPara)
% convert coodinate from image space to real world

%% Set Extrinsic Parameters

Rc = calibPara.Rc;
Tc = calibPara.Tc;
cc = calibPara.cc;
fc = calibPara.fc;
kc = calibPara.kc;
alpha_c = calibPara.alpha_c;


%% handle multiple points
xn_m = normalize(x_kk_m,fc,cc,kc,alpha_c);

dim = size(xn_m);
xn_3_m = [xn_m; ones(1,dim(2))];

Temp_m = Rc\xn_3_m;
Temp2_m = (-1)*(Rc\Tc);

zc_m = zeros(dim(2), 1);
xxc_m = zeros(3, dim(2));
xx_m = zeros(3, dim(2));

for i=1:dim(2)
    zc_m(i) = (Z_BASE - Temp2_m(3)) / Temp_m(3,i);
    xxc_m(:,i) = xn_3_m(:,i) * zc_m(i);
    xx_m(:,i) = Rc\xxc_m(:,i) + Temp2_m;
end

return;
