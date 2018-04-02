%% Calculates single-sum betweenness of each node in a matrix
function [C] = btwS(A)

N = length(A);
nod = 1;
S = [];
P = cell(1,N);
sig = zeros(1,N); sig(nod) = 1;
d = -1*ones(1,N); d(nod) = 0;
Q = nod;
while ~isempty(Q)
    v = Q(end); Q(end) = [];% 1 is end of queue, end is front of queue
    S = [v S]; % 1 is top of stack, end is bottom of stack
    neibs = find(A(v,:));
    for neib = 1:length(neibs)
        thisNeib = neibs(neib);
        
        if d(thisNeib) < 0
            Q = [thisNeib, Q];
            d(thisNeib) = d(v) + 1;
        end
        
        if d(thisNeib) == d(v) + 1
            sig(thisNeib) = sig(thisNeib) + sig(v);
            thisP = P{thisNeib};
            thisP = [thisP v];
            P{thisNeib} = thisP;
        end
    end
end

% P{k} is set of parents of k on all shortest 1-k paths.
% paths{n} is the set of all shortest paths from 1 to n
paths = cell(1,N);
A2 = zeros(N);
for n = 1:N
    A2(P{n},n) = 1;
    paths{n} = cell(0);
end

maxDists = max(d);
distInds = find(d==1);
numDists = length(distInds);
for n1=1:numDists
    paths{distInds(n1)} = {[distInds(n1) 1]};
end
cMat = zeros(N); % cMat(i,j) is the number of times i appears in a shortest path from 1 to j.
if maxDists > 1
    for dist = 2:maxDists
        distInds = find(d==dist);
        numDists = length(distInds);
        for ind = 1:numDists
            thisNod = distInds(ind);
            pars = P{thisNod};
            numPars = length(pars);
            for par = 1:numPars
                thisPar = pars(par);
                parPaths = paths{thisPar};
                numParPaths = length(parPaths);
                for path = 1:numParPaths
                    newPath = [thisNod, parPaths{path}];
                    paths{thisNod} = [paths{thisNod}, newPath];
                    lenPath = length(newPath);
                    if lenPath > 2
                        for midInd = 2:lenPath-1
                            cMat(newPath(midInd),thisNod) = cMat(newPath(midInd),thisNod) + 1;
                        end
                    end
                end
            end
        end
    end
end
lens = cellfun('length',paths); lens(1) = 1;
C = zeros(1,N);
for n=2:N
    C(n) = sum(cMat(n,:)./lens);
end
end