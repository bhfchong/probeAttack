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
function [atkLK, proLK, remBudLK, fValLK, timeLK] = genLKGreedy(A,U,C,P,b)
tic;
N = length(A);
UPerC = U./C;
remBudLK = b;
proLK = zeros(1,N);
visible = [1 zeros(1,N-1)];

while remBudLK > sum(C.*visible) && sum(visible) < N % Can afford to probe more and there are nodes left to probe
    binVect = proLK+2*visible;
    probeAble = find(binVect==2);
    proVals = P(probeAble);
    [minP,pInd] = min(proVals);
    if remBudLK > sum(C.*visible) + minP
        proThis = probeAble(pInd); % A visible, unprobed node.
        proLK(proThis) = 1;
        visible(A(proThis,:)==1) = 1;
        remBudLK = remBudLK - minP;
    else
        break;
    end
end

[~,atkOrder] = sort(UPerC.*visible,'descend');
cumuOrderCosts = cumsum(C(atkOrder));
lastOrder = find(cumuOrderCosts<=remBudLK,1,'last');
atkLK = sort(atkOrder(1:min(end,lastOrder)));
remBudLK = remBudLK - sum(C(atkLK));
fValLK = sum(U(atkLK));
proLK = find(proLK);
timeLK=toc;
sum(visible)
end