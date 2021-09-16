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