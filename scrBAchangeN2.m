clear; clc;
Ns=100:200:2000;
b=3000;
numNs = length(Ns);
nReps = 30;
maxUtil = 10;
maxCost = 10;
maxP = 10;
fValLKs = zeros(1,numNs);
fValFKs = zeros(1,numNs);
fValUBs = zeros(1,numNs);
fValLBs = zeros(1,numNs);
len = numNs;
varLKs = zeros(1,len);
varFKs = zeros(1,len);
varUBs = zeros(1,len);
varLBs = zeros(1,len);
rt = 1;

for thisN = 1:numNs
    N = Ns(thisN);
    fValLK = zeros(1,nReps);
    fValFK = zeros(1,nReps);
    fValUB = zeros(1,nReps);
    fValLB = zeros(1,nReps);
    parfor rep = 1:nReps
        [A] = makeBA(N);
        U = randi(maxUtil,[1,N]);
        C = randi(maxCost,[1,N]);
        P = randi(maxP,[1,N]);
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
    
    fValLKs(thisN) = mean(fValLK);
    fValFKs(thisN) = mean(fValFK);
    fValLBs(thisN) = mean(fValLB);
    fValUBs(thisN) = mean(fValUB);
    varLKs(thisN) = std(fValLK);
    varFKs(thisN) = std(fValFK);
    varUBs(thisN) = std(fValUB);
    varLBs(thisN) = std(fValLB);
    save('BAchangeN');
end






