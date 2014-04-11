function [y  nc  failed  contactMode] = ffunMy(nc, x, aPosCtrl, objMass, objMOI, is_circular, objRadius, frameNum)
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
global rObPos
global FRAMERATE  
global sMu Mu1 Mu2 d

 
% g is gravity acceleration, b is the vector
global m_stepSize g b;                 % parameters and step size and gravity constant and lcp right item
global globalMass globalMinv m J Nu Pos;          % inertia matrix and mass
global m_numContacts colRes isInCollision;

% Comes from collision detection
global psi_n m_partialGapW_R_T_Time m_partialFricW_R_T_Time;

global   supportForces globalPext;

% Gn  Gf= [Gt  Go]
global Wn Wf Wt_s Wo_s E Es U Ws;
global totalSupportNum;     % vertices number of supporting tripod, 3 in this case
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
% supportPoints = [d 0; d*cos(2*pi/3) d*sin(2*pi/3); d*cos(4*pi/3) d*sin(4*pi/3)]'; 
%failed = false;
%lambda = 0;
%isStop = 0;
 

%% last step extraction
% x = x(:);
 
Pos = rObPos(frameNum, :);
%Pos = x(1:3)';
lastPos = rObPos(frameNum-1, :);
nextPos = rObPos(frameNum+1, :);
nextNextPos = rObPos(frameNum+2, :); 

% lastPos = [rObCenter(frameNum-1, 1:2) rObOrient(frameNum-1, 1)]';
% nextPos = [rObCenter(frameNum+1, 1:2) rObOrient(frameNum+1, 1)]';
Nu = (nextPos-lastPos) / (2*m_stepSize);
 
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
        
%         if strcmp(colRes{i}.body, 'actuator') % contact between body and actuator
%             U(i, i) = Mu1;
%         else                                  % contact between body and pegs
%             U(i, i) = Mu2;
%         end
%         
%         E(i*2-1, i) = 1.0;
%         E(i*2  , i) = 1.0;
%         
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

 
if(m_numContacts > 1)
    Gf = Wf;  Gn = Wn;  M = globalMass;  
    NU = Nu; 
    [mNu, nNu] = size(NU);
    if (mNu < nNu)
        NU = NU';
    end
    PSI = psi_n;
    h = m_stepSize;
    ql = Pos;  
    [mq, nq] = size(ql);
    if(mq < nq)
        ql = ql';
    end
    qbar = nextPos;
    filename = strcat('data_', num2str(frameNum), '.mat');
    save(filename, 'Gf', 'Gn', 'M', 'NU', 'PSI', 'h', 'ql', 'qbar', 'm', 'g', ...
         'm_partialGapW_R_T_Time', 'm_partialFricW_R_T_Time');
    disp('mat file has been saved');
    pause   
end
 
 
newNu = (nextNextPos - Pos) / (2 * m_stepSize);  
Nu = newNu(1, 1:3);
y = [nextPos Nu];
y = y(:);

failed = 0;
% newNu = pathlcp(A, b, l, u, z0);
% Nu = newNu(1:3, 1)';
% y  = [Pos + Nu*m_stepSize  Nu];
% y = y(:);
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