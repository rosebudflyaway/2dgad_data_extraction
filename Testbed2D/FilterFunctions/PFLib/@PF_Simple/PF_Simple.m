function fltr = PF_Simple(sys, init_distr, opts)
% function fltr = PF_Simple(sys, init_distr, opts)
% PF_Simple: class constructor for a Particle Filter with a simple
% proposal (the state transition).
% 
% sys       : a SigObsSys object
% init_distr: initial distribution of the particles
% opts      : a structure array of options, obtained from calling setPFOptions
% fltr      : the contructed filter
%
% Author: Lingji Chen, Chihoon Lee
% Date: January 18, 2006


if nargin == 0
  fltr.f = []; fltr.h = []; fltr.w_d = []; fltr.v_d = [];
  fltr.N = []; fltr.T = []; fltr.r_fun = []; fltr.thresh = [];
  fltr.p = []; fltr.w = []; fltr.counter = [];
  fltr = class(fltr,'PF_Simple');
elseif isa(sys, 'PF_Simple')
  fltr = sys;
elseif nargin ~= 3
  error('wrong number of arguments');
else
  if ~isa(sys, 'SigObsSys')
    error('wrong first argument: must be a SigObsSys object');
  end;
  if ~setPFOptions(opts)
    error(['wrong second argument: must be a valid option' ...
	   ' structure']);
  end;
  [x, y, f, h, w_d, v_d] = get(sys);
  fltr.f = f; % state equation
  fltr.h = h; % measurement equation
  fltr.w_d = w_d; % distribution of state noise
  fltr.v_d = v_d; % distribution of measurement noise
  fltr.closure = zeros(1, opts.NumPart);
  fltr.para = zeros(4, opts.NumPart);
  fltr.contactMode = zeros(1, opts.NumPart);
  fltr.touchMode = zeros(1, opts.NumPart);
% closure = fltr.closure;
% para = fltr.para;
% contactMode = fltr.contactMode;
  try
    fltr.N = opts.NumPart;
    fltr.T = opts.ResampPeriod;
    
    if strmatch(opts.ResampAlgo, 'none', 'exact')
      fltr.r_fun = [];
    else
      eval(['fltr.r_fun = @' opts.ResampAlgo ';']);
    end;
    
    if strmatch(opts.ResampAlgo, 'fcn_ResampBran', 'exact')
      fltr.thresh = opts.BranchThresh;
    else fltr.thresh = 1; 
    end;
  catch
    error(['wrong option structuure:' lasterr]);
  end;
  
  try
    fltr.p = drawSamples(init_distr, fltr.N); % particles
    fltr.w = ones(1, fltr.N) / fltr.N;        % weights
    fltr.wp = fltr.w;
  catch
    error('wrong initial particle distribution');
  end;
  fltr.counter = 0; % internal counter for determining when to resample
  fltr = class(fltr, 'PF_Simple');
end
