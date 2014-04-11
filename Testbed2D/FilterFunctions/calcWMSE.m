function wmse = calcWMSE(traj1, traj2, startID, endID)

wmse = 0;
traj1 = traj1(startID:endID, :);

L1 = size(traj1, 1);
L2 = size(traj2, 1);
[endID1,  smallID]   = min([L1, L2]);

etta = 14.5;
for i=1:endID1
    xdiff = traj1(i, 1) - traj2(i, 1);
    ydiff = traj1(i, 2) - traj2(i, 2);
    adiff = etta * (traj1(i, 3) - traj2(i, 3)); 
    wmse = wmse + xdiff * xdiff + ydiff * ydiff + adiff * adiff;
end

if smallID == 1
    endID2    = L2;
    traj_short = repmat(traj1(endID1, :), endID2-endID1, 1);
    traj_long  = traj2(endID1+1:endID2, :);
else
    endID2    = L1;
    traj_short = repmat(traj2(endID1, :), endID2-endID1, 1);
    traj_long  = traj1(endID1+1:endID2, :);    
end

for i = 1:endID2-endID1
    xdiff = traj_short(i, 1) - traj_long(i, 1);
    ydiff = traj_short(i, 2) - traj_long(i, 2);
    adiff = etta * (traj_short(i, 3) - traj_long(i, 3));
    wmse = wmse + xdiff * xdiff + ydiff * ydiff + adiff * adiff;    
end

wmse = sqrt(wmse)/(endID2-startID+1);
end