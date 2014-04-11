function loadGeometryFromPdatAndWrite2Database(filename)

objGeometry = dlmread(filename, ' ');

vN = objGeometry(1, 1);

objGeometry(1, :) = [];

dbExportObjectGeometry;

end
