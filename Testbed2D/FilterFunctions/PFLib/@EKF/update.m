function fltr = update(fltr, y)

% function fltr = update(fltr, y)
%
% INPUT: 
%        fltr: the filter
%           y: the measurement
% OUTPUT: 
%        fltr: updated filter
%
% AUTHOR: Lingji Chen
%
% DATE: 8/20/2001, 1/24/06

%   Copyright (C) 2006, Lingji Chen, Chihoon Lee, Amarjit Budhiraja and 
%   Raman K. Mehra
%
%   This file is part of PFLib.
%
%   PFLib is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 2 of the License, or
%   (at your option) any later version.
%
%   PFLib is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with Foobar; if not, write to the Free Software
%   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, 
%   MA  02110-1301  USA

try
  A = fltr.df(fltr.x);
  P = A * fltr.P * A' + fltr.Q;
  x = fltr.f(fltr.x);
  H = fltr.dh(x);
  K = P * H' * inv(H * P * H' + fltr.R);
  yhat = fltr.h(x);
  fltr.x = x + K * (y - yhat);
  fltr.P = P - K * H * P;
catch
  error('EKF initialized incorrectly with a SigObsSys object');
end;

