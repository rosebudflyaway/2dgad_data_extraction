function contactMode = collisionDetection(aPosCtrl)

global B1 B2
global Nu Pos fixels;
global pegR;

global m_numContacts colRes isInCollision;
global epsilon
global m_stepSize;

global fContact;


% calculate the epsilon
RB1 = max(sqrt(B1(:, 1).*B1(:, 1) + B1(:, 2).*B1(:, 2)))+5;
RB2 = max(sqrt(B2(:, 1).*B2(:, 1) + B2(:, 2).*B2(:, 2)))+5;
collision_epsilon = 1e-05;
vel1 = abs(Nu(1:2)) + abs(Nu(3) * [RB1, RB1]);
%stepCount
vel2 = abs(aPosCtrl(1, :) - aPosCtrl(2, :))/m_stepSize;
epsilon = collision_epsilon + max(vel1(1)+vel2(1), vel1(2)+vel2(2)) * m_stepSize;

% initialize the important global variables need to be updated in CD
colRes = [];
m_numContacts = 0;
isInCollision = false;
fContact(1) = false;
fContact(2) = false;
fContact(3) = false;

if circleIntersectTest(Pos(1), Pos(2), RB1, ...
        aPosCtrl(1, 1), aPosCtrl(1, 2), RB2, epsilon)
    % pass the circle test
    
    polypolytest(1, 2, Pos, aPosCtrl(1, :), '2');
    polypolytest(2, 1, aPosCtrl(1, :), Pos, '2');
end

vel2 = [0 0];
epsilon = collision_epsilon + max(vel1(1)+vel2(1), vel1(2)+vel2(2)) * m_stepSize;
if circleIntersectTest(Pos(1), Pos(2), RB1, ...
        fixels(1, 1), fixels(1, 2), pegR, epsilon)
    fContact(1) = polyCircleTest(fixels(1, :), Pos);
    
end

if circleIntersectTest(Pos(1), Pos(2), RB1, ...
        fixels(2, 1), fixels(2, 2), pegR, epsilon)
    
    % polypolytest(1, 3, Pos, fixels(2, :), '3');
    % polypolytest(3, 1, fixels(2, :), Pos, '3');
    fContact(2) = polyCircleTest(fixels(2, :), Pos);
end

if circleIntersectTest(Pos(1), Pos(2), RB1, ...
        fixels(3, 1), fixels(3, 2), pegR, epsilon)
    
    % polypolytest(1, 3, Pos, fixels(3, :), '3');
    % polypolytest(3, 1, fixels(3, :), Pos, '3');
    fContact(3) = polyCircleTest(fixels(3, :), Pos);
end
% if isAnimate
% disp(m_numContacts);
% end
if m_numContacts >= 1
    isInCollision = true;
end

contactMode = fContact(1) * 4 + fContact(2) * 2 + fContact(3) * 1;

return

% Roughly check whether intersection happen
function [intersectOrNot] = circleIntersectTest(x1, y1, r1, x2, y2, r2, epsilon)
% roughly chech whether intersection happened

dx = x1 - x2;
dy = y1 - y2;
rhs = epsilon + r1 + r2;
if dx*dx + dy*dy < rhs*rhs
    intersectOrNot = true;
else
    intersectOrNot = false;
end

% Transform point p from local to global
function [ pN ] = transformFrame( p, P )
% local coordinate origin (Tx, Ty), orient: theta

cosT = cos(P(3));
sinT = sin(P(3));
pN(1) = (cosT*p(1) - sinT*p(2)) + P(1);
pN(2) = (sinT*p(1) + cosT*p(2)) + P(2);

% Inverse transform point p from global to local
function [ pN ] = inverseTransformFrame( p, P )
% local coordinate origin (Tx, Ty), orient: theta

cosT = cos(P(3));
sinT = sin(P(3));
t = p - P(1:2);
pN(:, 1) =  cosT*t(1) + sinT*t(2);
pN(:, 2) = -sinT*t(1) + cosT*t(2);


% calculate the distance from point p to segment (p1, p2)
function [ dis isE1 isE2 ] = dis2Segment( p, p1, p2 )
v = p2 - p1;
w = p - p1;
c1 = sum(w.*v);
isE1 = false;
isE2 = false;
if c1 <= 0
    dis = norm(p-p1, 2);
    isE1 = true;
    return
end
c2 = sum(v.*v);
if c2 <= c1
    dis = norm(p-p2, 2);
    isE2 = true;
    return
end
b = c1 / c2;
pb = p1 + b*v;
dis = norm(p-pb, 2);

function [ dis contactLoc ] = vertLineDist(p, P1, P2)
% calculate the distance from point p to infinite line passing P1 & P2
v = P2 - P1;
w = p - P1;
c1 = sum(w.*v);
c2 = sum(v.*v);
b = c1/c2;
contactLoc = P1 + b * v;
dis = norm(contactLoc-p, 2);

function collide = polyCircleTest(x1, x2)
%only detect once with p1 = peg, p2 = body
global B1
global epsilon
global pegR
collide = false;
b2 = B1; %the body
n2 = size(b2, 1);
%FP_EPSILON = 1e-1;
radius = pegR;
for j=1:n2
    e1 = j;
    e2 = bmod(j+1, n2);
    e1W = transformFrame(b2(e1, :), x2);
    e2W = transformFrame(b2(e2, :), x2);
    [dis isE1 isE2] = dis2Segment( x1(1:2), e1W, e2W ); %measure the distance from the circle center to the body segment
    if dis <= radius + epsilon
        collide = true;
        if isE1
            addCircleResult(dis-radius, e1W, e1W, e2W);
        elseif isE2
            addCircleResult(dis-radius, e2W, e1W, e2W);
        else
            [ regDis pLoc ] = vertLineDist(x1(1:2), e1W, e2W);
            addCircleResult(dis-radius, pLoc, e1W, e2W);
        end
    end
end


function polypolytest(p1, p2, x1, x2, body)
% test body p1 and body p2
global B1 B2 B3
global epsilon
FP_EPSILON = 1e-6;
b1 = eval(['B' num2str(p1)]);
b2 = eval(['B' num2str(p2)]);
b2scale = scalePolygon(b2, epsilon);
n1 = size(b1, 1);
n2 = size(b2, 1);

for i=2:n1+1
    
    prev = i-1;
    cur = bmod(i, n1);
    next = bmod(i+1, n1);
    
    p1CW = transformFrame(b1(cur, :), x1);
    p1CO = inverseTransformFrame(p1CW, x2);
    
    if pointInPolygon(p1CO, b2scale)
        % find the closest edge segment in body 2
        minDis = 1e20;
        for j=1:n2
            e1 = j;
            e2 = bmod(j+1, n2);
            e1W = transformFrame(b2(e1, :), x2);
            e2W = transformFrame(b2(e2, :), x2);
            
            [dis isE1 isE2] = dis2Segment( p1CW, e1W, e2W );
            if dis < minDis
                minDis = dis;
                closestE1W = e1W;
                closestE2W = e2W;
                closestIsE1 = isE1;
                closestIsE2 = isE2;
                closestID = j;
            end
        end % end for loop of j
        
        p1prevW = transformFrame(b1(prev, :), x1);
        p1nextW = transformFrame(b1(next, :), x1);
        if closestIsE1 || closestIsE2
            if closestIsE1
                p2prev = bmod(closestID-1+n2, n2);
                p2prevE1W = transformFrame(b2(p2prev, :), x2);
                edge1Pass = normalConeTest(p1prevW, p1CW, p1nextW, p2prevE1W, closestE1W);
                edge2Pass = normalConeTest(p1prevW, p1CW, p1nextW, closestE1W, closestE2W);
                if edge1Pass && edge2Pass
                    [ regDis contactLoc ] = vertLineDist(p1CW, p2prevE1W, closestE1W);
                    if pointInPolygon(p1CO, b2)
                        regDis = -regDis;
                    end
                    addResult(regDis, contactLoc, p2prevE1W, closestE1W, p1CW, body, p1);
                    
                    [ regDis contactLoc ] = vertLineDist(p1CW, closestE1W, closestE2W);
                    if pointInPolygon(p1CO, b2)
                        regDis = -regDis;
                    end
                    addResult(regDis, contactLoc, closestE1W, closestE2W, p1CW, body, p1);
                    
                elseif edge1Pass
                    [ regDis contactLoc ] = vertLineDist(p1CW, p2prevE1W, closestE1W);
                    if pointInPolygon(p1CO, b2)
                        regDis = -regDis;
                    end
                    addResult(regDis, contactLoc, p2prevE1W, closestE1W, p1CW, body, p1);
                else
                    
                    [ regDis contactLoc ] = vertLineDist(p1CW, closestE1W, closestE2W);
                    if pointInPolygon(p1CO, b2)
                        regDis = -regDis;
                    end
                    addResult(regDis, contactLoc, closestE1W, closestE2W, p1CW, body, p1);
                end %end normal cone test
            else % closestIsE2
                p2next = bmod(closestID+1, n2);
                p2nextE2W = transformFrame(b2(p2next, :), x2);
                edge1Pass = normalConeTest(p1prevW, p1CW, p1nextW, closestE1W, closestE2W);
                edge2Pass = normalConeTest(p1prevW, p1CW, p1nextW, closestE2W, p2nextE2W);
                if edge1Pass && edge2Pass
                    [ regDis contactLoc ] = vertLineDist(p1CW, closestE1W, closestE2W);
                    if pointInPolygon(p1CO, b2)
                        regDis = -regDis;
                    end
                    addResult(regDis, contactLoc, closestE1W, closestE2W, p1CW, body, p1);
                    
                    [ regDis contactLoc ] = vertLineDist(p1CW, closestE2W, p2nextE2W);
                    if pointInPolygon(p1CO, b2)
                        regDis = -regDis;
                    end
                    addResult(regDis, contactLoc, closestE2W, p2nextE2W, p1CW, body, p1);
                    
                elseif edge1Pass
                    [ regDis contactLoc ] = vertLineDist(p1CW, closestE1W, closestE2W);
                    if pointInPolygon(p1CO, b2)
                        regDis = -regDis;
                    end
                    addResult(regDis, contactLoc, closestE1W, closestE2W, p1CW, body, p1);
                else
                    
                    [ regDis contactLoc ] = vertLineDist(p1CW, closestE2W, p2nextE2W);
                    if pointInPolygon(p1CO, b2)
                        regDis = -regDis;
                    end
                    addResult(regDis, contactLoc,closestE2W, p2nextE2W, p1CW, body, p1);
                end %end normal cone test
            end
        else % neither closestIsE1 nor closestIsE2, vertext edge contact
            [ regDis contactLoc ] = vertLineDist(p1CW, closestE1W, closestE2W);
            if pointInPolygon(p1CO, b2)
                regDis = -regDis;
            end
            addResult(regDis, contactLoc, closestE1W, closestE2W, p1CW, body, p1);
            
            % consider the case of overlapping
            p2prev = bmod(closestID-1+n2, n2);
            p2next = bmod(closestID+2, n2);
            p2prevE1W = transformFrame(b2(p2prev, :), x2);
            p2nextE2W = transformFrame(b2(p2next, :), x2);
            
            if regDis < FP_EPSILON
                
                if segmentsOverlap(p1prevW, p1CW, p2prevE1W, closestE1W)
                    [ regDis contactLoc ] = vertLineDist(p1CW, p2prevE1W, closestE1W);
                    if regDis <= epsilon
                        if sideOfLine(p2prevE1W, closestE1W, p1CW) < 0
                            regDis = -regDis;
                        end
                        addResult(regDis, contactLoc, p2prevE1W, closestE1W, p1CW, body, p1);
                    end
                elseif segmentsOverlap(p1prevW, p1CW, closestE2W, p2nextE2W)
                    [ regDis contactLoc ] = vertLineDist(p1CW, closestE2W, p2nextE2W);
                    if regDis <= epsilon
                        if sideOfLine(closestE2W, p2nextE2W, p1CW) < 0
                            regDis = -regDis;
                        end
                        addResult(regDis, contactLoc, closestE2W, p2nextE2W, p1CW, body, p1);
                    end
                elseif segmentsOverlap(p1CW, p1nextW, p2prevE1W, closestE1W)
                    [ regDis contactLoc ] = vertLineDist(p1CW, p2prevE1W, closestE1W);
                    if regDis <= epsilon
                        if sideOfLine(p2prevE1W, closestE1W, p1CW) < 0
                            regDis = -regDis;
                        end
                        addResult(regDis, contactLoc, p2prevE1W, closestE1W, p1CW, body, p1);
                    end
                elseif segmentsOverlap(p1CW, p1nextW, closestE2W, p2nextE2W)
                    [ regDis contactLoc ] = vertLineDist(p1CW, closestE2W, p2nextE2W);
                    if regDis <= epsilon
                        if sideOfLine(closestE2W, p2nextE2W, p1CW) < 0
                            regDis = -regDis;
                        end
                        addResult(regDis, contactLoc, closestE2W, p2nextE2W, p1CW, body, p1);
                    end
                end
            end % end regdistance < FP_EPSILON
        end
    end % end point in polygon
end

% expand a polygon by the value of eps
function [ scaled ] = scalePolygon(p, eps)
FP_EPSILON = 1e-6;
if eps < FP_EPSILON
    scaled = p;
    return
end
scaled = [];
N = size(p, 1);
for i=1:N
    prev = bmod(i-1+N, N);
    next = bmod(i+1, N);
    prevP = p(prev, :);
    curP = p(i, :);
    nextP = p(next, :);
    
    innerAngle = angle3P(prevP, curP, nextP);
    edge = curP - prevP;
    edge = edge/norm(edge, 2);
    normal = [-edge(2) edge(1)];
    new_point = normal*eps + curP;
    nN = size(scaled, 1);
    if ~pointInPolygon(new_point, p)
        scaled(nN+1, :) = new_point;
        nN = nN + 1;
    end
    
    cosT = cos(innerAngle/2);
    sinT = sin(innerAngle/2);
    
    normal(1) = cosT*edge(1) - sinT * edge(2);
    normal(2) = sinT*edge(1) + cosT * edge(2);
    new_point = normal * eps + curP;
    if ~pointInPolygon(new_point, p)
        scaled(nN+1, :) = new_point;
        nN = nN + 1;
    end
    
    
    edge = nextP - curP;
    edge = edge/norm(edge, 2);
    normal = [-edge(2) edge(1)];
    new_point = normal * eps + curP;
    if ~pointInPolygon(new_point, p)
        scaled(nN+1, :) = new_point;
    end
end

% decide whether a point is inside a polygon
function [ insideOrNot ] = pointInPolygon(p, P)
insideOrNot = false;
N = size(P, 1);
tx = p(1);
ty = p(2);
yflag0 = (P(N,2)>= ty);
prev = N;

for i=1:N
    yflag1 = (P(i, 2) >= ty);
    if yflag0 ~= yflag1
        xflag0 = (P(prev, 1) >= tx);
        if xflag0 == (P(i, 1) >= tx)
            if xflag0
                insideOrNot = ~insideOrNot;
            end
        else
            if  (P(i,1)-(P(i,2)-ty)*(P(prev,1)- P(i,1))/(P(prev, 2)-P(i, 2))) >= tx
                insideOrNot = ~insideOrNot;
            end
        end
    end
    yflag0 = yflag1;
    prev = i;
end


function [ overlapOrNot ] = collinearSegmentsCoincidentUsingSorting(e1, e2, e3, e4)
FP_EPSILON =  1e-6;
if abs(e1(1) - e2(1)) < FP_EPSILON
    if e1(2) < e2(2)
        min1 = e1;
        max1 = e2;
    else
        min1 = e2;
        max1 = e1;
    end
    if e3(2) < e4(2)
        min2 = e3;
        max2 = e4;
    else
        min2 = e4;
        max2 = e3;
    end
    
    if (max1(2) + FP_EPSILON) >= min2(2) && (max2(2) + FP_EPSILON) >= min1(2)
        overlapOrNot = true;
    else
        overlapOrNot = false;
    end
    return
else
    if e1(1) < e2(1)
        min1 = e1;
        max1 = e2;
    else
        min1 = e2;
        max1 = e1;
    end
    
    if e3(1) < e4(1)
        min2 = e3;
        max2 = e4;
    else
        min2 = e4;
        max2 = e3;
    end
    
    if (max1(1)+FP_EPSILON) >= min2(1) && (max2(1)+FP_EPSILON) >= min1(1)
        overlapOrNot = true;
    else
        overlapOrNot = false;
    end
    return
end

% decide whether two segments overlap
function [ overlapOrNot ] = segmentsOverlap(e1, e2, e3, e4)
FP_EPSILON = 1e-6;
u = e2 - e1;
v = e4 - e3;
w = e1 - e3;
D = cross2d(u, v);

if abs(D) < FP_EPSILON
    if abs(cross2d(u, w) > FP_EPSILON || abs(cross2d(v, w)) > FP_EPSILON)
        overlapOrNot = false;
        return
    end
    overlapOrNot = collinearSegmentsCoincidentUsingSorting(e1, e2, e3, e4);
    return
end

sI = cross2d(v, w)/D;
if sI < FP_EPSILON || sI > 1-FP_EPSILON
    overlapOrNot = false;
    return
end

tI = cross2d(u, w)/D;
if tI < FP_EPSILON || tI > 1-FP_EPSILON
    overlapOrNot = false;
    return
end

overlapOrNot = true;
return

% record a collision result
function [] = addCircleResult(d, Loc, E1, E2)
global m_numContacts colRes
m_numContacts = m_numContacts + 1;

col.body = 'peg';
col.distance = d;
col.contactLoc = Loc;
col.vertex = Loc;
e = E2 - E1;
e = e/norm(e, 2);
col.normal = [e(2) -e(1)];
colRes{m_numContacts} = col;


% record a collision result
function [] = addResult(d, Loc, E1, E2, p, body, body1)
global m_numContacts colRes
m_numContacts = m_numContacts + 1;
if body == '2'
    col.body = 'actuator';
else
    col.body = 'peg';
end
col.distance = d;
col.contactLoc = Loc;
col.vertex = p;
e = E2 - E1;
e = e/norm(e, 2);
if body1 == 1
    col.normal = [-e(2) e(1)];
else
    col.normal = [e(2) -e(1)];
end
colRes{m_numContacts} = col;

function [ passOrNot ] = normalConeTest(f1, f2, f3, e1, e2)

coneEdge1 = f1 - f2;
coneEdge2 = f3 - f2;

edge = e2 - e1;

negEdgeNormal = [edge(2) -edge(1)];
negEdgeNormal = negEdgeNormal/norm(negEdgeNormal, 2);

coneEdge1 = coneEdge1/norm(coneEdge1, 2);

fudge = 0.017452778;

val1 = sum(coneEdge1.*negEdgeNormal);
if val1 > fudge
    passOrNot = false;
    return
end

coneEdge2 = coneEdge2/norm(coneEdge2, 2);
val2 = sum(coneEdge2.*negEdgeNormal);
if val2 <= fudge
    passOrNot = true;
    return
else
    passOrNot = false;
    return
end

function [ angle ] = angle3P(p1, p2, p3)
angle = vertexAngle(p2-p1, p2-p3);
return

function [ angle ] = vertexAngle(v1, v2)
temp = min(1.0, sum((v1/norm(v1, 2)).*(v2/norm(v2, 2))));
angle = acos(temp);
return

function [ lineSide ] = sideOfLine(p, e1, e2)
lineSide = ( (p(2)-e1(2))*(e2(1)-p(1)) + (e1(1)-p(1))*(e2(2)-p(2)));
return