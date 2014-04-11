function fltr = update(fltr, y)

% function fltr = update(fltr, y)
% input:
% fltr: the filter object
% y   : the current measurement
% output:
% fltr: the updated filter object
%
% Author: Lingji Chen, Chihoon Lee
% Date  : March 9, 2006

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


N = length(fltr.w); 
% check whether resampling is chosen, and whether it's time to resample
if ~isempty(fltr.r_fun) && mod(fltr.counter, fltr.T) == 0
  if(N < fltr.thresh * fltr.N ) % too few (as a result of branch-kill), rejuvenate
      outIndex = fcn_ResampSys(fltr.w, fltr.N);
  else
    outIndex = fltr.r_fun(fltr.w);
  end;
  fltr.p = fltr.p(:, outIndex);
  N = length(outIndex);
  fltr.w = ones(1, N) / N;
end;

% internally keep track of when it's time to resample
fltr.counter = fltr.counter + 1;


for i = 1:N % for each particle
  x = fltr.p(:, i);
  xp = fltr.f(x);
  H = fltr.dh(xp);
  yp = fltr.h(xp);
  P = inv(fltr.invQ + H' * fltr.invR * H);
  P = (P + P') / 2; % P can become numerically asymmetric
  mu = P * (fltr.invQ * xp + H' * fltr.invR * (y - yp + H * xp));
  gauss = GaussianDistr(mu, P); % proposal distribution

  % propagate particles
  fltr.p(:, i) = drawSamples(gauss, 1);
  % mean of y
  y_pi = fltr.h(fltr.p(:, i));
  % from measurement model
  likelihood = density(fltr.v_d, y - y_pi);
  % from process model
  prior = density(fltr.w_d, fltr.p(:,i) - xp);
  % from the proposal
  proposal = density(gauss, fltr.p(:,i));
  % update weights

  fltr.w(i) = fltr.w(i) * likelihood * prior / proposal;
end;

sum_w = sum(fltr.w);
if sum_w <= realmin
  error('weights are numerically zero; change parameters or method.');
end;

fltr.w = fltr.w / sum_w;


