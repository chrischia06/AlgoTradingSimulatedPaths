function R = chol_insert(R, x, X, delta)
%CHOLINSERT Fast update of Cholesky factorization of X'*X.
%   CHOLINSERT returns the Cholesky factorization of [X x]'*[X x] given a
%   Cholesky factorization R of X'*X.
%
%   R = CHOLINSERT(R, x, X) returns a matrix corresponding to R =
%   chol([X x]'*[X x]), the Cholesky factorization of X'*X where variable x
%   has been added to X. R is the current upper triangular matrix to be
%   updated, x is a column vector representing the variable to be added and
%   X is the data matrix containing the currently active variables (not
%   including x).
%
%   R = CHOLINSERT(R, x, X, delta) returns a matrix corresponding to R =
%   chol([X x]'*[X x] + delta*I), the Cholesky factorization of X'*X +
%   delta*I where variable x has been added to X. See ELASTICNET [2] for
%   uses of this option.
%
%   This function is an auxiliary part of SpaSM, a Matlab toolbox for
%   sparse modeling and analysis.
%
%  See also CHOLDELETE, ELASTICNET.
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

if nargin < 4
  delta = 0;
end

% diagonal element k in X'X (or X'X + delta*I) matrix
diag_k = x'*x + delta;
if isempty(R)
  R = sqrt(diag_k); % return resulting 1x1 matrix (scalar)
else
  col_k = x'*X; % elements of column k in X'X matrix
  R_k = R'\col_k'; % R'R_k = (X'X)_k, solve for R_k
  % norm(x'x) = norm(R'*R), find last element by exclusion
  R_kk = sqrt(diag_k - R_k'*R_k);
  R = [R R_k; [zeros(1,size(R,2)) R_kk]]; % update R
end
