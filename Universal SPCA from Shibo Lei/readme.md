This folder contains Universal SPCA functions developed by Shibo Lei for master thesis under supervison of Dr. Evgeny Mirkes.
Please refer as:

Lei, Shibo and Mirkes, Evgeny. Universal supervised PCA for regression and classification. Available online at https://github.com/Mirkes/SupervisedPCA/tree/master/Universal%20SPCA%20from%20Shibo%20Lei

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

## UnivSPCA

<pre>
function [ V, D ] = UnivSPCA( data, nComp, W )
% Return n-by-nComp matrix V with PCs as columns and diagonal
% nComp-by-nComp matrix D with eigenvalues corresponding to PCs.
% This function is faster than BigdataSPCA but cannot work with big
% datasets.
%
%   data is a n-by-m matrix of data.
%   nComp is the number of required component.
%   W is a n-by-n weight matrix.
</pre>

## MyGetW_for_regression

<pre>
function W = MyGetW_for_regression( target, exponent, b1, e1, b2, e2 )
% MyGetW_for_regression calculates fragment od weights matrix W fro
% regression problem. Fragment contains rows b1:e1 and columns b2:e2.
% target contains values of target attribute and exponent defines power of
% difference of target value fro two points to calculate weight of this
% pair.
% To call BigdataSPCA with this function you should define anonymous
% function as in example below
%    GetW = @(b1, e1, b2, e2)MyGetW_for_regression( target,...
%       exponent, b1, e1, b2, e2 );
%   [V{i,j}, D ] = BigdataSPCA( data, i, GetW );
% where data, i, target and exponent are previously defined variables. 
%
% More examples can be found in scripts Regression1, Regression2 and
% Regression3 in subfolder tests

W = abs(target(b1:e1) - target(b2:e2)') .^ exponent;

end
</pre>
