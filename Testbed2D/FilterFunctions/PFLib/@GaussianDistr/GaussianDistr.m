function gDistr = GaussianDistr(theMean, theCov)
% function gDistr = GaussianDistr(theMean, theCov)
% GaussianDistr: Gaussian distribution class constructor.
%   gDistr = GaussianDistr(theMean, theCov) 
% creates an object that represents a Gaussian (i.e., Normal)
% distribution with theMean as the mean vector and theCov as the
% covariance matrix. The covariance matrix must be positive definite in
% this implementation.
%
% Author: Lingji Chen
% Date: Dec 15, 2005

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

if nargin == 0
  gDistr.mean = []; 
  gDistr.n = [];     
  gDistr.cov = [];
  gDistr.const = []; 
  gDistr.invCov = [];
  gDistr.UsqrtT = [];
  gDistr = class(gDistr,'GaussianDistr');
elseif isa(theMean,'GaussianDistr')
  gDistr = theMean;
elseif nargin == 2
  gDistr.mean = theMean(:);
  gDistr.n = length(gDistr.mean);
  [nrow, ncol] = size(theCov);
  if nrow ~= ncol || nrow ~= gDistr.n
    error('wrong size for mean or covariance');
  end;
  tmp = theCov';
  if any(theCov(:) ~= tmp(:))
    error('covariance matrix should be symmetric');
  end;
  [U, T] = schur(theCov);
  if any(diag(T) <= eps)
    error('covariance matrix should be positive definite');
  end;
  gDistr.cov = theCov;
  % constant used in the density calculation
  gDistr.const = 1 / sqrt((2 * pi)^gDistr.n * det(theCov)); 
  % pre-computed inverse for density calculation
  gDistr.invCov = inv(theCov);
  % pre-computed matrices for drawing samples
  gDistr.UsqrtT = U * (T .^ 0.5);
  gDistr = class(gDistr, 'GaussianDistr');
else
  error('wrong number of arguments');
end
