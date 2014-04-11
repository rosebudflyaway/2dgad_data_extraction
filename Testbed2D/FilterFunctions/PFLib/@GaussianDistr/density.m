function d = density(gDistr, x)

% function d = density(gDistr, x)
% Gaussian density
%   gDistr: a GaussianDistr object
%        x: a column vector, or a matrix of such vectors
%        d: a row vector of densities 
% AUTHOR: Lingji Chen
% DATE:   Dec 19, 2005

[nrow, ncol] = size(x);

if(nrow ~= gDistr.n)
  error('wrong input size for density calculation.');
end;

d = zeros(1, ncol);
x = x - repmat(gDistr.mean, 1, ncol);


for i = 1:ncol
  d(i) = gDistr.const * exp(-x(:, i)' * gDistr.invCov * x(:, i) / 2);
end;


  

