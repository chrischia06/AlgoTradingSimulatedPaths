%% TEST
% Assert that the full SPCA model and PCA are equal
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
Z = rand(p);
C = Z'*Z;

X = center(mvnrnd(zeros(1,p), C, n));

K = p; % all possible components
delta = 5; % any value will do
stop = 0; % no L1 constraint
B = spca(X, [], K, delta, stop);

[U D V] = svd(X, 'econ');

assert(norm(abs(V) - abs(B)) < 1e-12)
