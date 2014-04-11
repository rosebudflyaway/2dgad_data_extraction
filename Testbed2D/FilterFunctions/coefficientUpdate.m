function [ rou ] = coefficientUpdate(yOb, y_l, v_d, yTactile, contactMode, closure, kFV)

rou = density(v_d, yOb(:, 1) - y_l);


yContact = zeros(3, 1);
yContact(1) = floor(contactMode/4);
yContact(2) = floor((contactMode - yContact(1) * 4)/2);
yContact(3) = mod(contactMode, 2);

% yTactile(1)
% yTactile(2)
% yTactile(3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%           Probability        0             1       real contact
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%             0               0.9575       0.0125
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%             1               0.0425       0.9875
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%         observed                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tactileProb = [0.9      0.1;
               0.1      0.9];
           %            [0.7 0.3;
%             0.3 0.7;];

rou1 = tactileProb(yTactile(1)+1, yContact(1)+1);
rou2 = tactileProb(yTactile(2)+1, yContact(2)+1);
rou3 = tactileProb(yTactile(3)+1, yContact(3)+1);

% closure update
if (max(kFV) > 1.2) && closure
    %disp(['Incorrect closure! ' num2str(max(yOb(:, 2) - yOb(:, 1)))]);
    rou4 = 0.01;
else
    rou4 = 1;
end

           
rou = rou * rou1 * rou2 * rou3 * rou4;

%disp(closure);
end