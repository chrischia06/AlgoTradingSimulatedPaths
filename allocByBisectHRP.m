function wgt = allocByBisectHRP(assetCovar)
% allocByBisectHRP performs the bisect HRP asset allocation
% proposed in Lopez's paper.

% Copyright 2019 The MathWorks, Inc.

% 1) compute the distance matrix
cr = corrcov(assetCovar);
distCorr = ((1-cr)/2).^0.5;

% 2) compute the linkage
Y = pdist(distCorr); % distance information
link = linkage(Y, 'single');

% 3) perform quasi-diagonalization
sortedIdx = quasiDiagSort(link);

% 4) perform bisect allocation
wgt = helperBisectHRP(assetCovar, sortedIdx);
end

function sortedIdx = quasiDiagSort(link)
% quasiDiagSort orders the nodes according to the similarities
% specified by linkage matrix.

% Copyright 2019 The MathWorks, Inc.
numLeafNodes = size(link, 1) + 1;
rootGroupNodeId = 2*numLeafNodes-1;
sortedIdx = getLeafNodesInGroup(rootGroupNodeId, link);
end





