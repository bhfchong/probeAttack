%% Generates the intlinprog inputs for a given tree, utilities, and costs
% Inputs:
%   parents: 1xN vector of parent-pointers; describes a tree
%   U: 1xN vector of attack utilities
%   C: 1xN vector of attack costs
%   b: scalar total probe and attack budget
% Outputs:
%   atkOpt: vector of indices of attacked nodes
%   proOpt: vector of indices of probed nodes
%   fValOpt: solution value
%   timeOpt: time taken to run alg

function [atkOpt, proOpt, remBudOpt, fValOpt, timeOpt] = genIP(A,U,C,b,rt)
tic;
if nargin == 4
    rt = 1;
end

N = length(A);

%% Store all paths
numPaths = zeros(1,N);
allPaths = {};
for nod = 1:N
    paths = allPathsToRt(A,nod,rt);
%     numPaths(nod) = length(paths);
    
    % Remove (permutative) duplicate paths
    nPaths = length(paths);
    pathMat = zeros(nPaths,N);
    for path = 1:nPaths
        pathMat(path,paths{path}) = 1;
    end
    pathMat = unique(pathMat,'rows');
    nPathsUniq = size(pathMat,1);
    paths = cell(1,nPathsUniq);
    for path = 1:nPathsUniq
        paths{path} = find(pathMat(path,:));
    end
    numPaths(nod) = nPathsUniq;
        
    allPaths = [allPaths paths];
%     fprintf('Found paths for node %d\n',nod);
end
totPaths = sum(numPaths);
fprintf('Total paths: %d\n',totPaths);
z1N = zeros(1,N);
zN = zeros(N);
eN = eye(N);
z1P = zeros(1,totPaths);

% First N are attack variables, second N are probe variables, next totPaths
% are path variables
f = [-U,z1N,zeros(1,totPaths)];
intcon = 1:2*N+totPaths;

binVect = 2.^(0:N-1); % hax
pathMat1 = (fliplr(binVect)'*repelem(binVect,numPaths))==binVect(end);
Aleq1 = [eN,zN,-pathMat1; zN,eN,-pathMat1]; % [probe before attack; probe before probe
Aleq1([rt,rt+N],:) = []; % No constraints on root node
bleq1 = zeros(1,N + N-2);
fprintf('First set of constraints initialized\n');

% Path constraints (Path is active if all nodes on it have been probed)
Aleq2 = zeros(totPaths,N+totPaths);
pathLens = cellfun(@length,allPaths);
for path = 1:totPaths
    ys = z1N; ys(allPaths{path}) = -1;
    ps = z1P; ps(path) = pathLens(path);
    Aleq2(path,:) = [ys ps];   
end
Aleq2 = [zeros(totPaths,N) Aleq2];
bleq2 = zeros(1,totPaths); % RHS: - (|path| - 1)
fprintf('Second set of constraints initialized\n');

% Budget constraint
Aleq3 = [C z1N+1 z1P];
bleq3 = b;

Aleq = [Aleq1; Aleq2; Aleq3];
bleq = [bleq1 bleq2 bleq3];
Aeq = [];
beq = [];
lb = zeros(1,2*N+totPaths);
ub = ones(1,2*N+totPaths);

options=optimoptions('intlinprog','Display','off');
fprintf('Beginning optimization over %d variables\n',2*N+totPaths);
[xSol,fValOpt]=intlinprog(f,intcon,round(Aleq),round(bleq),Aeq,beq,lb,ub,options);
xSol = round(xSol);
atk = xSol(1:N);
pro = xSol(N+1:2*N);
atkOpt = find(atk);
proOpt = find(pro);
remBudOpt = b-length(proOpt)-sum(C(atkOpt));
fValOpt = -fValOpt;
timeOpt=toc;
end

