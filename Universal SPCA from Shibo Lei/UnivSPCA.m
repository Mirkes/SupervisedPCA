function [ V, D ] = UnivSPCA( data, nComp, W )
% Return n-by-nComp matrix V with PCs as columns and diagonal
% nComp-by-nComp matrix D with eigenvalues corresponding to PCs.
% This function is faster than BigdataSPCA but cannot work with big
% datasets.
%
%   data is a n-by-m matrix of data.
%   nComp is the number of required component.
%   W is a n-by-n weight matrix.

    Q = data' * ( sum(W,2) .* data ) - data' * W * data;
    [V, D] = eigs(Q, nComp);
    D = diag(D);
    [D, ind] = sort(D, 'descend');
    D = diag(D(1:nComp));
    V = V(:, ind);
    V = V(:, 1:nComp);
end