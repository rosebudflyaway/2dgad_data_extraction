radius = 4.7625;
points = 60;

sliceAngle = 2*pi/points;

a = zeros(points, 2);
for i = 1:points
    a(i, :) = radius*[cos(-sliceAngle*(i-1)), sin(-sliceAngle*(i-1))];
end

fixelfile = 'config/dakota_fixel.pdat';

fid = fopen(fixelfile, 'w');
fprintf(fid, '%d\n\n', points);
for i = 1:points
    fprintf(fid, '%.2f %.2f\n', a(i,1), a(i,2));
end
fclose(fid);


b= [a; a(1,:)];
plot(b(:, 1), b(:, 2), 'g-');
axis equal
