function [ V, D ] = SupervisedPCA( data, labels, nComp, kind )
%SupervisedPCA calculates supervised PCA with respect to [1].
%   [ V, D ] = SupervisedPCA( data, labels, nComp, kind ) return n-by-nComp
%               matrix V with PCs as columns and diagonal nComp-by-nComp
%               matrix D with fraction of explained modified variance for
%               each component.
%   data is n-by-m matrix of data (covariance matrix is unacceptable). Data
%       MUST be centred before.
%   labels is vector with n elements. The same labels corresponds to points
%       of the same class.
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
%       matrix. In this case kinds must be numerical n-by-n Laplacian
%               matrix. 
%
%Reference
%1. Koren, Yehuda, and Liran Carmel. "Robust linear dimensionality
%   reduction." Visualization and Computer Graphics, IEEE Transactions on
%   10.4 (2004): 459-470.

    %Get sizes of data
    n = size(data, 1);
    
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
        %Must be a matrix
        [a,b] = size(kind);
        if ~(isnumeric(kind) && ismatrix(kind) && a==b && a==n)
            error('Incorrect value of fourth argument');
        end
        L = kind;
    end
    
    %Calculate transformed covariance matrix
    L = data'*L*data;
    %Sum of variances
    S = sum(diag(L));
    %Request calculations from eigs
    [ V, D ] = eigs(L, nComp);
    D = D./S;
end

function L = prepareSuper(labels)
    L = bsxfun(@minus,labels,labels');
    L(L~=0) = -1;
end

function L = prepareNorm(data)
    %Calculate distances between points
    x = sum(data.^2,2);
    L = sqrt(bsxfun(@plus,x,x')-2*(data*data'));
end