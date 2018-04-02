%% Fixed N


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

for thisB = 1:5
    b = Bs(thisB);
    fValLK = zeros(1,nReps);
    fValFK = zeros(1,nReps);
    fValUB = zeros(1,nReps);
    fValLB = zeros(1,nReps);
    for rep = 1:nReps
        b
        rep
        [A] = genMake(N,M);
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
    
    fValLKs(thisB) = mean(fValLK);
    fValFKs(thisB) = mean(fValFK);
    fValLBs(thisB) = mean(fValLB);
    fValUBs(thisB) = mean(fValUB);
    save('genFixedN');
end






