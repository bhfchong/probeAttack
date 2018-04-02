%% Runs the default, 'greedy' strategy on a tree, sorting first on probe cost, calculating shit
% Inputs:
%   parents: 1xN vector of parent-pointers; describes a tree
%   U: 1xN vector of attack utilities
%   C: 1xN vector of attack costs
%   b: scalar total probe and attack budget
% Outputs:
%   atkGr: vector of indices of attacked nodes
%   proGr: vector of indices of probed nodes
%   fValGr: solution value
%   timeGr: time taken to run alg
function [atkLKPR, proLKPR, remBudLKPR, fValLKPR, timeLKPR] = genLKPRGreedy(A,U,C,P,b)
tic;
N = length(A);
UPerC = U./C;
remBudLKPR = b;
proLKPR = zeros(1,N);
visible = [1 zeros(1,N-1)];
degPro = zeros(N,2); % pairs of probe cost and degree
dPCount = 1;
betas = [0 1];

while remBudLKPR > sum(C.*visible) && sum(visible) < N % Can afford to probe more and there are nodes left to probe
    binVect = proLKPR+2*visible;
    probeAble = find(binVect==2);
    proVals = P(probeAble);
    
    expDegs = proVals*betas(2) + betas(1); % expected degree of a node based on probe value and regression
    visA = zeros(N);
    visNods = find(visible);
    numVis = length(visNods);
    for n1 = 1:numVis
        for n2 = n1+1:numVis
            visA(visNods(n1),visNods(n2)) = 1;
            visA(visNods(n2),visNods(n1)) = 1;
        end
    end
    visDegs = sum(visA.*A);
    expNewDegs = expDegs - visDegs(probeAble);
    [maxNewDegs,~] = max(expNewDegs);
    nodsWMaxNewDegs = probeAble(expNewDegs==maxNewDegs);
    [minP,pInd] = min(P(nodsWMaxNewDegs));
    proThis = nodsWMaxNewDegs(pInd); % A visible, unprobed node.
    pCost = minP;
    
%     [maxP,pInd] = max(proVals);
    if remBudLKPR > sum(C.*visible) + minP
        proLKPR(proThis) = 1;
        visible(A(proThis,:)==1) = 1;
        remBudLKPR = remBudLKPR - minP;
        
        % linear regression: x = probe cost, y = degree
        degPro(dPCount,:) = [pCost sum(A(proThis,:))];
        betas = [ones(dPCount,1),degPro(1:dPCount,1)]\degPro(1:dPCount,2);
        
    else
        break;
    end
end

[~,atkOrder] = sort(UPerC.*visible,'descend');
cumuOrderCosts = cumsum(C(atkOrder));
lastOrder = find(cumuOrderCosts<=remBudLKPR,1,'last');
atkLKPR = sort(atkOrder(1:min(end,lastOrder)));
remBudLKPR = remBudLKPR - sum(C(atkLKPR));
fValLKPR = sum(U(atkLKPR));
proLKPR = find(proLKPR);
timeLKPR=toc;
sum(visible)
end