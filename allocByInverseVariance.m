function pwgt= allocByInverseVariance(assetCovar)
% allocByInverseVariance performs simple inverse-variance allocation.

% Copyright 2019 The MathWorks, Inc.

pwgt = 1./diag(assetCovar);
pwgt = pwgt/sum(pwgt);
end