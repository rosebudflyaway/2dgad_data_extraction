function outIndex = fcn_ResampBran(w)

% function outIndex = fcn_ResampBran(w)
% Resample using the "branch-and-kill" scheme.
% w            : normalized weight vector (sum to one)
% outIndex     : each element is an index into w, or, the "parent" of
%                the sample. Therefore if {X, w} is the original 
%                particles-weights pair, then {X(outIndex), 1/N}
%                will be the resampled pair, where N is the total
%                number of new samples (which can vary).   
% 
% See also     : fcn_ResampSys, fcn_ResampResid, fcn_ResampSimp
%
% Author: Chihoon Lee, Lingji Chen
% Date: January 17, 2006

eps = 1e-12; % small but not too small

if abs(sum(w) - 1) > eps
  error('the weight vector should be normalized.');
end;

len = length(w);
Nw = len * w;
Nw_bulk = floor(Nw); 
p = Nw - Nw_bulk;

flag = rand(1, len) < p; % 0 -- kill, 1 -- branch

new_num = Nw_bulk + flag;
outIndex = zeros(1, sum(new_num)); 
ind = 1;
for i = 1:len
  counter = 1;
  while counter <= new_num(i)
    outIndex(ind) = i;
    ind = ind + 1; counter = counter + 1;
  end;
end;



