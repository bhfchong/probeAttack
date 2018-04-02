%% Assumes visibiliy of tree. Greedily attacks nodes of highest utility/cost
%  Breaks ties by probing most unprobed nodes
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

function [atkGrV, proGrV, remBudGrV, fValGrV, timeGrV] = treeGreedyVis2( parents,U,C,P,b )
tic;
N = length(parents);
Uori = U;
atkGrV = zeros(1,N);
proGrV = zeros(1,N);
proGrV(1) = 1; % Probe the root;
remBudGrV = b-P(1);
paths = zeros(N); % paths(i,j) = 1 means j is on the path between root and i, and is unprobed
for nod = 1:N
    paths(nod,recurPar(parents,[],nod)) = 1;
end
repP = repmat(P,[N,1]);

for lookAt = 1:N    
    % Determine cost to attack and probe all unprobed parents
    pathCosts = sum(paths.*repP,2)';
    totCosts = pathCosts + C;
    
    affordable = totCosts <= remBudGrV;
    if sum(affordable) == 0 % Can't afford anything, done.
        break;
    end
    UOverC = U./totCosts.*affordable;
    [UOverCSorted,uInds] = sort(UOverC,'descend');
    allBestU = uInds(UOverCSorted == UOverCSorted(1)); % Indices of affordable nodes of best utility/cost
    [~,maxInd] = max(pathCosts(allBestU));
    attackThis = allBestU(maxInd);
    
    proThese = paths(attackThis,:)==1;
    paths(:,proThese)=0; % Remove the need to probe these in future loop iterations
    proGrV(proThese)=1;
    
    U(attackThis) = 0;
    atkGrV(attackThis) = 1;
    
    remBudGrV = remBudGrV - totCosts(attackThis);
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




