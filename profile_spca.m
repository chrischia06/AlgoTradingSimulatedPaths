%% PROFILE
% Profile script for SPCA
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

n = 1000; p = 100; 
mu = zeros(1, p);
C = 0.5*ones(p) + (1-0.5)*eye(p);
X = mvnrnd(mu, C, n);
delta = 0.1;
K = 5;
stop = -10;

profile on
spca(X, [], K, delta, stop);
profile viewer

pause

n = 10; p = 1000; 
mu = zeros(1, p);
C = 0.5*ones(p) + (1-0.5)*eye(p);
X = mvnrnd(mu, C, n);
delta = 0.1;
K = 5;
stop = -100;

profile on
spca(X, [], K, delta, stop);
profile viewer
