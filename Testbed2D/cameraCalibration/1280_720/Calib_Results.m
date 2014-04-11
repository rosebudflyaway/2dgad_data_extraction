% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 944.704510580641570 ; 952.718346152756680 ];

%-- Principal point:
cc = [ 644.739931577788750 ; 371.177521585005540 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ 0.000000000000000 ; -0.053570849040121 ; -0.000000000000000 ; 0.000000000000000 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 2.093958403828091 ; 2.127759280631940 ];

%-- Principal point uncertainty:
cc_error = [ 1.332454797657499 ; 1.140810235618881 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.000000000000000 ; 0.006235496189086 ; 0.000000000000000 ; 0.000000000000000 ; 0.000000000000000 ];

%-- Image size:
nx = 1280;
ny = 720;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 15;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 0 ; 1 ; 0 ; 0 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ 3.066163e+000 ; 3.637048e-001 ; -1.985532e-002 ];
Tc_1  = [ -8.281480e+001 ; 1.066073e+002 ; 5.152419e+002 ];
omc_error_1 = [ 2.450103e-003 ; 5.920417e-004 ; 3.887979e-003 ];
Tc_error_1  = [ 7.327620e-001 ; 6.296185e-001 ; 1.246471e+000 ];

%-- Image #2:
omc_2 = [ 2.017422e+000 ; -1.232040e+000 ; 6.527181e-001 ];
Tc_2  = [ -4.496790e+001 ; 1.265253e+002 ; 6.115767e+002 ];
omc_error_2 = [ 1.634173e-003 ; 1.378425e-003 ; 2.278937e-003 ];
Tc_error_2  = [ 8.979615e-001 ; 7.347698e-001 ; 1.739838e+000 ];

%-- Image #3:
omc_3 = [ -2.203000e+000 ; 2.133024e+000 ; -2.562547e-001 ];
Tc_3  = [ 1.020580e+002 ; 1.461937e+002 ; 7.794998e+002 ];
omc_error_3 = [ 3.382374e-003 ; 3.435156e-003 ; 7.201472e-003 ];
Tc_error_3  = [ 1.088359e+000 ; 9.318091e-001 ; 1.922829e+000 ];

%-- Image #4:
omc_4 = [ -2.195334e+000 ; 1.712839e+000 ; 4.868727e-001 ];
Tc_4  = [ 6.075160e+001 ; 1.906944e+002 ; 7.979786e+002 ];
omc_error_4 = [ 1.720689e-003 ; 1.754602e-003 ; 3.005774e-003 ];
Tc_error_4  = [ 1.120221e+000 ; 9.400214e-001 ; 1.777493e+000 ];

%-- Image #5:
omc_5 = [ -2.000752e+000 ; 1.774815e+000 ; -7.459261e-001 ];
Tc_5  = [ 4.684381e+001 ; 1.544177e+002 ; 8.747933e+002 ];
omc_error_5 = [ 2.073489e-003 ; 1.729747e-003 ; 3.196458e-003 ];
Tc_error_5  = [ 1.240269e+000 ; 1.039110e+000 ; 1.976984e+000 ];

%-- Image #6:
omc_6 = [ 1.798049e+000 ; -1.503331e+000 ; -1.557581e-001 ];
Tc_6  = [ -2.447655e+001 ; 1.430768e+002 ; 7.717469e+002 ];
omc_error_6 = [ 1.703772e-003 ; 1.493326e-003 ; 2.506716e-003 ];
Tc_error_6  = [ 1.110395e+000 ; 9.382992e-001 ; 2.161174e+000 ];

%-- Image #7:
omc_7 = [ 1.942466e+000 ; -1.963667e+000 ; 4.185413e-001 ];
Tc_7  = [ 7.556795e+001 ; 2.317004e+002 ; 7.422706e+002 ];
omc_error_7 = [ 2.817638e-003 ; 2.546684e-003 ; 5.195796e-003 ];
Tc_error_7  = [ 1.060390e+000 ; 9.344331e-001 ; 2.019111e+000 ];

%-- Image #8:
omc_8 = [ -1.706795e+000 ; 1.752598e+000 ; 4.417143e-001 ];
Tc_8  = [ 4.624379e+001 ; 8.379097e+001 ; 7.948945e+002 ];
omc_error_8 = [ 1.326855e-003 ; 1.666916e-003 ; 2.345185e-003 ];
Tc_error_8  = [ 1.119327e+000 ; 9.551399e-001 ; 1.603353e+000 ];

%-- Image #9:
omc_9 = [ 2.117633e+000 ; -1.820125e+000 ; 7.453693e-002 ];
Tc_9  = [ 3.231804e+001 ; 8.489044e+001 ; 5.292043e+002 ];
omc_error_9 = [ 1.505923e-003 ; 1.361849e-003 ; 2.754813e-003 ];
Tc_error_9  = [ 7.626465e-001 ; 6.530864e-001 ; 1.373784e+000 ];

%-- Image #10:
omc_10 = [ -2.219461e+000 ; 1.561687e+000 ; 5.561060e-002 ];
Tc_10  = [ 2.499556e+001 ; 1.412203e+002 ; 5.912913e+002 ];
omc_error_10 = [ 1.647225e-003 ; 1.382947e-003 ; 2.588256e-003 ];
Tc_error_10  = [ 8.153781e-001 ; 6.902974e-001 ; 1.256465e+000 ];

%-- Image #11:
omc_11 = [ -1.982775e+000 ; 1.978665e+000 ; 8.550574e-001 ];
Tc_11  = [ 1.687232e+001 ; 1.110365e+002 ; 5.426718e+002 ];
omc_error_11 = [ 9.195166e-004 ; 1.435294e-003 ; 2.112835e-003 ];
Tc_error_11  = [ 7.677274e-001 ; 6.312357e-001 ; 1.207153e+000 ];

%-- Image #12:
omc_12 = [ 1.917924e+000 ; -1.813969e+000 ; -6.329771e-001 ];
Tc_12  = [ 4.033712e+001 ; 9.099706e+001 ; 5.317754e+002 ];
omc_error_12 = [ 1.457117e-003 ; 1.249104e-003 ; 2.236939e-003 ];
Tc_error_12  = [ 7.608506e-001 ; 6.398499e-001 ; 1.392809e+000 ];

%-- Image #13:
omc_13 = [ -1.751453e+000 ; 1.980877e+000 ; -4.637291e-001 ];
Tc_13  = [ 2.340902e+001 ; 1.008374e+002 ; 5.218811e+002 ];
omc_error_13 = [ 1.460101e-003 ; 1.600365e-003 ; 2.350986e-003 ];
Tc_error_13  = [ 7.437075e-001 ; 5.899475e-001 ; 1.063063e+000 ];

%-- Image #14:
omc_14 = [ -1.736381e+000 ; 1.769269e+000 ; 3.624185e-001 ];
Tc_14  = [ 2.378550e+001 ; 7.565431e+001 ; 5.555424e+002 ];
omc_error_14 = [ 1.116511e-003 ; 1.446886e-003 ; 1.925641e-003 ];
Tc_error_14  = [ 7.710125e-001 ; 6.613966e-001 ; 1.053097e+000 ];

%-- Image #15:
omc_15 = [ -1.743857e+000 ; 2.583624e+000 ; 1.119208e-001 ];
Tc_15  = [ 7.909392e+001 ; 7.635669e+001 ; 4.813969e+002 ];
omc_error_15 = [ 1.112038e-003 ; 1.832232e-003 ; 3.051399e-003 ];
Tc_error_15  = [ 6.817189e-001 ; 5.758714e-001 ; 1.149340e+000 ];

