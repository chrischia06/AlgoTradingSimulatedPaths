function [X mu] = center(X)
%CENTER Center the columns (variables) of a data matrix to zero mean.
%
%   X = CENTER(X) centers the observations of a data matrix such that each
%   variable (column) has zero mean.
%
%   [X MU] = CENTER(X) also returns a vector MU of mean values for each
%   variable. 
%
%   This function is an auxiliary part of SpaSM, a matlab toolbox for
%   sparse modeling and analysis.
%
%  See also NORMALIZE.
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

n = size(X,1);
mu = mean(X);
X = X - ones(n,1)*mu;
