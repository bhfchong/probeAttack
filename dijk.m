%% Dijkstra's algorithm on adjacency matrix A and distance matrix ADist, with paths to node rt.
% Inputs:
%   A: NxN binary adjacency matrix
%   ADist: NxN adjacency matrix with nonzero entries identical to A, except
%   that when a node has been probed, all its ones in that node's column
%   and row become 0.5.
% Outputs:
%   sPaths: 1xN vector that points to the last node visited along the
%   shortest path to each node
%   dist:   1xN vector of distances to root from each node.

function [sPaths,dist] = dijk(A,ADist,rt)

if nargin == 1
    rt = 1;
end
N = length(A);
maxDist = N*1000;
sPaths = zeros(1,N);
dist = maxDist*ones(1,N);
visited = zeros(1,N);

dist(rt) = 0;

while sum(visited) < N
    vDist = dist;
    vDist(visited == 1) = inf;
    [~,u] = min(vDist);
    visited(u) = 1;
    
    neibs = find(A(u,:));
    numNeibs = length(neibs);
    for neib = 1:numNeibs
        v = neibs(neib);
        tempD = dist(u) + ADist(u,v);
        if tempD < dist(v);
            dist(v) = tempD;
            sPaths(v) = u;
        end
    end
    
end


end


