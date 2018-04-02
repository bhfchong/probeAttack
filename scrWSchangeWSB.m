clear; clc;
N=1000;
b = 1500;
nReps = 30;
maxUtil = 10;
maxCost = 10;
maxP = 10;
numWSBs = length(WS_bs);
fValLKs = zeros(1,numWSBs);
fValFKs = zeros(1,numWSBs);
fValUBs = zeros(1,numWSBs);
fValLBs = zeros(1,numWSBs);
len = numWSBs;
varLKs = zeros(1,len);
varFKs = zeros(1,len);
varUBs = zeros(1,len);
varLBs = zeros(1,len);
rt = 1;
WS_k = 5;
WS_bs = 0:0.05:0.5;

for thisWS_b = 1:numWSBs
    WS_b = WS_bs(thisWS_b);
    fValLK = zeros(1,nReps);
    fValFK = zeros(1,nReps);
    fValUB = zeros(1,nReps);
    fValLB = zeros(1,nReps);
    parfor rep = 1:nReps
        [A] = makeWS(N,WS_k,WS_b);
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
    
    fValLKs(thisWS_b) = mean(fValLK);
    fValFKs(thisWS_b) = mean(fValFK);
    fValLBs(thisWS_b) = mean(fValLB);
    fValUBs(thisWS_b) = mean(fValUB);
    varLKs(thisWS_b) = std(fValLK);
    varFKs(thisWS_b) = std(fValFK);
    varUBs(thisWS_b) = std(fValUB);
    varLBs(thisWS_b) = std(fValLB);
    save('WSchangeWSB');
end






