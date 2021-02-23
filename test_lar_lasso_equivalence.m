%% TEST
% Assert that LAR and LASSO are equal in cases where no variables are
% dropped
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

X = gallery('orthog',100,5);
X = X(:,2:6);
y = center(rand(100,1));

b_lar = lar(X,y);
b_lasso = lasso(X, y);

assert(norm(b_lar - b_lasso) < 1e-12)
