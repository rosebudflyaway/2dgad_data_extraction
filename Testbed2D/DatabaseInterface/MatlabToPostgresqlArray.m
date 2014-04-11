function [ postgresArray ] = MatlabToPostgresqlArray( matlabArray )
%MATLABTOPOSTGRESARRAY Converts a 1xN or MxN Matlab array to a Postgresql array
%   Detailed explanation goes here

postgresArray = '{';
dims = size(matlabArray);

for i = 1:dims(1)
    postgresArray = strcat(postgresArray,'{');
    for j = 1:dims(2)
        postgresArray = strcat(postgresArray,num2str(matlabArray(i,j)),',');
    end
    postgresArray = strcat(postgresArray(1:end-1), '},');
end
postgresArray = strcat(postgresArray(1:end-1), '}');

if(dims(1) == 0)
    postgresArray = '{}';
end

if(dims(1) == 1)
    postgresArray = strcat(postgresArray(2:end-1));
end

end

