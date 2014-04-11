function [fltr]  = updateOccludeWithoutTactile(fltr, aPosCtrl, lastPara)

% function fltr = updateOcclude(fltr)
% input:
% fltr: the filter object
% output:
% fltr: the updated filter object
%
% Author: Chihoon Lee, Lingji Chen
% Date  : Jan 20, 2006

% Modified by Emma Zhang
% Date: July 12, 2011

N = length(fltr.w);

%% Resample the filter
% check whether resampling is chosen, and whether it's time to resample
% if ~isempty(fltr.r_fun) && mod(fltr.counter, fltr.T) == 0
%     if(N < fltr.thresh * fltr.N ) % too few (as a result of branch-kill), rejuvenate
%         outIndex = fcn_ResampSys(fltr.w, fltr.N);
%     else
%         outIndex = fltr.r_fun(fltr.w);
%     end;
%     fltr.p = fltr.p(:, outIndex);
%     fltr.closure = fltr.closure(:, outIndex);
%     N = length(outIndex);
%     fltr.w = ones(1, N) / N;
% end;

% internally keep track of when it's time to resample
fltr.counter = fltr.counter + 1;

%% Clarify every variable and function used in the parfor loop
p = fltr.p;
f = fltr.f;
h = fltr.h;
w = fltr.w;
wp = fltr.wp;
closure = fltr.closure;
para = fltr.para;
contactMode = fltr.contactMode;
v_d = fltr.v_d;


global FRAMERATE objData actGeometry rPegsCenter pegR systemParameters
frameRate = FRAMERATE;
B1 = objData.objGeometry;
B2 = actGeometry;
fCenter = rPegsCenter;
pR = pegR;

para0 = [systemParameters.Us systemParameters.Up systemParameters.Uf systemParameters.Rtri];

global yObTraj yTactile
yTraj = yObTraj;
yTac = yTactile;

global WPara
wPara = WPara;


%% Generate noises

wPext = drawSamples(fltr.w_d, N)*0.01;
%wPext = zeros(3, N);
newPara = lastPara-para0(:);
%newPara(3) = wPara(3);

%% The parallel loop
parfor i = 1:N
    % propagate particles
    if ~closure(i)
        [p(:, i) para(:, i) contactMode(i) closure(i)] = f(p(:, i), aPosCtrl, frameRate, objData, B2, fCenter, pR, para0, wPara(:, i), wPext(:, i));
    end
    
    % noise-free y
   % y_l = h(p(:, i));
    
    % update weights
   % w(i) = w(i) * coefficientUpdateOcclude(yTraj, yTac, contactMode(i), closure(i)); %
    
   % wp(i) = wp(i) * coefficientUpdateOcclude(yTraj, yTac, contactMode(i), closure(i)); %
end;


fltr.w = w;
fltr.wp = wp;
fltr.p = p;
fltr.para = para;
fltr.contactMode = contactMode;
fltr.closure = closure;

%% Normalize the weights
sum_w = sum(fltr.w);
if sum_w <= realmin
    error('weights are numerically zero; change parameters or method.');
end;

fltr.w = fltr.w / sum_w;

sum_w = sum(fltr.wp);
if sum_w <= realmin
    error('weights are numerically zero; change parameters or method.');
end;

fltr.wp = fltr.wp / sum_w;


