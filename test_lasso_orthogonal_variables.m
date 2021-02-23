%% TEST
% Assert that LASSO gives expected results when run with orthogonal
% predictors. 
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
p = 10;
X = gallery('orthog',n,5);
X = X(:,2:p+1);
y = center((1:100)');

b_lasso = lasso(X, y);
b_ols = X'*y;

% First compare using theoretical value of lambda/2 at each breakpoint.
% Call this value gamma
gamma = [sort(abs(b_ols), 'descend'); 0];
b_lasso2 = zeros(size(b_lasso));
for i = 1:length(gamma)
  b_lasso2(:,i) = sign(b_ols).*max(abs(b_ols) - gamma(i),0);
end

assert(norm(b_lasso - b_lasso2) < 1e-12)

% Then compare for some arbitrary value of lambda, the value of lambda is
% given by the lasso procedure
t = 150; % constraint on the L1 norm of beta
[b_lasso info] = lasso(X, y, t, false);
b_lasso2 = sign(b_ols).*max(abs(b_ols) - info.lambda/2, 0);

assert(norm(b_lasso - b_lasso2) < 1e-12)
