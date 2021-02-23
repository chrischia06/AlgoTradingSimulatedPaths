function R = chol_delete(R,j)
%CHOLDELETE Fast downdate of Cholesky factorization of X'*X.
%   CHOLDELETE returns the Cholesky factorization of the Gram matrix X'*X
%   where the jth column of X has been removed.
%
%   R = CHOLDELETE(R, j) returns a matrix corresponding to R =
%   chol(X2'*X2), where X2 is equal to X with the jth column taken out and
%   R = chol(X'*X) is the Cholesky factorization of X'*X to be downdated.
%
%   This function is an auxiliary part of SpaSM, a matlab toolbox for
%   sparse modeling and analysis.
%
%  See also CHOLINSERT.
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

R(:,j) = []; % remove column j
n = size(R,2);
for k = j:n
  p = k:k+1;
  [G,R(p,k)] = planerot(R(p,k)); % remove extra element in column
  if k < n
    R(p,k+1:n) = G*R(p,k+1:n); % adjust rest of row
  end
end
R(end,:) = []; % remove zero'ed out row
