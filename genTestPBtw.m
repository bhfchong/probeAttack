N=1000;
% edgeFrac = 0.05;
% M=max(N-1,round(edgeFrac*N*(N-1)/2));
M=1500;
fprintf('Generating Network\n');
[A] = genMake(N,M);
maxUtil = 10;
maxCost = 10;
maxP = 10;
U = randi(maxUtil,[1,N]);
C = randi(maxCost,[1,N]);

% degs = sum(A);
% P = round(maxP*degs/max(degs));

% P = randi(maxP,[1,N]); % 

fprintf('Calculating Betweenness\n');
bet = btw(A);
bet = bet/max(bet);
P = round(maxP*bet);

% b = round(N/4+(maxCost+1)/2*N/2); % Probe N/4, attack N/2 or so
% b = round(N/4*(maxP+1)/2+(maxCost+1)/2*N/4); % Probe N/4, attack N/2 or so
b = round(mean(P)*N/4 + mean(C)*N/2);
rt = 1;
% [atkOpt, proOpt, remBudOpt, fValOpt, timeOpt] = genIP(A,U,C,b,rt);
[~,~,~, fValLK, ~] = genLKGreedy(A,U,C,P,b);
[~,~,~, fValLKP, ~] = genLKPGreedy(A,U,C,P,b);
[~,~,~, fValLKPR, ~] = genLKPRGreedy(A,U,C,P,b);
[~,~,~, fValFK, ~] = genFKGreedy(A,C,U,P,b,rt);

%% Formulate as knapsack
fprintf('Beginning Knapsack\n');
W = b-1;
vs = U;
ws = C;
[minBag] = knapsack(ws,vs,W);
fValUB = minBag(end,end);

fprintf('Beginning Knapsack with Path Costs\n');
[~,dist] = dijkP(A,P,rt);
ws2 = ws + dist;
[minBag] = knapsack(ws2,vs,W);
fValLB = minBag(end,end);




