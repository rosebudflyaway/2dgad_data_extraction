function [y failed  contactMode] = ffunMy4Estimation(x, aPosCtrl, objMass, objMOI, is_circular, objRadius, systemParameters)
%ffun dynamic model of the simulation, implement one time step of the dynamic system
%
%Synopsis:
%      [y lambda state] = ffun(x, aPosCtrl)
%
%Input:
%  x:         system state, including object position and orientation and object velocity and rotational veloctiy. [x, y, theta, vx, vy, w]
%  aPosCtrl:  actuator's position at current and last step. [ax1, ax2,
%             aAngle; ax1_old, ax2_old, aAngle_old]. If at the first time
%             step, then two rows will be exactly the same
%
%Output:
%  y:         system state at next time step
%  lambda:    normal contact force



% COMMENT:is_circular, objRadius, aPosCtrl are used for collision detection
%% global variable definition
% all global should only be visible within this function, including
% functions called

% global FRAMERATE = 30 is defined in the configure.m
% systemParameters is defined in dbImportSystemParameters.m with three
% fields: 'Rtri', 'Up', 'Us', 'Uf'
global FRAMERATE  
global sMu Mu1 Mu2 d

%% Here is the difference: Rather than load parameters from the database, we use
% sampling points over the parameter space to get the optimal parameters
% for each solver
sMu = systemParameters.Us;
Mu1 = systemParameters.Up;
Mu2 = systemParameters.Uf;
d = systemParameters.Rtri;
 
%global m_row1Index m_row2Index m_row3Index m_row4Index m_row5Index ...
%    m_row6Index m_row7Index dimension; % matrix indices

% m_stepSize = 1 / FRAMERATE;  g is gravity acceleration, b is the vector
global m_stepSize g b;                 % parameters and step size and gravity constant and lcp right item
global globalMass globalMinv m J Nu Pos;          % inertia matrix and mass
global m_numContacts colRes isInCollision;

% Comes from collision detection
global psi_n m_partialGapW_R_T_Time m_partialFricW_R_T_Time;

global supportPoints supportForces globalPext;

% Gn  Gf= [Gt  Go]
global Wn Wf Wt_s Wo_s E Es U Ws;
global totalSupportNum;     % vertices number of supporting tripod, 3 in this case
global z;                   % mcp solution vector
global r2c n2c;             % cross(r, n);  corresponds to point and normal

%% constants and parameters
m_stepSize = 1/FRAMERATE;

r2c = [0 0]';
n2c = [0 0]';

g = 9.810; % gravity accelation
m = objMass; % mass of the body
J = objMOI; % moment of inertia
globalMass = [m 0 0; 0 m 0; 0 0 J];
globalMinv = [1/m 0 0; 0 1/m 0; 0 0 1/J];
totalSupportNum = 3;
% d = Rtri; the three points is evenly distributed on the circle
supportPoints = [d 0; d*cos(2*pi/3) d*sin(2*pi/3); d*cos(4*pi/3) d*sin(4*pi/3)]'; 
failed = false;
lambda = 0;
isStop = 0;

%% last step extraction
x = x(:);
Pos = x(1:3)';
Nu = x(4:6)';
OldNu = Nu';

%% collision detection
if is_circular
    contactMode = collisionDetectionRound(aPosCtrl, objRadius);
else
    contactMode = collisionDetection(aPosCtrl); % generate col_res and m_numContacts and set isInCollision
end
%% calculate required global variables based on collision detection results
% calculate support forces (equally distributed in this case)
supportForces = [m*g m*g m*g]'/3;

% calculate Wt_s & Wo_s
Wt_s = zeros(3, totalSupportNum);
Wo_s = zeros(3, totalSupportNum);
Ws   = zeros(3, totalSupportNum*2);
theta = Pos(3);
for i = 1:totalSupportNum
    Wt_s(1, i) = 1;
    Wt_s(3, i) = -sin(theta)*supportPoints(1, i) - cos(theta)*supportPoints(2, i);
    Wo_s(2, i) = 1;
    Wo_s(3, i) =  cos(theta)*supportPoints(1, i) - sin(theta)*supportPoints(2, i);
end

for i = 1 : totalSupportNum
    Ws(:, 2*i-1:2*i) = [Wt_s(:, i), Wo_s(:, i)];
end

% The Es for the surface frictions; constant matrix here
    Es = zeros(6, 1);
    Es(1:2, 1) = 1;
    Es(3:4, 2) = 1;
    Es(5:6, 3) = 1;

    
% Only form the matrices when in collision. If not in collision, then do
% not form the matrices
if isInCollision
    % construct other matrices
    Wn = zeros(3, m_numContacts);       % calculate Wn & Wf & U & E; This is actually Gn
    Wf = zeros(3, m_numContacts * 2);   % this is actually Gf
    U  = zeros(m_numContacts, m_numContacts); 
    E  = zeros(m_numContacts * 2, m_numContacts);
    
    psi_n = zeros(m_numContacts, 1);
    
    % categorize by number of contacts 
    if m_numContacts >= 2
        % Inverse transform a point from global to local coordinate
        r2c = inverseTransformFrame( colRes{2}.contactLoc, Pos );
        
    elseif m_numContacts == 1
        if strcmp(colRes{1}.body, 'peg') == 1
            r2c = inverseTransformFrame( colRes{1}.contactLoc, Pos );
        end
    else
        r2c = [0 0]';
    end
    
    r2c = r2c(:);
    
    for i = 1:m_numContacts                   % loop through all contact pairs
        r = colRes{i}.contactLoc - Pos(1:2);
        n = colRes{i}.normal(:);
        Wn(1:2, i) = n;
        Wn(3, i) = cross2d(r, n);
        
        t = rotateHalfPi(n);
        Wf(1:2, 2*i-1) = -t;
        Wf(3, 2*i-1) = cross2d(r, -t);
        Wf(1:2, 2*i) = t;
        Wf(3, 2*i) = cross2d(r, t);
        
        if strcmp(colRes{i}.body, 'actuator') % contact between body and actuator
            U(i, i) = Mu1;
        else                                  % contact between body and pegs
            U(i, i) = Mu2;
        end
        
        E(i*2-1, i) = 1.0;
        E(i*2  , i) = 1.0;
        
        psi_n(i) = colRes{i}.distance;
    end
    
    % calculate partials (position-controlled body related)
    m_partialGapW_R_T_Time  = zeros(  m_numContacts, 1);
    m_partialFricW_R_T_Time = zeros(2*m_numContacts, 1);
    
    changeInPos = (aPosCtrl(1, :) - aPosCtrl(2, :))/m_stepSize;
    
    for i = 1:m_numContacts                         %loop through all contact pairs
        if strcmp(colRes{i}.body, 'actuator')       % contact between body and actuator
            n = -1 * colRes{i}.normal;
            t = [-n(2) n(1)]';
            r = colRes{i}.contactLoc - aPosCtrl(2, 1:2);
            WnCol = [n(1) n(2) cross2d(r, n)];
            WtCol = [t(1) t(2) cross2d(r, t)];
            m_partialGapW_R_T_Time(i)      =  WnCol*changeInPos';
            m_partialFricW_R_T_Time(2*i-1) =  WtCol*changeInPos';
            m_partialFricW_R_T_Time(2*i)   = -m_partialFricW_R_T_Time(2*i-1);
        end
    end
end

% calculate external palses
globalPext = [0 0 0]';
 
% Get the data needed for optimization: 
if m_numContacts > 1 
    NU = OldNu;
    M = globalMass;
    Gn = Wn; 
    Gf = Wf;
    ql = Pos;
    h = m_stepSize;
    PSI = psi_n;
    save('data.mat', 'NU', 'M', 'm', 'Gn', 'Gf', 'ql', 'h', 'PSI', 'm_partialGapW_R_T_Time', 'm_partialFricW_R_T_Time');
    pause
end



% reformulate the dynamics as A and b
% A = [-globalMass     Wn                Wf               Ws         zeros(3, nc)   zeros(3, 3);
%         Wn'       zeros(nc, nc)   zeros(nc, 2nc)    zeros(nc, 6)   zeros(nc, nc)  zeros(nc, 3);
%         Wf'       zeros(2nc, nc)  zeros(2nc, 2nc))  zeros(2nc, 6)       E         zeros(2nc, 3);
%         Ws'       zeros(6, nc)    zeros(6, 2nc)     zeros(6, 6)    zeros(6, nc)   Es;
%     zeros(nc, 3)      U               -E'         zeros(nc, 6)   zeros(nc, nc)  zeros(nc, 3);
%     zeros(3, 3)   zeros(3, nc)    zeros(3, 2nc)        -Es'        zeros(3, nc)   zeros(3, 3)]


% % FOR PATH
% if isInCollision  
%     A = [-globalMass  Wn   Wf   Ws  zeros(3, m_numContacts+3);
%            Wn'        zeros(m_numContacts, 4*m_numContacts + 9);
%            Wf'  zeros(2*m_numContacts, 3*m_numContacts+6)  E  zeros(2*m_numContacts, 3);
%            Ws'  zeros(6, 4*m_numContacts+6)      Es;
%            zeros(m_numContacts, 3)    U     -E'    zeros(m_numContacts, m_numContacts+9);
%            zeros(3, 3*m_numContacts+3)   -Es'    zeros(3, m_numContacts+3)               ];
%     A = A + 10^(-6) * eye(size(A));
%        
%     b  = [globalMass * Nu' + globalPext;
%           psi_n / m_stepSize + m_partialGapW_R_T_Time;
%           m_partialFricW_R_T_Time;
%           zeros(6, 1);
%           zeros(m_numContacts, 1);
%           1/3 * sMu * m * g * m_stepSize * ones(3, 1)]; 
% else % not in collision; then there is surface friction 
%     A = [-globalMass Ws zeros(3, m_numContacts+3)
%          Ws'     zeros(6, 4*m_numContacts+6)  Es;
%          zeros(3, 3*m_numContacts+3) -Es'  zeros(3, m_numContacts+3)];
%     A = A + 10^(-6) * eye(size(A));
% 
%     b = [globalMass*Nu' + globalPext;
%          zeros(6, 1);
%          1/3 * sMu * m * g * m_stepSize * ones(3, 1)];
% end

% % FOR LEMKE or LCP

MinvWs = globalMinv * Ws;

if isInCollision
    MinvWn = globalMinv * Wn;
    MinvWf = globalMinv * Wf;
    A = [Wn'*MinvWn  Wn'*MinvWf  Wn'*MinvWs  zeros(m_numContacts, m_numContacts+3)  ;
         Wf'*MinvWn  Wf'*MinvWf  Wf'*MinvWs         E      zeros(2*m_numContacts, 3);
         Ws'*MinvWn  Ws'*MinvWf  Ws'*MinvWs  zeros(6, m_numContacts)   Es    ;
         U           -E'       zeros(m_numContacts, m_numContacts+9) ;
        zeros(3, 3*m_numContacts)    -Es'      zeros(3, m_numContacts+3)];
     
    
    b  = [ psi_n / m_stepSize + m_partialGapW_R_T_Time + Wn'*OldNu + Wn'*globalMinv*globalPext;
        m_partialFricW_R_T_Time + Wf'*OldNu + Wf' * globalMinv * globalPext;
        Ws'*OldNu + Ws'*globalMinv*globalPext;
        zeros(m_numContacts, 1);
        1/3 * sMu * m * g * m_stepSize * ones(3, 1)];

    problemSize = size(A, 1);
    z0 = zeros(problemSize, 1);    
     [z, iter, err] = fischer_newton(A, b, z0);
    %[z, iter, err] = pgs(A, b, z0);
    %[z, iter, err] = minmap_newton(A, b, z0);
    %[z, iter] = fischer_newton_capsim(A, b, z0);
    %[z, iter, err] = ip_lcp(A, b, z0);
    pn = z(1:m_numContacts);
    pf = z(m_numContacts+1: m_numContacts*3);
    ps = z(m_numContacts*3+1: m_numContacts*3+6);
    newNu = MinvWn*pn +  MinvWf*pf + MinvWs*ps + OldNu + globalMinv*globalPext;
else  % if not in collision then 
    A = [Ws'*MinvWs      Es;
           -Es'        zeros(3, 3)];
    A = A + 10^(-6) * eye(size(A));
    b = [Ws'*OldNu + Ws'*globalMinv*globalPext;
         1/3*sMu*m*g*m_stepSize*ones(3, 1)];
     
    problemSize = size(A, 1);
    z0 = zeros(problemSize, 1);     
      [z, ~, ~] = fischer_newton(A, b, z0);
    % [z, ~, ~] = pgs(A, b, z0);
    % [z, iter, err] = minmap_newton(A, b, z0);
    % [z, iter] = fischer_newton_capsim(A, b, z0);
    %[z, iter, err] = ip_lcp(A, b, z0);
    ps = z(1:6);
    newNu =  MinvWs*ps +  OldNu +  globalMinv*globalPext;
end



% big = 1e20; 
% u = big*ones(problemSize, 1);
% if isInCollision
%     l = [-big * ones(3, 1);
%          zeros(m_numContacts, 1);
%          -big * ones(2*m_numContacts, 1);
%          zeros(6, 1);
%          zeros(m_numContacts, 1);
%          zeros(3, 1)];
% else 
%     l = [-big * ones(3,1);
%          zeros(6, 1);
%          zeros(3, 1)];
% end 
% 
% newNu = pathlcp(A, b, l, u, z0);
Nu = newNu(1:3, 1)';
y  = [Pos + Nu*m_stepSize  Nu];
y = y(:);
end

% Inverse transform point p from global to local
function [ pN ] = inverseTransformFrame( p, P )
% local coordinate origin (Tx, Ty), orient: theta
cosT = cos(P(3));
sinT = sin(P(3));
t = p - P(1:2);
pN(:, 1) =  cosT*t(1) + sinT*t(2);
pN(:, 2) = -sinT*t(1) + cosT*t(2);
end