function [ pN ] = local2global( p, Tx, Ty, theta )
% transform point p from local to global
% local coordinate origin (Tx, Ty), orient: theta

cosT = cos(theta);
sinT = sin(theta);

n = size(p, 1);

pN(:, 1) = ( sinT*p(:, 1) + cosT*p(:, 2)) + repmat(Tx, n, 1);
pN(:, 2) = (-cosT*p(:, 1) + sinT*p(:, 2)) + repmat(Ty, n, 1);

end

