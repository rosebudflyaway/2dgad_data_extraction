function [y failed  contactMode] = ffun(x, aPosCtrl, objMass, objMOI, is_circular, objRadius)
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

%% global variable definition
% all global should only be visible within this function, including
% functions called
global FRAMERATE systemParameters
global sMu Mu1 Mu2 d
sMu = systemParameters.Us;
Mu1 = systemParameters.Up;
Mu2 = systemParameters.Uf;
d = systemParameters.Rtri;

global m_row1Index m_row2Index m_row3Index m_row4Index m_row5Index ...
    m_row6Index m_row7Index dimension; % matrix indices
global m_stepSize g b;                 % parameters and step size and gravity constant and lcp right item
global globalMass m J Nu Pos;          % inertia matrix and mass
global m_numContacts colRes isInCollision;
global psi_n m_partialGapW_R_T_Time m_partialFricW_R_T_Time;
global supportPoints supportForces globalPext;
global Wn Wf Wt_s Wo_s E U;
global totalSupportNum;     % vertices number of supporting tripod, 3 in this case
global z;                   % mcp solution vector
global r2c n2c;

%% constants and parameters
m_stepSize = 1/FRAMERATE;

r2c = [0 0]';
n2c = [0 0]';

g = 9.810; % gravity accelation
m = objMass; % mass of the body
J = objMOI; % moment of inertia
globalMass = [m 0 0; 0 m 0; 0 0 J];
totalSupportNum = 3;
supportPoints = [d 0; d*cos(2*pi/3) d*sin(2*pi/3); d*cos(4*pi/3) d*sin(4*pi/3)]';
failed = false;
lambda = 0;
isStop = 0;

%% last step extraction
x = x(:);
Pos = x(1:3)';
Nu = x(4:6)';
OldNu = Nu;

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
theta = Pos(3);
for i = 1:totalSupportNum
    Wt_s(1, i) = 1;
    Wt_s(3, i) = -sin(theta)*supportPoints(1, i) - cos(theta)*supportPoints(2, i);
    Wo_s(2, i) = 1;
    Wo_s(3, i) =  cos(theta)*supportPoints(1, i) - sin(theta)*supportPoints(2, i);
end

if isInCollision
    % construct other matrices
    Wn = zeros(3, m_numContacts);       % calculate Wn & Wf & U & E; This is actually Gn
    Wf = zeros(3, m_numContacts * 2);   
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
lastdimension = dimension;
if isempty(lastdimension)
    lastdimension = 0;
end
% calculate the matrix index
if isInCollision
    m_row1Index = 1;   % start index of each row in the big matrix
    m_row2Index = m_row1Index + 3;
    m_row3Index = m_row2Index + size(Wn, 2);
    m_row4Index = m_row3Index + size(Wf, 2);
    m_row5Index = m_row4Index + size(Wt_s, 2);
    m_row6Index = m_row5Index + size(Wo_s, 2);
    m_row7Index = m_row6Index + size(E, 2);
    dimension   = m_row7Index + totalSupportNum - 1;
else
    m_row1Index = 1;
    m_row2Index = m_row1Index + 3;
    m_row3Index = m_row2Index + size(Wt_s, 2);
    m_row4Index = m_row3Index + size(Wo_s, 2);
    dimension = m_row4Index + size(Wo_s, 2) - 1;
end

% call the path solver
if isInCollision
    b = zeros(dimension, 1);
    b(m_row1Index:m_row2Index-1) = globalMass * Nu' + globalPext;
    
    b(m_row2Index:m_row3Index-1) = psi_n / m_stepSize +  m_partialGapW_R_T_Time;
    b(m_row3Index:m_row4Index-1) = m_partialFricW_R_T_Time;
    b(m_row7Index:dimension)     = sMu*sMu*m_stepSize*m_stepSize...
        *0.5*(supportForces.*supportForces);
    
    l = zeros(dimension, 1);
    u = zeros(dimension, 1);
    if lastdimension ~= dimension
        z = zeros(dimension, 1);
    end
    for i = m_row1Index:m_row2Index-1
        l(i) = -1e20;
        u(i) = 1e20;
    end
    for i = m_row2Index:m_row4Index-1
        l(i) = 0.0;
        u(i) = 1e20;
    end
    for i = m_row4Index:m_row6Index-1
        l(i) = -1e20;
        u(i) = 1e20;
    end
    for i = m_row6Index:dimension
        l(i) = 0.0;
        u(i) = 1e20;
    end
    
    [nz, status] = pathmcp(z, l, u, 'cpfunjac');
    if status ~= 1
        nz = z;
        isStop = 1;
        failed = true;
    end
    Nu = nz(1:3)';
    
    if isStop
        lambda = nz(m_row2Index:m_row3Index-1);
        Nu = [0 0 0];
    else
        lambda = nz(m_row2Index:m_row3Index-1);
    end
    y = [Pos + Nu*m_stepSize Nu];  % update the system state
else    % if isInCollision
    l = zeros(dimension, 1);
    u = zeros(dimension, 1);
    if lastdimension ~= dimension
        z = zeros(dimension, 1);
    end
    for i = m_row1Index:m_row4Index-1
        l(i) = -1e20;
        u(i) = 1e20;
    end
    for i = m_row4Index:dimension
        l(i) = 0.0;
        u(i) = 1e20;
    end
    [nz, status] = pathmcp(z, l, u, 'cpfunjacSurface');
    if status ~= 1
        nz = z;
        isStop = 1;
    end
    Nu = nz(1:3)';
    
    if isStop
        lambda = 0;
        Nu = 0;
    else
        lambda = 0;
    end
    y = [Pos + Nu*m_stepSize Nu];  % update the system state
end
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