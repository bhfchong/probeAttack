clear; clc;
N=1000;
Bs = 1000:200:3000;
numBs = length(Bs);
nReps = 30;
maxUtil = 10;
maxCost = 10;
maxP = 10;
fValLKs = zeros(1,numBs);
fValFKs = zeros(1,numBs);
fValUBs = zeros(1,numBs);
fValLBs = zeros(1,numBs);
len = numBs;
varLKs = zeros(1,len);
varFKs = zeros(1,len);
varUBs = zeros(1,len);
varLBs = zeros(1,len);
rt = 1;
WS_k = 5;
WS_b = 0.2;

for thisB = 1:numBs
    b = Bs(thisB);
    fValLK = zeros(1,nReps);
    fValFK = zeros(1,nReps);
    fValUB = zeros(1,nReps);
    fValLB = zeros(1,nReps);
    parfor rep = 1:nReps
        [A] = makeWS(N,WS_k,WS_b);
        [cBet] = btwS(A);
        cBet = cBet/max(cBet);
        P = ceil(maxP*cBet);
        U = randi(maxUtil,[1,N]);
        C = randi(maxCost,[1,N]);
        [~,~,~,fValLK(rep),~] = genLKGreedy(A,U,C,P,b);
        [~,~,~,fValFK(rep),~] = genFKGreedy(A,C,U,P,b,rt);
        
        W = b-1;
        vs = U;
        ws = C;
        [minBag] = knapsack(ws,vs,W);
        fValUB(rep) = minBag(end,end);
        
        [~,dist] = dijkP(A,P,rt);
        ws2 = ws + dist;
        [minBag] = knapsack(ws2,vs,W);
        fValLB(rep) = minBag(end,end);
    end
    
    fValLKs(thisB) = mean(fValLK);
    fValFKs(thisB) = mean(fValFK);
    fValLBs(thisB) = mean(fValLB);
    fValUBs(thisB) = mean(fValUB);
    varLKs(thisB) = std(fValLK);
    varFKs(thisB) = std(fValFK);
    varUBs(thisB) = std(fValUB);
    varLBs(thisB) = std(fValLB);
    save('GenChangeB');
end






