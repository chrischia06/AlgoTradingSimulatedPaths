%% TEST
% Compare up- and downdate algorithms for the Cholesky factorization with
% the corresponding Cholesky decompositions
%
%
%This file is part of the SpaSM Matlab toolbox.
%
%    SpaSM is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SpaSM is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

clear; close all; clc;

%% Updates
X1 = rand(6,4);
x1 = rand(6,1);
R1_0 = chol(X1'*X1);
R1_1 = chol_insert(R1_0, x1, X1);
R1_true = chol([X1 x1]'*[X1 x1]);
assert(norm(R1_1 - R1_true) < 1e-12)

%% Downdates
X2 = rand(4,6);
x2 = rand(4,1);
lambda = 1;
R2_0 = chol((X2'*X2 + lambda*eye(6)));
R2_1 = chol_insert(R2_0, x2, X2, lambda);
R2_true = chol([X2 x2]'*[X2 x2] + lambda*eye(7));
assert(norm(R2_1 - R2_true) < 1e-12)
