%% Assumes visibiliy of tree. Greedily attacks nodes of highest utility.
%  Breaks ties by cheapest cost
% Inputs:
%   parents: 1xN vector of parent-pointers; describes a tree
%   U: 1xN vector of attack utilities
%   C: 1xN vector of attack costs
%   b: scalar total probe and attack budget%% Assumes visibiliy of tree. Greedily attacks nodes of highest utility.
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

function [atkFK, proFK, remBudFK, fValFK, timeFK] = genFKGreedy(A,C,U,P,b,rt)

tic;
if nargin <= 5
    rt = 1;
end

N = length(A);
Uori = U;
atkFK = zeros(1,N);
proFK = zeros(1,N);
proFK(1) = 1;
remBudFK = b;

for lookAt = 1:N
    if sum(U) == 0
        break;
    end
    
    [sPaths,pCosts] = dijkP(A,P,rt); % parent-map and costs of shortest paths from each node
    
    totCosts = pCosts + C;
    totCosts = max(1,totCosts);
    affordable = totCosts <= remBudFK; % 1xN binary vector
    if sum(affordable) == 0 % Can't afford anything, done.
        break;
    end
    
    uAff = U./totCosts.*affordable;
    [uAffSorted,uInds] = sort(uAff,'descend');
    allBestU = uInds(uAffSorted == uAffSorted(1)); % Indices of affordable nodes of best utility
    [minCost,minInd] = min(totCosts(allBestU));
    attackThis = allBestU(minInd);
    
    proThese = recurPar(sPaths,[],attackThis,rt);
    P(proThese)=0; % Remove the cost of probing these in future loop iterations
    proFK(proThese)=1;
    
    U(attackThis) = 0;
    atkFK(attackThis) = 1;
    remBudFK = remBudFK - minCost;
end

atkFK = find(atkFK);
proFK = find(proFK);
fValFK = sum(Uori(atkFK));
timeFK = toc;
end


% Outputs path from thisN to rt, without nodes thisN and rt.
function [path] = recurPar(parents,path,thisN,rt)
if thisN ~= rt
    thisPar = parents(thisN);
    path = [thisPar recurPar(parents,path,thisPar,rt)];
end

end

