function [x, para, pt, wt, P, ptPara, wtPara, contactMode, fConMode, touchMode, closure] = retrieveData(fltr, aPosCtrl)
% input: 
% fltr: the filter object
% output: 
% x : the estimated mean
% P : the estimated covariance
% pt: the particles
% wt: the weights
global DEBUG
N = numel(fltr.w);

wp = fltr.p .* repmat(fltr.w, size(fltr.p, 1), 1);
x = sum(wp, 2);
P = wp * fltr.p' - x * x';
pt = fltr.p;
wt = fltr.w;
wtPara = fltr.wp;
contactMode = fltr.contactMode;
touchMode = fltr.touchMode;
closure = fltr.closure;

wpara = fltr.para .* repmat(fltr.wp, size(fltr.para, 1), 1);
para = sum(wpara, 2);

ptPara = fltr.para;

global FRAMERATE objData actGeometry rPegsCenter pegR systemParameters
frameRate = FRAMERATE;
B1 = objData.objGeometry;
B2 = actGeometry;
fCenter = rPegsCenter;
pR = pegR;

para0 = [systemParameters.Us systemParameters.Up systemParameters.Uf systemParameters.Rtri];

 [~, ~, fConMode0, ~, fTouchMode0] = ffun_mean(x, aPosCtrl, frameRate, objData, B2, fCenter, pR, para0);
 
 fConModeCount = histc(touchMode, [0 1 2 3 4 5 6 7]);
 [~, I1] = max(fConModeCount);
 fTouchMode1 = I1 - 1;
 
 [~, I2] = max(wt);
 fTouchMode2 = contactMode(I2);

 
fConMode = fTouchMode0;
if DEBUG
fTouchMode1
fTouchMode2
end
% if fConMode0 ~= fConMode1 && fConMode1 == fConMode2
%     %fConMode = fConMode1;
%     warning(['Contact mode at the estimated pose doesnot match the highest']);
% end
    