N=1000;
% edgeFrac = 0.05;
% M=max(N-1,round(edgeFrac*N*(N-1)/2));
M=1500;
[A] = genMake(N,M);
maxUtil = 10;
maxCost = 10;
maxP = 10;
U = randi(maxUtil,[1,N]);
C = randi(maxCost,[1,N]);
P = randi(maxP,[1,N]);
% b = round(N/4+(maxCost+1)/2*N/2); % Probe N/4, attack N/2 or so
b = round(N/4*(maxP+1)/2+(maxCost+1)/2*N/4); % Probe N/4, attack N/2 or so
rt = 1;
% [atkOpt, proOpt, remBudOpt, fValOpt, timeOpt] = genIP(A,U,C,b,rt);
[atkLK, proLK, remBudLK, fValLK, timeLK] = genLKGreedy(A,U,C,P,b);
[atkFK, proFK, remBudFK, fValFK, timeFK] = genFKGreedy(A,C,U,P,b,rt);

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




