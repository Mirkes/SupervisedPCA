# SupervisedPCA
Classification supervised PCA inspired by Yehuda Koren and Liran Carmel. 

Yehuda Koren and Liran Carmel introduced supervised PCA for classification problem in their paper

Koren, Y., & Carmel, L. (2004). Robust linear dimensionality reduction. 
IEEE transactions on visualization and computer graphics, 10(4), 459-470.

Moreover they sugests three versions of PCA: normalized, supervised and normalized and supervised 
simulateneously. Proposed MatLab function SupervisedPCA implements all these models. Standard PCA 
can be calculated by this function as well. Also function allow to apply user defined Laplacian
matrix.

One more significantly more powerful method of Advinced supervised PCA is implemented as well. Meaning and usage of parameter alpha of this algorithm is described in [wiki](https://github.com/Mirkes/SupervisedPCA/wiki)

Read [wiki](https://github.com/Mirkes/SupervisedPCA/wiki) of this repository for much more detailed information on the algorithm.

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
        number. Specified number corresponds to parameter alpha of advanced
            supervised PCA. Elements of Laplacian matrix are:
                L(i,j) = 1/Number of pairs with points in different
                    classes if labels(i)~=labels(j),i~=j;
                L(i,j) = alpha/Nu(Nu-1) where Nu is number of points in class
                    label(i) if labels(i)==labels(j),i~=j;
                L(i,i) = -sum(L(:,i))+L(i,i);
        matrix. In this case kinds must be numerical n-by-n Laplacian
                matrix. 
 
 References
 1. Gorban, Alexander N., Zinovyev, Andrei Y. “Principal Graphs and Manifolds”, 
    Chapter 2 in: Handbook of Research on Machine Learning Applications and Trends: 
    Algorithms, Methods, and Techniques, Emilio Soria Olivas et al. (eds), 
    IGI Global, Hershey, PA, USA, 2009, pp. 28-59.
 2. Zinovyev, Andrei Y. "Visualisation of multidimensional data" Krasnoyarsk: KGTU,
    p. 180 (2000) (In Russian).
 3. Koren, Yehuda, and Liran Carmel. "Robust linear dimensionality
    reduction." Visualization and Computer Graphics, IEEE Transactions on
    10.4 (2004): 459-470.
</pre>

## Acknowledgements

Supported by the University of Leicester (UK), the Ministry of Education and Science of the Russian Federation, project â„– 14.Y26.31.0022
