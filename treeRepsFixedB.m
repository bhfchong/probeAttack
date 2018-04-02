Ns = 100:100:2000;
brFact = 2;
nReps = 30;
maxUtil = 10;
maxCost = 10;
maxP = 10;
numNs = length(Ns);
fOpts = zeros(1,numNs);
fLKs = zeros(1,numNs);
fFKs = zeros(1,numNs);
varOpts = zeros(1,numNs);
varLKs = zeros(1,numNs);
varFKs = zeros(1,numNs);
for n=1:numNs
    N = Ns(n);
    b = round(N/4*(maxP+1)/2+(maxCost+1)/2*N/4); % Probe N/4, attack N/2 or so
    fOpt = zeros(1,nReps);
    fLK = zeros(1,nReps);
    fFK = zeros(1,nReps);
    for rep=1:nReps
        N
        rep
        [parents,pois] = treeMake(brFact, N);
        U = randi(maxUtil,[1,N]);
        C = randi(maxCost,[1,N]);
        P = randi(maxP,[1,N]);
        
        [~, ~, ~, fOpt(rep), ~] = treeIP(parents,U,C,P,b);
        [~, ~, ~, fLK(rep),~] = treeGreedy(parents,U,C,P,b);
        [~, ~, ~, fFK(rep), ~] = treeGreedyVis2(parents,U,C,P,b);
    end
    fOpts(n) = mean(fOpt);
    fLKs(n) = mean(fLK);
    fFKs(n) = mean(fFK);
    varOpts(n) = std(fOpt);
    varLKs(n) = std(fLK);
    varFKs(n) = std(fFK);
    save('newThang');
end

% plot(Ns,fOpts,Ns,fLKs,Ns,fFKs);
% legend('IP','LK-Greedy','FK-Greedy','Location','southeast');
% xlabel('Number of Nodes');
% ylabel('Solution value');
% title(['PAP on trees, averaged over ', int2str(nReps),' replications']);
% 



