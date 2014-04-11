function hopt = fcn_opt_GKer_width(d, N)

% function hopt = fcn_opt_GKer_width(d, N)
% Optimal bandwidth for Gaussian Kernel, used in Regularized
% Particle Filter
% d: dimension of variable
% N: number of particles
% hopt: optimal bandwidth
%
% Author: Lingji Chen
% Date: March 20, 2006

A = (4 / (d + 2)) ^ (1 / (d + 4));
hopt = A * N ^ (- 1 / (d + 4));
