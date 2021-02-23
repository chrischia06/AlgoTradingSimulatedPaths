%% TEST
% Assert that Elastic Net gives expected results when run with orthogonal
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

X = gallery('orthog',100,5);
X = X(:,2:6);
y = center(1:100)';
delta = 10;

[b_en info] = elasticnet(X, y, delta);

b_ols = X'*y;
b_en2 = zeros(size(b_en));
for i = 1:info.steps+1
  b_en2(:,i) = sign(b_ols).*max(abs(b_ols) - info.lambda(i)/2,0)/(1 + delta);
end
b_en2 = b_en2*(1 + delta); % to non-naïve solution

assert(norm(b_en - b_en2) < 1e-12)
