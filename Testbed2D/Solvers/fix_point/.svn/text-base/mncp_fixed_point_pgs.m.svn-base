function sim  = mncp_fixed_point_pgs(sim)
% The difference with mncp_fixed_point is that this loop changes to contact point
% wise. By converge on the first contact point, and then next, until Nth
M = sim.Ndynamics.M;
Gn = sim.Ndynamics.Gn;
Gf = sim.Ndynamics.Gf;
h = sim.Ndynamics.h;
U = sim.Ndynamics.U;

FX = sim.bodies.forces';
MinvPext = M \ (FX*h);
PSI = sim.contacts.depth';
NU = sim.bodies.velocities';
nc = length(PSI);
if exist('warm_start')
    warm_start = sim.warmstart;
else
    warm_start = 'quad_program';
end
if isfield(sim, 'constraints')
    % bilateral constraints
    Gb = sim.Ndynamics.Gb;
    Bounds = sim.constraints.bounds';
    Violation = sim.constraints.violation;
    nj = length(Violation);
    MinvGb     = M \ Gb;
    [~, pb_size] = size(Gb);
    pb = zeros(pb_size, 1);
    rb = 0.3 / eigs(Gb' * MinvGb, 1);
end

% bilateral constraints 
MinvGn     = M \ Gn;
MinvGf     = M \ Gf;
% should be less than 2/eig
rn = 0.3 / eigs(Gn' * MinvGn, 1);
rf = 0.6 / eigs(Gf' * MinvGf, 1);
maxIter1   = 500;      % the maximum number of iteration steps
maxIter2   = 20;
maxIter3   = 500;
toler      = 1e-4;
converge = zeros(maxIter1, 1);
% initial values for pf and s
pn = zeros(nc, 1);
pf = zeros(2*nc, 1);
pf_ellp1 = zeros(2*nc, 1);

norm_err = zeros(nc, maxIter2);
fric_err = zeros(nc, maxIter2);
% to save the number of contacts: sliding; sticking; penetrate or detach.
stick_or_slide = zeros(nc, maxIter2);   % slide = 1
pene_or_deta   = zeros(nc, maxIter3);   % pene  = 1
 A       = Gn'*MinvGn;
%for iter1 = 1:maxIter1
    % warm start the normal using Lemke
    b       = Gn'*(NU + MinvPext) + PSI/h - Gn'*MinvGf*pf;
    switch warm_start
        case 'Lemke'
            pn_ellp1 = lemke(A, b, pn);
        case 'quad_program'
            %opts  = optimset('Algorithm', 'active-set', 'Display', 'off');
            opts  = optimset('Algorithm', 'interior-point-convex', 'Display', 'off');
            cons_A = [-1*eye(length(b));  -A];
            cons_b = [zeros(length(b), 1);  b];
            pn_ellp1 = quadprog(2*A, b, cons_A, cons_b, [], [], [], [], [], opts);
        otherwise
            pn_ellp1 = pn;  % when there is no warm start
    end
    pn = pn_ellp1;
    NU_ellp1 = NU +  MinvGn * pn + MinvGf * pf  + MinvPext;
    for   CT = 1:nc  % iter2 iterations over every contact
        for iter2 = 1: maxIter2
            [pn_ellp1(CT, 1), flag, err1]  = update_normal(pn(CT, 1),  rn, PSI(CT, 1), h, Gn(:, CT), NU_ellp1);
            pene_or_deta(CT, iter2)  = flag;
            norm_err(CT, iter2) = err1;
            if err1 < toler 
                pn(CT, 1) = pn_ellp1(CT, 1);
                break;
            end
            pn(CT, 1) = pn_ellp1(CT, 1);
        end
    end
    
    for CT = 1 : nc
        % the error for the final iterate 
        for iter3 = 1:maxIter3
            [pf_ellp1(2*CT-1:2*CT, 1), flag, err2]  = update_fric(pf(2*CT-1:2*CT, 1), rf, Gf(:, 2*CT-1: 2*CT), NU_ellp1, pn_ellp1(CT, 1), U(CT, CT));
            NU_ellp1 = NU_ellp1 +  MinvGn * pn + MinvGf * pf_ellp1  + MinvPext;
            stick_or_slide(CT, iter3) = flag;
            fric_err(CT, iter3)   = err2;
            if(err2 < toler)
                pf(2*CT-1:2*CT, 1) = pf_ellp1(2*CT-1:2*CT, 1);
                break;
            end
            pf(2*CT-1:2*CT, 1) = pf_ellp1(2*CT-1:2*CT, 1);
        end         
    end 
    % right now in the code, we have only spherical joint, which the size
    % should be 3
    % we don't loop joint by joint, since provided the big jacobian matrix
    % as a whole, here will solve all the Pb at the same time. Besides, the
    % Pb to solve is an equation, no iteration is needed.
    
    % Idety = ones(pb_size, 1);
    % how does this come from? we have pb in the form of equations,
    % rather than complementarity form, how does the prox come then ????
    % The prox here actually is we didn't project onto the positive plane,
    % but the complementarity condition doesn't exist in the physical
    % model, don't do projection onto the positive plane here. 
    % pb = min(Bounds(:, 2) * Idety, max(Bounds(:, 1) * Idety, pb - rb * (Gb' * NU_ellp1)));    
    
    total_err = 0;
    for CT = 1 : nc    
        total_err = total_err + norm_err(CT, length(norm_err(CT, :))) + fric_err(CT, length(fric_err(CT,:))); 
    end
    total_err = total_err / nc;
%    converge(iter1 , 1) = total_err;
    converge = total_err;
%     total_err 
%     pause
%     if total_err < toler
%         break;
%     end
%end
NU_ellp1 = NU + MinvGn * pn + MinvGf * pf + MinvPext;
z  =[NU_ellp1; pn; pf];
stick_num = length(stick_or_slide(:, iter2) < 0);
slide_num = length(stick_or_slide(:, iter2) > 0);
sim.z = z;
sim.solution.name = 'mncp_fixed_point_pgs';
sim.solution.iter =  iter2 + iter3;
sim.solution.err = total_err;
sim.solution.slide_num = slide_num;
sim.solution.parameter = [rn, rf];
sim.solution.normerr = sum(norm_err)/nc; % take sum over all the contacts
sim.solution.fricerr = sum(fric_err)/nc;
sim.solution.converge = converge;
end

function [NU_ellp1] = update_vel(NU, MinvGn, pn, MinvGf, pf, MinvPext)
NU_ellp1 = NU + MinvGn * pn + MinvGf * pf + MinvGb * pb + MinvPext;
end

function [pn_ellp1, flag, err] = update_normal(pn, rn, PSI, h, Gn, NU_ellp1)
% scalar operations below
% Pn_ellp1     = prox(Pn - rn (PSI/h + Gn'*NU_ellp1))
rhon = PSI/h + Gn'* NU_ellp1;
pn_temp = pn - rn*rhon;
% The normal force can not be negative, project onto the non negative space
pn_ellp1 = pn_temp;
if pn_ellp1 <= 0   % detach
    flag = -1;
    pn_ellp1 = 0;
else
    flag = 1;      % >0  contact
end
err = PSI * pn_ellp1;
end

function [pf_ellp1, flag, err] = update_fric(pf, rf, Gf, NU_ellp1, pn_ellp1,U)
% Pf_ellp1 = prox(Pf - rf * (Gf * NU_ellp1 + s))
% scalar operations below 
rhof = Gf' * NU_ellp1;
pf_temp = pf - rf * rhof;
rel_vel = Gf' * NU_ellp1;
%rel_vel_dir = rel_vel / norm(rel_vel);
pf_ellp1 = zeros(2, 1);
% The frictional force should be projected inside or onto the cone
% sliding case , error is frictional force - mu * normal force
if pn_ellp1 < 1e-6 
    flag = 0;
    err = 0;
else
    if norm(rel_vel) > 1e-6 
        rel_vel_dir = rel_vel / norm(rel_vel);
        pf_dir = pf_temp / norm(pf_temp);
        flag = 1;
        pf_slide_mag = U* pn_ellp1;
        pf_ellp1 = pf_slide_mag * (-rel_vel_dir);
      
        err1 = norm(norm(pf_ellp1) - U*pn_ellp1);
        err2 = norm(rel_vel_dir' * pf_dir + 1);  % if they are exactly colinear and opposite, it should be -1
        disp('sliding error');
        err1
        err2
        pause
        err = err1  + err2;
        
    else 
        % sticking case; error is the norm of relative velocity
        flag = -1;
        err = norm(min(U*pn_ellp1-norm(pf_temp), 0));
        disp('sticking error'); 
        err
        pause 
        if norm(pf_temp) < U * pn_ellp1
            pf_ellp1 = pf_temp;
        else
            direc = pf_temp / norm(pf_temp);
            pf_ellp1 = (U * pn_ellp1) * direc;
        end
    end
end
pf_ellp1 
end