Ns=200:100:2000;
numNs = length(Ns);
edgeFrac = 0.05;
nReps = 30;
maxUtil = 10;
maxCost = 10;
maxP = 10;
fValLKs = zeros(1,numNs);
fValFKs = zeros(1,numNs);
fValUBs = zeros(1,numNs);
fValLBs = zeros(1,numNs);
rt = 1;

for n = 1:numNs
    N = Ns(n);
    M=max(N-1,round(edgeFrac*N*(N-1)/2));
    fValLK = zeros(1,nReps);
    fValFK = zeros(1,nReps);
    fValUB = zeros(1,nReps);
    fValLB = zeros(1,nReps);
    for rep = 1:nReps
        N
        rep
        [A] = genMake(N,M);
        U = randi(maxUtil,[1,N]);
        C = randi(maxCost,[1,N]);
        P = randi(maxP,[1,N]);
        b = round(N/4*(maxP+1)/2+(maxCost+1)/2*N/4);
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
    
    fValLKs(n) = mean(fValLK);
    fValFKs(n) = mean(fValFK);
    fValLBs(n) = mean(fValLB);
    fValUBs(n) = mean(fValUB);
    save('genFixedB');
end

%% Fixed N

clear;
N=1000;
edgeFrac = 0.05;
M=max(N-1,round(edgeFrac*N*(N-1)/2));
Bs = 1000:100:3000;
numBs = length(Bs);
nReps = 30;
maxUtil = 10;
maxCost = 10;
maxP = 10;
fValLKs = zeros(1,numBs);
fValFKs = zeros(1,numBs);
fValUBs = zeros(1,numBs);
fValLBs = zeros(1,numBs);
rt = 1;

for thisB = 1:numBs
    b = Bs(thisB);
    fValLK = zeros(1,nReps);
    fValFK = zeros(1,nReps);
    fValUB = zeros(1,nReps);
    fValLB = zeros(1,nReps);
    for rep = 1:nReps
        N
        rep
        [A] = genMake(N,M);
        U = randi(maxUtil,[1,N]);
        C = randi(maxCost,[1,N]);
        P = randi(maxP,[1,N]);
        b = round(N/4*(maxP+1)/2+(maxCost+1)/2*N/4);
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
    save('genFixedN');
end






