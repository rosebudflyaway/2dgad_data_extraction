function [ verticN, polygon ] = loadPolygonGeometry( filename )
% Load polygon vertices from geometry file
% the file follows the format of dvc pdat file

if ~exist(filename, 'file' )
   disp('The file path is incorrect!');  
   return
end

% open the file
fid = fopen(filename, 'r');

% get the vertices number
content = fscanf(fid, '%f');

% get the polygon vertices
verticN = content(1);

polygon = reshape(content(2:end), 2, verticN)';


end

