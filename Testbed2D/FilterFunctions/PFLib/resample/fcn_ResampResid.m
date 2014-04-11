function outIndex = fcn_ResampResid(w, N)

% function outIndex = fcn_ResampResid(w, N)
% Draw a total of N samples with probabilities proportional to the
% weight vector w, using residual resampling.
% w            : normalized weight vector (sum to one)
% N (optional) : total number of samples; default to length(w)
% outIndex     : each element is an index into w, or, the "parent" of
%                the sample. Therefore if {X, w} is the original 
%                particles-weights pair, then {X(outIndex), 1/N}
%                will be the resampled pair.   
% 
% See also     : fcn_ResampSys, fcn_ResampSimp
%
% Author: Chihoon Lee and Lingji Chen
% Date: January 16, 2006

eps = 1e-12; % small but not too small

if abs(sum(w) - 1) > eps
  error('the weight vector should be normalized.');
end;

len = length(w);
switch nargin
 case 1,
  N = len;
 case 2,
 otherwise,
  error('wrong number of arguments');
end;

Nw = N * w;
Nw_bulk = floor(Nw); % deterministic part
N_bk = sum(Nw_bulk);

outIndex = zeros(1, N);

ind = 1;
for i = 1:len
  counter = 1;
  while counter <= Nw_bulk(i) 
    outIndex(ind) = i;
    ind = ind + 1; counter = counter + 1;
  end;
end;

N_res = N - sum(Nw_bulk); % number of particles for the random part
if (N_res ~= 0)
  w_res = (Nw - Nw_bulk) / N_res; % normalize
  outIndex(N_bk+1:end)= fcn_ResampSimp(w_res, N_res);
end;

