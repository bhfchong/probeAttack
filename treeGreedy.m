%% Runs the default, 'greedy' strategy on a tree
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
function [atkGr, proGr, remBudGr, fValGr, timeGr] = treeGreedy(parents,U,C,P,b)
tic;
N = length(parents);
UPerC = U./C;
remBudGr = b;
proGr = zeros(1,N);
visible = [1 zeros(1,N-1)];

while remBudGr > sum(C.*visible) && sum(visible) < N % Can afford to probe more and there are nodes left to probe
    binVect = proGr+2*visible;
    probeAble = find(binVect==2);
    proVals = P(probeAble);
    [minP,pInd] = min(proVals);
    if remBudGr > sum(C.*visible) + minP
        proThis = probeAble(pInd); % A visible, unprobed node.
        proGr(proThis) = 1;
        visible(parents==proThis) = 1;
        remBudGr = remBudGr - minP;
    else
        break;
    end
end

[~,atkOrder] = sort(UPerC.*visible,'descend');
cumuOrderCosts = cumsum(C(atkOrder));
lastOrder = find(cumuOrderCosts<=remBudGr,1,'last');
atkGr = sort(atkOrder(1:min(end,lastOrder)));
remBudGr = remBudGr - sum(C(atkGr));
fValGr = sum(U(atkGr));
proGr = find(proGr);
timeGr=toc;
end