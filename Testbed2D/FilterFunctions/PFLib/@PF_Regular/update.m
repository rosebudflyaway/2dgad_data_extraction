function fltr = update(fltr, y)

% function fltr = update(fltr, y)
% input:
% fltr: the filter object
% y   : the current measurement
% output:
% fltr: the updated filter object
%
% Author: Chihoon Lee, Lingji Chen
% Date  : March 20, 2006

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

dim =  size(fltr.p, 1);
Eps = 1e-10 * ones(dim); 
if fltr.whitening
  wp = fltr.p .* repmat(fltr.w, dim, 1);
  x = sum(wp, 2);
  P = wp * fltr.p' - x * x';
  [U, T] = schur(P);
  A = U * (T + Eps).^0.5;
else 
  A = eye(dim);
end;

w_smpl = drawSamples(fltr.w_d, fltr.N);
  
switch fltr.algo 
 case 'post'
  outIndex = fcn_ResampSimp(fltr.w, fltr.N);
  e = randn(dim, fltr.N);
  fltr.p = fltr.p(:, outIndex) + fltr.width * A * e;

  for i = 1:fltr.N
    % propagate particles
    fltr.p(:, i) = fltr.f(fltr.p(:, i)) + w_smpl(:, i);
    % noise-free y
    y_pi = fltr.h(fltr.p(:, i));
    % update weights
    fltr.w(i) = density(fltr.v_d, y - y_pi);
  end;
  
  sum_w = sum(fltr.w);
  if sum_w <= realmin
    error('weights are numerically zero; change parameters or method.');
  end;
  fltr.w = fltr.w / sum_w;
  
 case 'pre'

  for i = 1:fltr.N
    % propagate particles
    fltr.p(:, i) = fltr.f(fltr.p(:, i)) + w_smpl(:, i);
  end;

  total = 1; 
  maxhood = maxValue(fltr.v_d);
  pool = fltr.p;
  while (total <= fltr.N)
    I = floor(rand * fltr.N) + 1;
    e = randn(dim, 1);
    u = rand;
    x = fltr.p(:, I) + fltr.width * A * e;
    y_x = fltr.h(x);
    hood = density(fltr.v_d, y - y_x);
    if hood > u * maxhood
      pool(:, total) = x;
      total = total + 1;
    end;
  end;
  fltr.p = pool;
  fltr.w = fltr.w * 0 + 1 / fltr.N;
  
 case 'mix'
  temp_w = zeros(1, fltr.N);
  for i = 1:fltr.N
    % propagate particles
    fltr.p(:, i) = fltr.f(fltr.p(:, i)) + w_smpl(:, i);
    y_pi = fltr.h(fltr.p(:, i));
    temp_w(i) = density(fltr.v_d, y - y_pi)^0.5;
  end;
  sum_w = sum(temp_w);
  if sum_w <= realmin
    error('weights are numerically zero; change parameters or method.');
  end;
  temp_w = temp_w / sum_w;
  
  total = 1; 
  maxhood = maxValue(fltr.v_d)^0.5;
  pool = fltr.p;
  while (total <= fltr.N)
    I = fcn_ResampSimp(temp_w, 1); 
    e = randn(dim, 1);
    u = rand;
    x = fltr.p(:, I) + fltr.width * A * e;
    y_x = fltr.h(x);
    hood = density(fltr.v_d, y - y_x)^0.5;
    if hood > u * maxhood
      pool(:, total) = x;
      total = total + 1;
    end;
  end;
  fltr.p = pool;
  fltr.w = fltr.w * 0 + 1 / fltr.N;
  
  
  
end;

