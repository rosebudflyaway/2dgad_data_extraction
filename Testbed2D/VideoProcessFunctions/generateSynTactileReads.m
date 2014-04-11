function synTactileReads = generateSynTactileReads(rObCenter, rObOrient, rPegsCenter, object_geometry_id, expFinalContactMode)

global pegR;
global tactileSensorReads;

dbImportObjectGeometry;

frameN = numel(rObOrient);
synTactileReads = zeros(frameN, 3);
dis = zeros(frameN, 3);
epsilon = 0.95;
tactileLen = size(tactileSensorReads, 1)
frameN

global positiveReadDis
global negativeReadDis
positiveReadDisThreashold = 0;

for i = 1:frameN
    
    %for each frame, calculate the distance from each peg center to the
    %object, if the distance equal to the peg radius, it suggests contact
    %exists between the object and peg
    %   i, tactileSensorReads(i, :)
    
    for j = 1:3
        if ~is_circular
            dis(i, j) = dis2boundary(rPegsCenter(j, 1:2), rObCenter(i, 1:2), rObOrient(i), objGeometry);
        else
            dis(i, j) = norm(rPegsCenter(j, 1:2)-rObCenter(i, 1:2), 2) - objRadius;
        end
        if dis(i, j) < 10 && dis(i, j) > positiveReadDisThreashold && tactileSensorReads(i, j) == 1
            positiveReadDisThreashold = dis(i, j);
        end
        if tactileSensorReads(i, j) == 1
            positiveReadDis = [positiveReadDis dis(i, j)];
        end
        if tactileSensorReads(i, j) == 0 && dis(i, j) < 20
            negativeReadDis = [negativeReadDis dis(i, j)];
        end
        if dis(i, j) - pegR < epsilon
            synTactileReads(i, j) = 1;            % Contact happens
        end
    end
end
positiveReadDisThreashold


%Compare the synthetic tactile reads with final experiment contact mode, if
%different, then print a warning
synFinalContactMode = 4 * synTactileReads(end, 1) + 2 * synTactileReads(end, 2) + 1 * synTactileReads(end, 3);
if synFinalContactMode ~= expFinalContactMode
    warning(['synthetic final contact mode is different from the experiment, syn: ', num2str(synFinalContactMode), '; exp: ', num2str(expFinalContactMode)]);
else
    disp(['final contact mode is ', num2str(synFinalContactMode)]);
end

    figure, title('synthetic tactile reads'), hold on
    plot(1:size(synTactileReads, 1), 4 * synTactileReads(:, 1) + 2 * synTactileReads(:, 2) + 1 * synTactileReads(:, 3), 'g.');
    plot(1:size(synTactileReads, 1), expFinalContactMode, 'r');
    plot(1:size(tactileSensorReads, 1), 4 * tactileSensorReads(:, 1) + 2 * tactileSensorReads(:, 2) + 1 * tactileSensorReads(:, 3), 'bo');
   
    legend('synthetic', 'experimental Final');
end