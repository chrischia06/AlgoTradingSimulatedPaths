%% TEST
% Assert that the full Elastic Net model and Ridge Regression are equal
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

n = 100;
p = 25;

X = normalize(rand(n, p));
y = center(rand(n,1));

beta_en = larsen(X, y, 1e-9, 0, [], false, false);
beta_ridge = (X'*X + 1e-9*eye(p))\X'*y;
assert(norm(beta_en - beta_ridge) < 1e-12);

beta_en = larsen(X, y, 1e-2, 0, [], false, false);
beta_ridge = (X'*X + 1e-2*eye(p))\X'*y;
assert(norm(beta_en - beta_ridge) < 1e-12);

beta_en = larsen(X, y, 1e2, 0, [], false, false);
beta_ridge = (X'*X + 1e2*eye(p))\X'*y;
assert(norm(beta_en - beta_ridge) < 1e-12);

beta_en = larsen(X, y, 1e9, 0, [], false, false);
beta_ridge = (X'*X + 1e9*eye(p))\X'*y;
assert(norm(beta_en - beta_ridge) < 1e-12);
