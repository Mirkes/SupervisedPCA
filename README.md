# SupervisedPCA
Classification supervised PCA in accordance with Yehuda Koren and Liran Carmel

Yehuda Koren and Liran Carmel introduced supervised PCA for classification problem in their paper

Koren, Y., & Carmel, L. (2004). Robust linear dimensionality reduction. 
IEEE transactions on visualization and computer graphics, 10(4), 459-470.

Moreover they sugests three versions of PCA: normalized, supervised and normalized and supervised 
simulateneously. Proposed MatLab function SupervisedPCA implements all these models. Standard PCA 
can be calculated by this function as well. Also function allow to apply user defined Laplacian
matrix.

Description of function
</br>SupervisedPCA calculates supervised PCA with respect to [1].
</br>   [ V, D ] = SupervisedPCA( data, labels, nComp, kind ) return n-by-nComp
</br>               matrix V with PCs as columns and diagonal nComp-by-nComp
</br>               matrix D with fraction of explained modified variance for
</br>               each component.
</br>   data is n-by-m matrix of data (covariance matrix is unacceptable). Data
</br>       MUST be centred before.
</br>   labels is vector with n elements. The same labels corresponds to points
</br>       of the same class.
</br>   nComp is number of required component.
</br>   kind is kind of calculated PCA. Acceptable values:
</br>       'norm' is normalized PCA. Elements of Laplacian matrix are:
</br>               L(i,j) = -1/distance(data(:,i)-data(:,j)) for i~=j
</br>               L(i,i) = -sum(L(:,i))+L(i,i);
</br>       'super' is supervised PCA. Elements of Laplacian matrix are:
</br>               L(i,j) = 0 if labels(i)==labels(j),i~=j;
</br>               L(i,j) = -1 if labels(i)~=labels(j),i~=j;
</br>               L(i,i) = -sum(L(:,i))+L(i,i);
</br>       'supernorm' is supervised normalized PCA. Elements of Laplacian
</br>           matrix are: 
</br>               L(i,j) = 0 if labels(i)==labels(j),i~=j;
</br>               L(i,j) = -1/distance(data(:,i)-data(:,j)) 
</br>                   if labels(i)~=labels(j),i~=j;
</br>               L(i,i) = -sum(L(:,i))+L(i,i);
</br>       'usual' corresponds to usual PCA. Elements of Laplacian matrix are:
</br>               L(i,j) = -1 if i~=j;
</br>               L(i,i) = -sum(L(:,i))+L(i,i);
</br>       matrix. In this case kinds must be numerical n-by-n Laplacian
</br>               matrix. 
</br>
</br>Reference
</br>1. Koren, Yehuda, and Liran Carmel. "Robust linear dimensionality
</br>   reduction." Visualization and Computer Graphics, IEEE Transactions on
</br>   10.4 (2004): 459-470.
