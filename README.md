# SupervisedPCA
Classification supervised PCA in accordance with Yehuda Koren and Liran Carmel

Yehuda Koren and Liran Carmel introduced supervised PCA for classification problem in their paper

Koren, Y., & Carmel, L. (2004). Robust linear dimensionality reduction. 
IEEE transactions on visualization and computer graphics, 10(4), 459-470.

Moreover they sugests three versions of PCA: normalized, supervised and normalized and supervised 
simulateneously. Proposed MatLab function SupervisedPCA implements all these models. Standard PCA 
can be calculated by this function as well. Also function allow to apply user defined Laplacian
matrix.
<pre>
Description of function
 SupervisedPCA calculates supervised PCA with respect to [1].
    [ V, D ] = SupervisedPCA( data, labels, nComp, kind ) return n-by-nComp
                matrix V with PCs as columns and diagonal nComp-by-nComp
                matrix D with fraction of explained modified variance for
                each component.
    data is n-by-m matrix of data (covariance matrix is unacceptable). Data
        MUST be centred before.
    labels is vector with n elements. The same labels corresponds to points
        of the same class.
    nComp is number of required component.
    kind is kind of calculated PCA. Acceptable values:
        'norm' is normalized PCA. Elements of Laplacian matrix are:
                L(i,j) = -1/distance(data(:,i)-data(:,j)) for i~=j
                L(i,i) = -sum(L(:,i))+L(i,i);
        'super' is supervised PCA. Elements of Laplacian matrix are:
                L(i,j) = 0 if labels(i)==labels(j),i~=j;
                L(i,j) = -1 if labels(i)~=labels(j),i~=j;
                L(i,i) = -sum(L(:,i))+L(i,i);
        'supernorm' is supervised normalized PCA. Elements of Laplacian
            matrix are: 
                L(i,j) = 0 if labels(i)==labels(j),i~=j;
                L(i,j) = -1/distance(data(:,i)-data(:,j)) 
                    if labels(i)~=labels(j),i~=j;
                L(i,i) = -sum(L(:,i))+L(i,i);
        'usual' corresponds to usual PCA. Elements of Laplacian matrix are:
                L(i,j) = -1 if i~=j;
                L(i,i) = -sum(L(:,i))+L(i,i);
        matrix. In this case kinds must be numerical n-by-n Laplacian
                matrix. 
 
 Reference
 1. Koren, Yehuda, and Liran Carmel. "Robust linear dimensionality
    reduction." Visualization and Computer Graphics, IEEE Transactions on
    10.4 (2004): 459-470.
</pre>