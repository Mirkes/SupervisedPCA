function [V, D] = ClassSPCA( data, labels, nComp, reduced_W )
%   Return n-by-nComp matrix V with PCs as columns and diagonal
%   nComp-by-nComp matrix D with eigenvalues corresponding to PCs.
%
%   data is a n-by-m matrix of centralized data.
%   labels is a n-ny-1 matrix that shows the labels of data. The same
%       labels corresponds to points of the same class. Number of unique
%       values in labels is L.
%   nComp is the number of required component.
%   reduced_W is a L-by-L reduced weight matrix: element reduced_W(i,j)
%       defines repulsion (for positive) or attraction (for negative) of
%       elements of classes i and j.

    [n, m] = size(data);
    class = unique(labels);
    L = length(class);
    % Label the data, each column corresponds to a class.
    ind = false(n,L);
    for i = 1:L
        ind(:,i) = labels == class(i);
    end
    % The number of instances in this class
    nc = sum(ind);
    % SPCA algorithm
    Q = data' * (data .* sum(sum(reduced_W .* nc,2)' .* ind, 2));
    Sums_of_data = zeros(L,m);
    for i = 1:L
        Sums_of_data(i,:) = sum(data(ind(:,i),:));
    end
    for i = 1:L
        for j = 1:L
            Q = Q - reduced_W(i,j) * Sums_of_data(i,:)' * Sums_of_data(j,:);
        end
    end

    [V, D] = eig(Q);
    D = diag(D);
    [D, ind] = sort(D, 'descend');
    D = diag(D(1:nComp));
    V = V(:, ind);
    V = V(:, 1:nComp);
end