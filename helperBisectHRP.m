function wgt = helperBisectHRP(assetCovar, sortedIdx)
% helperBisectHRP starts with the sorted list from the hierarchical
% clustering tree, and recursively runs bisect allocation on each
% sublist. 

% Copyright 2019 The MathWorks, Inc.

len = numel(sortedIdx);  % can be less than the number of assets
nAssets = size(assetCovar, 1);
wgt = ones(nAssets, 1);

% base case
if len <= 2
    wgt(sortedIdx) = allocByInverseVariance(assetCovar(sortedIdx, sortedIdx));
    return;
end

% below demonstrates the bottom-up and top-down approach
% split the list into two:
mid = floor(len/2);
left = sortedIdx(1:mid);
right = sortedIdx(mid+1:len);

% 1) bottom up to find the variance of the two groups
wgtLeft = allocByInverseVariance(assetCovar(left, left));
wgtRight = allocByInverseVariance(assetCovar(right, right));

varLeft = wgtLeft'*assetCovar(left, left)*wgtLeft;
varRight = wgtRight'*assetCovar(right, right)*wgtRight;

% 2) top down rescaling of asset weights in inverse proportion to the two groups' variances
alpha= 1-varLeft/(varLeft+varRight);
wgt(left) = alpha*wgt(left);
wgt(right) = (1-alpha)*wgt(right);

% recursively run this for the two sublists
wgt = wgt.*helperBisectHRP(assetCovar, left);
wgt = wgt.*helperBisectHRP(assetCovar, right);
end