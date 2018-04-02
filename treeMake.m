function [parents,pois] = treeMake(brFact, N)
parents = zeros(1,N); 
% pois = max(1,poissrnd(brFact,1,N)); poisInd = 1;
pois = 1+poissrnd(brFact-1,1,N); poisInd = 1;
numNodes = 1;
depth = 1;
depNods = 1; % depNods(i) is number of nodes at depth 1. Root is 0.

% Recursion seems like a pain in the ass wrt indexing
while numNodes < N
    numThisDepth = depNods(depth);
    lastNode = sum(depNods(1:depth-1));
    % For each node at this depth, generate a new set of children
    for nod = 1:numThisDepth
        numKids = min(N-numNodes,pois(poisInd)); poisInd = min(N,poisInd + 1);
        thisNode = lastNode + nod;
        parents(numNodes+1:numNodes+numKids) = thisNode;
        numNodes = numNodes + numKids;
        if numNodes == N
            break;
        end
    end
    depth = depth+1;
    depNods = [depNods, numNodes-lastNode];
end
end

