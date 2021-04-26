function [ V, D ] = GSPCA( data, labels, nComp, param )
%GSPCA calculates generalised advanced supervised PCA with respect to [1].
%   [ V, D ] = GSPCA( data, labels, nComp, kind ) return n-by-nComp
%               matrix V with PCs as columns and diagonal nComp-by-nComp
%               matrix D with eigenvalues corresponding to PCs. 
%   data is n-by-m matrix of data (covariance matrix is unacceptable). Data
%       MUST be centred before.
%   labels is numeric vector with n elements. The same labels corresponds
%       to points of the same class. Number of unique values in labels is
%       L. Classes are numerated in the order of increasing value of labels.
%   nComp is number of required component.
%   param is parameter of method:
%       scalar numeric value is parameter of intraclass attraction: the
%           functional to maximise is mean squared distances between points
%           of different classes minus param multiplied to sum of mean
%           squared distances between points of each class
%       numeric vector with L elements is vector of attractions in each
%           class: the functional to maximise is mean squared distances
%           between points of different classes minus sum of  sum of mean
%           squared distances between points of each class multiplied by
%           corresponding element of vector param.
%       numeric matrix L-by-L is matrix of repulsion coefficients. The
%           elements upper than main diagonal are coefficients of repulsion
%           between corresponding clusses. The diagonal elements are
%           attraction coefficients for corresponding classes.
%
%References
%1. Mirkes, Evgeny M., Gorban, Alexander N., Zinovyev, Andrei Y.,
%   Supervised PCA, Available online in https://github.com/Mirkes/SupervisedPCA/wiki
%2. Gorban, Alexander N., Zinovyev, Andrei Y. “Principal Graphs and Manifolds”, 
%   Chapter 2 in: Handbook of Research on Machine Learning Applications and Trends: 
%   Algorithms, Methods, and Techniques, Emilio Soria Olivas et al. (eds), 
%   IGI Global, Hershey, PA, USA, 2009, pp. 28-59.
%3. Zinovyev, Andrei Y. "Visualisation of multidimensional data" Krasnoyarsk: KGTU,
%   p. 180 (2000) (In Russian).
%4. Koren, Yehuda, and Liran Carmel. "Robust linear dimensionality
%   reduction." Visualization and Computer Graphics, IEEE Transactions on
%   10.4 (2004): 459-470.

    %Get sizes of data
    [n, m] = size(data);
    data = double(data);
    labels = double(labels);
    % List of classes
    labs = unique(labels);
    % Number of classes
    L = length(labs);
    % Check the type of nComp
    if ~isnumeric(nComp) || nComp > m || nComp < 1
        error(['Incorrect value of nComp: it must be positive integer',...
            ' equal to or less than m']);
    end
    
    % Form matrix of coefficients
    if isscalar(param)
        coef = ones(L);
        coef = coef + diag((param - 1) * diag(coef));
    elseif isvector(param)
        if length(param) ~= L
            error(['Argument param must be scalar, or vector with L',...
                ' elements of L-by-L matrix,\n where L is number of',...
                ' classes (unique values in labels)']);
        end
        coef = ones(L);
        coef = coef + diag(diag(param - 1));
    elseif ismatrix(param)
        [a, b] = size(param);
        if a ~= L || b ~= L
            error(['Argument param must be scalar, or vector with L',...
                ' elements of L-by-L matrix,\n where L is number of',...
                ' classes (unique values in labels)']);
        end
    else
        error(['Argument param must be scalar, or vector with L',...
            ' elements of L-by-L matrix,\n where L is number of',...
            ' classes (unique values in labels)']);
    end
    
    % Symmetrize coef matrix
    coef = coef - tril(coef, -1) + triu(coef, 1)';
    
    % Calculate diagonal terms of Laplacian matrix without devision by
    % number of elements in class
    diagV = diag(coef)';
    diagC = sum(coef) - diagV;
    
    % Calculate transformed covariance matrix
    M = zeros(m);
    means = zeros(L, m);
    % Loop to form the diagonal terms and calculate means
    for c = 1:L
        % Get index of class
        ind = labels == labs(c);
        % Calculate mean
        means(c, :) = mean(data(ind, :));
        % Calculate coefficient for Identity term
        nc = sum(ind);
        coefD = diagC(c) / nc - 2 * diagV(c) / (nc - 1);
        % Add the diagonal term
        M = M + 2 * diagV(c) * nc / (nc - 1) * (means(c, :)' * means(c, :))...
            + coefD * data(ind, :)' * data(ind, :);
    end
    
    % Loop for off diagonal parts
    for c = 1:L - 1
        for cc = c + 1:L
            tmp = means(c, :)' * means(cc, :);
            M = M - coef(c, cc) * (tmp + tmp');
        end
    end

    %Request calculations from eigs
    if nComp<m-1
        [ V, D ] = eigs(M, nComp);
    else
        [ V, D ] = eig(M);
    end
end