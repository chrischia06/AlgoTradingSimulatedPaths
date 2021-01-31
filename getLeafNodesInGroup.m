function idxInGroup = getLeafNodesInGroup(groupNodeId, link)
% getLeafNodesInGroup finds all leaf nodes for a given group node id
% in a linkage matrix.

% Copyright 2019 The MathWorks, Inc.

N= size(link, 1)+1;
if groupNodeId>N
    gNodeIds = link(groupNodeId-N, 1:2);
    idxInGroup = [getLeafNodesInGroup(gNodeIds(1), link), ...
        getLeafNodesInGroup(gNodeIds(2), link)];
else
    idxInGroup = groupNodeId;
end
end