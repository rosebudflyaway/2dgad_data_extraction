%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RPI-MATLAB-Simulator
% http://code.google.com/p/rpi-matlab-simulator/
% mlcp_fixed_point.m 
%
% MCP solver with prox function formulation with fixed point iteration 
function sim = mlcp_fixed_point( sim )
% matrices used 
M = sim.dynamics.M;
Gn = sim.dynamics.Gn;
Gf = sim.dynamics.Gf; 
h = sim.dynamics.h;
FX = sim.bodies.forces';
MinvPext = M \ FX*h;
%PSI = sim.dynamics.PSI;
PSI = -sim.contacts.depth';
NU = sim.bodies.velocities';
nc = length(PSI);
U = sim.dynamics.U;
E = sim.dynamics.E; 
[~, nd] = size(Gf);
nd = nd / nc;
% LCP_FIXED_POINT 
% This is the prox projection onto the positive plane using the pyramid 
% iteration with the Newton-Euler equation to make this a mixed LCP problem
MinvGn = M \ Gn;
MinvGf = M \ Gf;

A = [ Gn'*MinvGn   Gn'*MinvGf  zeros(nc)
      Gf'*MinvGn   Gf'*MinvGf  E
      U            -E'         zeros(nc)];

%r = eig(Gn' * MinvGn)         % the parameter r
%r = 0.06;  %works well, much better than 40
rn = 0.3 / eigs(Gn' * MinvGn, 1);
rf = 0.3 / eigs(Gf' * MinvGf, 1);
%rn = 0.9;
%rn = 0.05;
%rf = 1.05;
rs = 0.5;
% parameters to be tuned
iter = 1;        % the iteration inside the fixed_point iteration
maxIter = 1000;   % the maximum number of iteration steps
err = 1e5;       % The error
toler = 1e-4;    % The tolerance of the error

pn = zeros(nc, 1);
pf = zeros(nc*nd, 1);
%pf_ellp1 = zeros(nc*nd, 1);
s  = zeros(nc, 1);  
%% converge the normal force and the frictional force 
    % converge the normal force first
    while (iter < maxIter)
        pn_ellp1 = update_normal(pn, rn, PSI, h, Gn, NU);
        pf_ellp1 = update_fric(pf, rf, Gf, NU, s, E);
        s_ellp1  = update_sliding(s, rs, U, pn_ellp1, pf_ellp1, E);
        NU_ellp1 = update_vel(NU, MinvGn, pn_ellp1, MinvGf, pf_ellp1, MinvPext);
        b        = setb(Gn, Gf, NU_ellp1, MinvPext, PSI, h, nc);
        z = [pn_ellp1; pf_ellp1; s_ellp1];
        err = z' * (A * z + b);
       % err = PSI' * pn;
         pn = pn_ellp1;
         pf = pf_ellp1;      
          s = s_ellp1;
          if err < toler  
            break;
          end
        iter = iter + 1;
    end
    % Assign new velocities to sim.z
    sim.solution.z = NU_ellp1;
    sim.solution.iter = iter;
    sim.solution.err  = err;
    % sim.solution.err = z' * (A * z + b);
    % z' * (A * z + b)
end

function [NU_ellp1] = update_vel(NU, MinvGn, pn, MinvGf, pf, MinvPext)
  NU_ellp1 = NU + MinvGn * pn + MinvGf * pf + MinvPext;
end

function [pn_ellp1] = update_normal(pn, rn, PSI, h, Gn, NU_ellp1)
% Pn_ellp1 = prox(Pn - rn (PSI/h + Gn'*NU_ellp1))
    rhon = PSI/h + Gn'* NU_ellp1;
    pn_ellp1 = pn - rn*rhon;
% The normal force can not be negative, project onto the non negative space
    pn_ellp1(pn_ellp1<0) = 0;
end

function [pf_ellp1] = update_fric(pf, rf, Gf, NU_ellp1, s, E)
% Pf_ellp1 = prox(Pf - rf * (Gf * NU_ellp1 + s))
rhof = Gf' * NU_ellp1 + E * s;
pf_ellp1 = pf - rf * rhof;
pf_ellp1(pf_ellp1 < 0) = 0;
end

function [s_ellp1]  = update_sliding(s, rs, U, pn_ellp1, pf_ellp1, E)
rhos = U * pn_ellp1 - E' * pf_ellp1;
s_ellp1 = s - rs * rhos;
s_ellp1(s_ellp1 < 0) = 0;
end

function b = setb(Gn, Gf, NU, MinvPext, PSI, h, nc)
b = [ Gn'*(NU + MinvPext) + PSI/h;    % FX*h could be replaced if we stored Pext instead of Fext
      Gf'*(NU + MinvPext);
      zeros(nc,1) ];    
end

