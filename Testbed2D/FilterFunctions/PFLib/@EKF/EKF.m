function fltr = EKF(sys, init_distr)
% function fltr = EKF(sys, init_distr)
% EKF: class constructor for Extended Kalman Filter
% 
% sys       : a SigObsSys object with Jacobians specified
% init_distr: initial distribution of the particles
% fltr      : the contructed filter
%
% Author: Lingji Chen
% Date: January 24, 2006

if nargin == 0
  fltr.f = [];
  fltr.h = [];
  fltr.Q = [];
  fltr.R = [];
  fltr.df = [];
  fltr.dh = [];
  fltr.x = [];
  fltr.P = [];

  fltr = class(fltr, 'EKF');
elseif isa(sys, 'EKF')
  fltr = sys;
elseif nargin ~=2
  error('wrong number of arguments');
else
  if ~isa(sys, 'SigObsSys')
    error('wrong first argument: must be a SigObsSys object');
  end;
  [x, y, f, h, w_d, v_d, df, dh] = get(sys);
  fltr.f = f;
  fltr.h = h;
  fltr.Q = cov(w_d);
  fltr.R = cov(v_d);
  fltr.df = df;
  fltr.dh = dh;
  fltr.x = mean(init_distr);
  fltr.P = cov(init_distr);

  fltr = class(fltr, 'EKF');
end;
