%% TEST
% Assert that the full LAR model and OLS are equal
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

b_lar = lar(X,y);
b_ols = X\y;

assert(norm(b_lar(:,end) - b_ols) < 1e-12)

