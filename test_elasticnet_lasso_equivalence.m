%% TEST
% Assert that Elastic Net models are equivalent to those obtained by
% running LASSO with Elastic Net-style augmented data matrices
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

delta = 10;

X = normalize(rand(n, p));
y = center(rand(n,1));

Xtilde = [X; sqrt(delta)*eye(p)];
ytilde = [y; zeros(p,1)];

beta_en = larsen(X, y, delta, 0, [], false, false);
beta_lasso = lasso(Xtilde, ytilde, 0, false, false);
assert(norm(beta_en - beta_lasso) < 1e-12);
