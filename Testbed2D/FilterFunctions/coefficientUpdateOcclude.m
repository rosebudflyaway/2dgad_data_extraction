function [ rou ] = coefficientUpdateOcclude(yOb, yTactile, contactMode, closure, kFV)

rou = 1;

yContact = zeros(3, 1);
yContact(1) = floor(contactMode/4);
yContact(2) = floor((contactMode - yContact(1) * 4)/2);
yContact(3) = mod(contactMode, 2);

% yTactile(1)
% yTactile(2)
% yTactile(3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%           Probability       0         1       real contact
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%             0               0.8       0.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%             1               0.2       0.8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%         observed                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tactileProb = [0.99      0.3;
               0.01      0.7];
           
%            [0.7 0.3;
%             0.3 0.7;];

rou1 = tactileProb(yTactile(1)+1, yContact(1)+1);
rou2 = tactileProb(yTactile(2)+1, yContact(2)+1);
rou3 = tactileProb(yTactile(3)+1, yContact(3)+1);


% closure update
if closure && (max(kFV) > 1.2)
    %disp(['Incorrect closure! ' num2str(max(yOb(:, 2) - yOb(:, 1)))]);
    rou4 = 0.05;
else
    rou4 = 1;
end

rou5 = 1;
if (max(kFV) < 0.5)
    if closure
        rou5 = 1;
    else
        rou5 = 0.1;
    end
end



           
rou = rou * rou1 * rou2 * rou3 * rou4 * rou5;

%disp(closure);
end