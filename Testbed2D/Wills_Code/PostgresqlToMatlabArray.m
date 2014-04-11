function [ matlabArray ] = PostgresqlToMatlabArray( postgresqlArray )
%POSTGRESQLTOMATLABARRAY Summary of this function goes here
%   Detailed explanation goes here

    s = char(postgresqlArray.toString);
    s = strrep(s,'{','[');
    s = strrep(s,'}',']');
    s = strrep(s,'],[','];[');
    s = strrep(s,',',' ');
    matlabArray = eval(s);
    
end
