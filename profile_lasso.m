%% PROFILE
% Profile script for LASSO
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

n = 100000; p = 100; 
mu = zeros(1, p);
C = 0.5*ones(p) + (1 -0.5)*eye(p);
X = mvnrnd(mu, C, n);
y = center(rand(n,1));

profile on
lasso(X, y);
profile viewer

pause

n = 100; p = 10000; 
mu = zeros(1, p);
C = 0.5*ones(p) + (1 -0.5)*eye(p);
X = mvnrnd(mu, C, n);
y = center(rand(n,1));

profile on
lasso(X, y);
profile viewer
