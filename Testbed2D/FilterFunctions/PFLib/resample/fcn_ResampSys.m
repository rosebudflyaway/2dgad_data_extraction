function outIndex = fcn_ResampSys(w, N)

% function outIndex = fcn_ResampSys(w, N)
% Draw a total of N samples with probabilities proportional to the
% weight vector w, using Kitagawa's "Systematic Resampling" algorithm.
% w            : normalized weight vector (sum to one)
% N (optional) : total number of samples; default to length(w)
% outIndex     : each element is an index into w, or, the "parent" of
%                the sample. Therefore if {X, w} is the original 
%                particles-weights pair, then {X(outIndex), 1/N}
%                will be the resampled pair.   
% See also     : fcn_ResampSimp, fcn_ResampResid
%
% Author: Lingji Chen
% Date: December 30, 2005

eps = 1e-12; % small but not too small

len = length(w);
F = cumsum(w);
if abs(F(end) - 1) > eps
  error('the weight vector should be normalized.');
end;

switch nargin
 case 1,
  N = len;
 case 2,
 otherwise,
  error('wrong number of arguments');
end;

s = rand / N; 
inc = 1 / N;

outIndex = zeros(1, N);
j = 1;
for i = 1:N
  while F(j) < s
    j = j + 1;
  end;
  outIndex(i) = j;
  s = s + inc;
end;


