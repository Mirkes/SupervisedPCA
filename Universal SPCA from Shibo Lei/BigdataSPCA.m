function [V, D] = BigdataSPCA( data, nComp, GetW, s_f )
%   Return n-by-nComp matrix V with PCs as columns and diagonal
%   nComp-by-nComp matrix D with eigenvalues corresponding to PCs.
%
%   data is a n-by-m data matrix.
%   nComp is the number of required component.
%   GetW is the name of a function which could get a fragment of weights
%       matrix W. GetW have 4 inputs to specify a certain fragment of
%       matrix W. i.e. GetW(b1, e1, b2, e2) = W(b1:e1, b2:e2)
%   s_f (optional) is the maximum size of fragment. 10k if not specified.

    if nargin < 4
        s_f = 10000;
    end

    [n, m] = size(data);
    n_b = ceil(n/s_f);
    Sums = zeros(n, 1);
    Q = zeros(m, m);

    for i = 1:n_b
        % Starting point and ending point.
        bi = 1+s_f*(i-1);
        ei = s_f*i;
        % The last point cannot be greater than n
        if ei > n
            ei = n;
        end
        f_data_i = data(bi:ei, :);
        tmp = GetW(bi, ei, bi, ei);
        % Make sure it is a symmetric matrix
        f_W = triu(tmp) + triu(tmp,1)';

        tmp = f_data_i' * f_W * f_data_i;
        Q = Q - tmp;

        Sums(bi:ei) = Sums(bi:ei) + sum(f_W, 2);
        for j = i+1:n_b
            % Starting point and ending point.
            bj = 1+s_f*(j-1);
            ej = s_f*j;
            % The last point cannot be greater than n
            if ej > n
                ej = n;
            end
            f_data_j = data(bj:ej, :);
            f_W = GetW(bi, ei, bj, ej);
            tmp = f_data_i' * f_W * f_data_j;
            Q = Q - tmp - tmp';

            Sums(bi:ei) = Sums(bi:ei) + sum(f_W, 2);
            Sums(bj:ej) = Sums(bj:ej) + sum(f_W, 1)';
        end
    end

    Q = Q + data' * ( Sums .* data );
    [V, D] = eig(Q);
    D = diag(D);
    [D, ind] = sort(D, 'descend');
    D = diag(D(1:nComp));
    V = V(:, ind);
    V = V(:, 1:nComp);
end