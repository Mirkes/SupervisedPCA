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
