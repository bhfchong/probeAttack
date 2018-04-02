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

function [atkOpt, proOpt, remBudOpt, fValOpt, timeOpt] = treeIP(parents,U,C,P,b)
tic;
N = length(parents);
% First N are attack variables, second N are probe variables
f = [-U,zeros(1,N)];
intcon = 1:2*N;

subAleqX = zeros(N-1,N);
subAleqY = zeros(N-1,N);
for nod = 2:N
    subAleqX(nod-1,nod) = 1;
    subAleqY(nod-1,parents(nod)) = -1;    
end

Aleq = [C P; subAleqX,subAleqY; zeros(N-1,N),subAleqX+subAleqY];
bleq = [b;zeros(2*(N-1),1)];
Aeq = [];
beq = [];
lb = zeros(1,2*N);
ub = ones(1,2*N);

options=optimoptions('intlinprog','Display','off');
[xSol,fValOpt]=intlinprog(f,intcon,Aleq,bleq,Aeq,beq,lb,ub,options);
% [xSol,fValOpt]=intlinprog(f,intcon,Aleq,bleq,Aeq,beq,lb,ub);
xSol = round(xSol);
atk = xSol(1:N);
pro = xSol(N+1:end);
atkOpt = find(atk);
proOpt = find(pro);
remBudOpt = b-length(proOpt)-sum(C(atkOpt));
fValOpt = -fValOpt;
timeOpt=toc;
end

