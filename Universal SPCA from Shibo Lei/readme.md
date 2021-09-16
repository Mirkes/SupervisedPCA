This folder contains Universal SPCA functions developed by Shibo Lei for master thesis under supervison of Dr. Evgeny Mirkes.
Please refer as:


Presented functions:

## BigdataSPCA

<pre>
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
</pre>

## ClassSPCA

<pre>
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
</pre>
