function obj = SigObsSys(fcn_sig, fcn_obs, distr_sig, distr_obs, ...
			 x0, fcn_df, fcn_dh)
% function obj =
% SigObsSys(fcn_sig,fcn_obs,distr_sig,distr_obs,x0,fcn_df, fcn_dh)
% SigObsSys: class constructor for a Signal-Observation system,
% which is a time-invariant dynamical system of the form:
%     x(k+1) = f(x(k)) + w(k)
%     y(k)   = h(x(k)) + v(k)
% fcn_sig is a function handle for f()
% fcn_obs is a function handle for h()
% distr_sig is a distribution object for w(k)
% distr_obs is a distribution object for v(k)
% x0 is an initial value for x(0)
% fcn_df (optional) is Jacobian of f() with respect to x
% fcn_dh (optional) is Jacobian of h() with respect to x
%
% Author: Lingji Chen and Chihoon Lee
% Date: December 27, 2005

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
  obj.f = [];
  obj.h = [];
  obj.w = [];
  obj.v = [];
  obj.x = [];
  obj.y = [];
  obj.df = [];
  obj.dh = [];
  obj = class(obj,'SigObsSys');
elseif isa(fcn_sig, 'SigObsSys')
  obj = fcn_sig;
else
  switch nargin 
   case 5,
    fcn_df = [];  fcn_dh = [];
   case 6,
    fcn_dh = [];
   case 7, 
   otherwise,
    error('wrong number of arguments');
  end;

  obj.f = fcn_sig;
  obj.h = fcn_obs;
  obj.w = distr_sig;
  obj.v = distr_obs;
  obj.x = x0;


  try
      % check for size in consistency
      len_x = length(obj.x);
      %fx = obj.f(obj.x); % could fail, hence the try-catch
      len_f = length(obj.x);
      len_w = length(drawSamples(obj.w));
      obj.y = obj.h(obj.x);  % could fail, hence the try-catch
      len_y = length(obj.y);
      len_v = length(drawSamples(obj.v));
      
      if len_x ~= len_f || len_y ~= len_v
      %if len_x ~= len_w || len_x ~= len_f || len_y ~= len_v
          error('size inconsistency in SigObsSys constructor arguments');
      end;
      
  catch
      error('size inconsistency in SigObsSys constructor arguments');
  end

  obj.df = fcn_df;
  obj.dh = fcn_dh;
  obj = class(obj, 'SigObsSys');
end
