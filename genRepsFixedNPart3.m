clear;
N=1000;
edgeFrac = 0.05;
M=max(N-1,round(edgeFrac*N*(N-1)/2));
Bs = 2300:100:2400;
numBs = length(Bs);
nReps = 30;
maxUtil = 10;
maxCost = 10;
maxP = 10;
fValLKs4 = zeros(1,numBs);
fValFKs4 = zeros(1,numBs);
fValUBs4 = zeros(1,numBs);
fValLBs4 = zeros(1,numBs);
rt = 1;

for thisB = 1:numBs
    b = Bs(thisB);
    fValLK4 = zeros(1,nReps);
    fValFK4 = zeros(1,nReps);
    fValUB4 = zeros(1,nReps);
    fValLB4 = zeros(1,nReps);
    parfor rep = 1:nReps
        N
        rep
        [A] = genMake(N,M);
        U = randi(maxUtil,[1,N]);
        C = randi(maxCost,[1,N]);
        P = randi(maxP,[1,N]);
        [~,~,~,fValLK4(rep),~] = genLKGreedy(A,U,C,P,b);
        [~,~,~,fValFK4(rep),~] = genFKGreedy(A,C,U,P,b,rt);
        
        W = b-1;
        vs = U;
        ws = C;
        [minBag] = knapsack(ws,vs,W);
        fValUB4(rep) = minBag(end,end);
        
        [~,dist] = dijkP(A,P,rt);
        ws2 = ws + dist;
        [minBag] = knapsack(ws2,vs,W);
        fValLB4(rep) = minBag(end,end);
    end
    
    fValLKs4(thisB) = mean(fValLK4);
    fValFKs4(thisB) = mean(fValFK4);
    fValLBs4(thisB) = mean(fValLB4);
    fValUBs4(thisB) = mean(fValUB4);
    save('genFixedN2300To2400');
end






