% To get the experiment data at a certain frame
load('rObCenterExp.mat');
load('rObOrientExp.mat');
load('data.mat');
rObCenterFrame = rObCenterExp(frame+1, :);
rObOrientFrame = rObOrientExp(frame+1, :);
qbar = [rObCenterFrame'; rObOrientFrame];
save('data.mat', 'qbar', '-append');