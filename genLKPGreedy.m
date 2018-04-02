%% Runs the default, 'greedy' strategy on a tree, sorting first on probe cost
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
function [atkLKP, proLKP, remBudLKP, fValLKP, timeLKP] = genLKPGreedy(A,U,C,P,b)
tic;
N = length(A);
UPerC = U./C;
remBudLKP = b;
proLKP = zeros(1,N);
visible = [1 zeros(1,N-1)];

while remBudLKP > sum(C.*visible) && sum(visible) < N % Can afford to probe more and there are nodes left to probe
    binVect = proLKP+2*visible;
    probeAble = find(binVect==2);
    proVals = P(probeAble);
    [maxP,pInd] = max(proVals);
    if remBudLKP > sum(C.*visible) + maxP
        proThis = probeAble(pInd); % A visible, unprobed node.
        proLKP(proThis) = 1;
        visible(A(proThis,:)==1) = 1;
        remBudLKP = remBudLKP - maxP;
    else
        break;
    end
end

[~,atkOrder] = sort(UPerC.*visible,'descend');
cumuOrderCosts = cumsum(C(atkOrder));
lastOrder = find(cumuOrderCosts<=remBudLKP,1,'last');
atkLKP = sort(atkOrder(1:min(end,lastOrder)));
remBudLKP = remBudLKP - sum(C(atkLKP));
fValLKP = sum(U(atkLKP));
proLKP = find(proLKP);
timeLKP=toc;
sum(visible)
end