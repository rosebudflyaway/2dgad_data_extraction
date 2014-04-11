%for coordinate conversion between real world coordinate and affine
%coordinate
function calibPara = loadCalibration(PARAMETERFILENAME)

if isempty(PARAMETERFILENAME)
    error('Calibration file name not specified! Please configure video processing first!')
end

load(PARAMETERFILENAME, 'cc');
load(PARAMETERFILENAME, 'fc');
load(PARAMETERFILENAME, 'kc');
load(PARAMETERFILENAME, 'alpha_c');

global CALIBBASEINDEX
load(PARAMETERFILENAME, ['Rc_' num2str(CALIBBASEINDEX)]);
load(PARAMETERFILENAME, ['Tc_' num2str(CALIBBASEINDEX)]);

Rc = eval(['Rc_' num2str(CALIBBASEINDEX)]);
Tc = eval(['Tc_' num2str(CALIBBASEINDEX)]);

calibPara.cc = cc;
calibPara.fc = fc;
calibPara.kc = kc;
calibPara.alpha_c = alpha_c;
calibPara.Rc = Rc;
calibPara.Tc = Tc;

