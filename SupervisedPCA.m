function [ V, D ] = SupervisedPCA( data, labels, nComp, kind )
%SupervisedPCA calculates supervised PCA with respect to [1].
%   [ V, D ] = SupervisedPCA( data, labels, nComp, kind ) return m-by-nComp
%               matrix V with PCs as columns and diagonal nComp-by-nComp
%               matrix D with eigenvalues for each component. 
%   data is n-by-m matrix of data (covariance matrix is unacceptable). Data
%       MUST be centred before.
%   labels is numeric vector with n elements. The same labels corresponds
%       to points of the same class.
%   nComp is number of required component.
%   kind is kind of calculated PCA. Acceptable values:
%       'norm' is normalized PCA. Elements of Laplacian matrix are:
%               L(i,j) = -1/distance(data(:,i)-data(:,j)) for i~=j
%               L(i,i) = -sum(L(:,i))+L(i,i);
%       'super' is supervised PCA. Elements of Laplacian matrix are:
%               L(i,j) = 0 if labels(i)==labels(j),i~=j;
%               L(i,j) = -1 if labels(i)~=labels(j),i~=j;
%               L(i,i) = -sum(L(:,i))+L(i,i);
%       'supernorm' is supervised normalized PCA. Elements of Laplacian
%           matrix are: 
%               L(i,j) = 0 if labels(i)==labels(j),i~=j;
%               L(i,j) = -1/distance(data(:,i)-data(:,j)) 
%                   if labels(i)~=labels(j),i~=j;
%               L(i,i) = -sum(L(:,i))+L(i,i);
%       'usual' corresponds to usual PCA. Elements of Laplacian matrix are:
%               L(i,j) = -1 if i~=j;
%               L(i,i) = -sum(L(:,i))+L(i,i);
%       number. Specified number corresponds to parameter alpha of advanced
%           supervised PCA. Elements of Laplacian matrix are:
%               L(i,j) = -1/Number of pairs with points in different
%                   classes if labels(i)~=labels(j),i~=j;
%               L(i,j) = alpha/Nu(Nu-1) where Nu is number of points in class
%                   label(i) if labels(i)==labels(j),i~=j;
%               L(i,i) = -sum(L(:,i))+L(i,i);
%       matrix. In this case kinds must be numerical n-by-n Laplacian
%               matrix. 
%
%References
%1. Gorban, Alexander N., Zinovyev, Andrei Y. “Principal Graphs and Manifolds”, 
%   Chapter 2 in: Handbook of Research on Machine Learning Applications and Trends: 
%   Algorithms, Methods, and Techniques, Emilio Soria Olivas et al. (eds), 
%   IGI Global, Hershey, PA, USA, 2009, pp. 28-59.
%2. Zinovyev, Andrei Y. "Visualisation of multidimensional data" Krasnoyarsk: KGTU,
%   p. 180 (2000) (In Russian).
%3. Koren, Yehuda, and Liran Carmel. "Robust linear dimensionality
%   reduction." Visualization and Computer Graphics, IEEE Transactions on
%   10.4 (2004): 459-470.

    %Get sizes of data
    n = size(data, 1);
    data = double(data);
    labels = double(labels);
    
    %Calculate Laplacian matrix
    if ischar(kind)
        if strcmpi(kind,'norm')
            L = prepareNorm(data);
        elseif strcmpi(kind,'super')
            L = prepareSuper(labels);
        elseif strcmpi(kind,'supernorm')
            L = prepareNorm(data) .* prepareSuper(labels);
        elseif strcmpi(kind,'usual')
            L = repmat(-1,n,n);
        else
            error('Incorrect value of fourth argument');
        end
        %Recalculate diagonal
        L = L - diag(sum(L));        
    else
        if isscalar(kind)
            %Advanced supervised PCA
            L = prepareAdvanced(labels, kind);
            %Recalculate diagonal
            L = L - diag(sum(L));        
        else
            %Must be a matrix
            [a,b] = size(kind);
            if ~(isnumeric(kind) && ismatrix(kind) && a==b && a==n)
                error('Incorrect value of fourth argument');
            end
            L = kind;
        end
    end
    
    %Calculate transformed covariance matrix
    L = data' * L * data;
    %Request calculations from eig
    [V, D] = eig(L);
    D = diag(D);
    [D, ind] = sort(D, 'descend');
    D = diag(D(1:nComp));
    V = V(:, ind);
    V = V(:, 1:nComp);
end

function L = prepareSuper(labels)
    L = bsxfun(@minus,labels,labels');
    L(L~=0) = -1;
end

function L = prepareNorm(data)
    %Calculate distances between points
    x = sum(data.^2,2);
    L = sqrt(2*(bsxfun(@plus,x,x')-(data*data')));
end

function L = prepareAdvanced(labels, alpha)
    %Different elements
    L = bsxfun(@minus,labels,labels');
    L(L~=0) = -2/sum(sum(L~=0));
    %Each class separately
    lab = unique(labels);
    K = length(lab);
    for k=1:K
        %Number of points in class
        ind1 = labels==lab(k);
        ind = find(ind1);
        N = sum(ind1);
        %Change nothing for class with one element
        if N>1
            L(ind,ind) = alpha*2/(K*N*(N-1));
        end
    end
end
