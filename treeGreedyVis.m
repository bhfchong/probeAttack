%% Assumes visibiliy of tree. Greedily attacks nodes of highest utility.
%  Breaks ties by cheapest cost
% Inputs:
%   parents: 1xN vector of parent-pointers; describes a tree
%   U: 1xN vector of attack utilities
%   C: 1xN vector of attack costs
%   b: scalar total probe and attack budget
% Outputs:
%   atkGrV: vector of indices of attacked nodes
%   proGrV: vector of indices of probed nodes
%   fValGrV: solution value
%   timeGrV: time taken to run alg

function [atkGrV, proGrV, remBudGrV, fValGrV, timeGrV] = treeGreedyVis( parents,C,U,b )

tic;
N = length(parents);
Uori = U;
atkGrV = zeros(1,N);
proGrV = zeros(1,N);
proGrV(1) = 1; % Probe the root;
remBudGrV = b-1;
paths = zeros(N); % paths(i,j) = 1 means j is on the path between root and i, and is unprobed
for nod = 1:N
    paths(nod,recurPar(parents,[],nod)) = 1;
end

for lookAt = 1:N    
    % Determine cost to attack and probe all unprobed parents
    totCosts = sum(paths,2)' + C;
    
    affordable = totCosts <= remBudGrV;
    if sum(affordable) == 0 % Can't afford anything, done.
        break;
    end
    uAff = U.*affordable;
    [uAffSorted,uInds] = sort(uAff,'descend');
    allBestU = uInds(uAffSorted == uAffSorted(1)); % Indices of affordable nodes of best utility
    [minCost,minInd] = min(totCosts(allBestU));
    attackThis = allBestU(minInd);
    
    proThese = paths(attackThis,:)==1;
    paths(:,proThese)=0; % Remove the need to probe these in future loop iterations
    proGrV(proThese)=1;
    
    U(attackThis) = 0;
    atkGrV(attackThis) = 1;
    
    remBudGrV = remBudGrV - minCost;
end

atkGrV = find(atkGrV);
proGrV = find(proGrV);
fValGrV = sum(Uori(atkGrV));
timeGrV = toc;
end


% Recursively finds all path to root node
function [path] = recurPar(parents,path,thisN)

thisPar = parents(thisN);
if thisPar > 1
    path = [thisPar recurPar(parents,path,thisPar)];
end

end




